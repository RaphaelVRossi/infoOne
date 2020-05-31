import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:infoone/models/Country.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:infoone/utils/fake_html.dart' if (dart.library.html) 'dart:html'
as html;
import 'package:infoone/utils/fake_ui.dart' if (dart.library.html) 'dart:ui'
as ui;

import 'CountryPage.dart';
import 'package:http/http.dart' as http;

final Random _random = Random();

final List countryList = List();

bool isLoading = false;

Country _country;

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

// Used for controlling whether the user is loggin or creating an account
class _HomePageState extends State<HomePage> {
//  _HomePageState();

  @override
  void initState() {
    super.initState();
    getAllCountries();
  }

  @override
  Widget build(BuildContext context) {
    final String assetName = 'assets/world.svg';
    final Widget svg = SvgPicture.asset(
      assetName,
      semanticsLabel: 'Acme Logo',
    );

    return Scaffold(
        appBar: AppBar(title: Text('InfoOne')),
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Colors.purple, Colors.blue, Colors.purpleAccent])),
          child: createCenter(svg, context),
        ),
        bottomNavigationBar: Container(
          height: 25.0,
          padding: EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            color: Colors.purple
          ),
          child: Row(
            textDirection: TextDirection.rtl,
            children: [
              Text('Porwered by NASA',
              style: TextStyle(color: Colors.white),)
            ],
          ),
        )
    );
  }

  getAllCountries() async {
    setState(() {
      isLoading = true;
    });
    final response = await http.get(
        'https://data.cityofnewyork.us/resource/j2iz-mwzu.json',
        headers: {'X-App-Token': 'KVW1v7pjTf24PikiNIXbESe8v'});

    setState(() {
      isLoading = false;
    });
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      List list = json.decode(response.body) as List;

      list.forEach((element) {
        countryList.add(Country.fromJson(element));
      });
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  changedDropDownItem(Country country) {
    setState(() {
      _country = country;
    });
  }

  Widget createCenter(svg, context) {
    Widget container;

    if (kIsWeb) {
      container = Container(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: ListView(
              children: [
                Card(
                  color: Colors.transparent,
                  child: asset('assets/world.svg', context,
                      height: 500, width: 1000),
                ),
                Card(
                  child: Row(
                    children: [
                      isLoading
                          ? Text('')
                          : DropdownButton(
                        value: _country,
                        items: getDropDownMenuItems(),
                        onChanged: changedDropDownItem,
                      ),
                      FlatButton(
                        onPressed: () {
                          openCountryPageHtml(context);
                        },
                        padding: EdgeInsets.all(0.0),
                        child: Text('Next'),
                      )
                    ],
                  ),
                )
              ],
            ),
          ));
    } else {
      container = Container(
        margin: const EdgeInsets.symmetric(
          vertical: 0.0,
          horizontal: 0.0,
        ),
        height: 600.0,
        child: ClipRect(
          child: PhotoView.customChild(
            backgroundDecoration: BoxDecoration(
              color: Colors.transparent,
            ),
            child: svg,
            maxScale: PhotoViewComputedScale.covered * 6.0,
            minScale: PhotoViewComputedScale.contained * 0.8,
            initialScale: PhotoViewComputedScale.covered * 1.5,
            onTapDown: (context, details, controllerValue) =>
                openCountryPage(context),
          ),
        ),
      );
    }

    return Center(child: container);
  }

  Widget asset(String assetName, context,
      {double width = 24,
        double height = 24,
        BoxFit fit = BoxFit.contain,
        Color color,
        String semanticsLabel}) {
    if (kIsWeb) {
      String hashCode = assetName.replaceAll('/', '-').replaceAll('.', '-');
      return FutureBuilder(
          future: rootBundle.loadString(assetName),
          builder: (BuildContext contextBuild, AsyncSnapshot<String> snapshot) {
            if (snapshot.hasData) {
              return string(snapshot.data, context,
                  width: width, height: height, hashCode: hashCode);
            } else if (snapshot.hasError) {
              return Container(
                width: width,
                height: width,
              );
            } else {
              return Container(
                width: width,
                height: width,
              );
            }
          });
    }

    return SvgPicture.asset(assetName,
        width: width,
        height: height,
        fit: fit,
        color: color,
        semanticsLabel: semanticsLabel);
  }

  Widget string(String svgString, context,
      {double width = 24, double height = 24, String hashCode}) {
    if (kIsWeb) {
      hashCode ??= String.fromCharCodes(
          List<int>.generate(128, (i) => _random.nextInt(256)));
      ui.platformViewRegistry.registerViewFactory('img-svg-$hashCode',
              (int viewId) {
            final String base64 = base64Encode(utf8.encode(svgString));
            final String base64String = 'data:image/svg+xml;base64,$base64';
            final html.ImageElement element = html.ImageElement(
                src: base64String, height: width.toInt(), width: width.toInt());
            return element;
          });
      return Container(
        width: width,
        height: width,
        alignment: Alignment.center,
        child: HtmlElementView(
          viewType: 'img-svg-$hashCode',
        ),
      );
    }
    return SvgPicture.string(svgString);
  }

//GestureDetector(
//        onTap: () => openCountryPage(context),
//        child: HtmlElementView(
//          viewType: 'img-svg-$hashCode',
//        ),
//      ),

  openCountryPageHtml(context) {
    print('Call');
//  Navigator.pushNamed(context, '/country');
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => CountryPage(country: _country)));
  }

  openCountryPage(context) {
    Country country =
    new Country(recordType: 'T', countryCode: 'BR', description: 'BRAZIL');
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => new CountryPage(country: country)));
  }

  List<DropdownMenuItem<Country>> getDropDownMenuItems() {
    List<DropdownMenuItem<Country>> items = new List();
    for (Country country in countryList) {
      // here we are creating the drop down menu items, you can customize the item right here
      // but I'll just use a simple text for this
      items.add(new DropdownMenuItem(
          value: country, child: new Text(country.description)));
    }
    return items;
  }
}

class Painter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(Offset.zero, size.bottomRight(Offset.zero), Paint());
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // bad, but okay for example
    return true;
  }
}