import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:infoone/models/Country.dart';
import 'package:infoone/utils/fetch_preview.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:carousel_slider/carousel_slider.dart';

//import 'package:link_preview/link_preview.dart';
import 'package:url_launcher/url_launcher.dart';

class CountryPage extends StatefulWidget {
  final Country country;

  CountryPage({Country country}) : this.country = country;

  @override
  State<StatefulWidget> createState() => new _CountryPageState(country);
}

// Used for controlling whether the user is loggin or creating an account
class _CountryPageState extends State<CountryPage> {
  _CountryPageState(this.country);

  final Country country;

  final List linkList = [
    'https://www.ncbi.nlm.nih.gov/research/coronavirus/publication/32462677',
    'https://www.ncbi.nlm.nih.gov/research/coronavirus/publication/32460378',
    'https://www.ncbi.nlm.nih.gov/research/coronavirus/publication/32452838',
    'https://www.ncbi.nlm.nih.gov/research/coronavirus/publication/32452050',
    'https://www.ncbi.nlm.nih.gov/research/coronavirus/publication/32445875',
    'https://www.ncbi.nlm.nih.gov/research/coronavirus/publication/32444823',
  ];

//  LinkPreview previwer = LinkPreview();

  List<Widget> widgetList = <Widget>[];

  List dataList = List();

  @override
  void initState() {
    widgetList.add(_buildCardCovid());
    widgetList.add(_buildCardMap());

    linkList.forEach((element) {
//      FetchPreview().fetch(element).then((res) {
//        setState(() {
      updateLinkPreview(element);
//        });
//      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new ModalProgressHUD(
        child: new Scaffold(
          appBar: AppBar(
              title: Text(
                  'Info One ${country == null ? '' : '- ' + country.description}')),
          body: new Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                    Colors.purple,
                    Colors.blue,
                    Colors.purpleAccent
                  ])),
              padding: EdgeInsets.all(16.0),
              child: Center(
                  child: new ListView.builder(
                      itemCount: widgetList.length,
                      itemBuilder: (BuildContext ctxt, int Index) {
                        return widgetList[Index];
                      })
//                child: ListView(
//                  children: widgetList,
//                ),
                  )),
        ),
        inAsyncCall: false);
  }

  _buildCardCovid() {
    return Card(
      elevation: 10,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const ListTile(
            leading: Icon(Icons.format_list_numbered),
            title: Text('Covid-19 Information'),
            subtitle: Text('Show information'),
          ),
          CarouselSlider(
            items: [
              Image(image: AssetImage('assets/Total.png')),
              Image(image: AssetImage('assets/GlobalDeath.png')),
            ],
            options: CarouselOptions(
              height: 200,
              aspectRatio: 16 / 9,
              viewportFraction: 0.8,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              scrollDirection: Axis.horizontal,
            ),
          ),
        ],
      ),
    );
  }

  _buildCardMap() {
    return Card(
      elevation: 10,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const ListTile(
            leading: Icon(Icons.map),
            title: Text('Map information'),
            subtitle: Text('Show information'),
          ),
          CarouselSlider(
            items: [
              Image(image: AssetImage('assets/CovidMap.png')),
              Image(image: AssetImage('assets/TempMap.png')),
              Image(image: AssetImage('assets/WeatherMap.png')),
            ],
            options: CarouselOptions(
              height: 500,
              aspectRatio: 16 / 9,
              viewportFraction: 0.8,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              scrollDirection: Axis.horizontal,
            ),
          ),
        ],
      ),
    );
  }

  _buildPreviewWidget(data) {
    if (data == null) {
      return Container();
    }
    return Card(
      elevation: 10,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const ListTile(
            leading: Icon(Icons.link),
            title: Text('More Information'),
            subtitle: Text('Link'),
          ),
          new InkWell(child: new Text(data), onTap: () => launch(data)),
        ],
      ),
    );
  }

  /*Padding(
  padding: const EdgeInsets.all(16.0),
  child: Container(
  color: Colors.lightGreen[100],
  child: Padding(
  padding: const EdgeInsets.all(8.0),
  child: Row(
  children: <Widget>[
  Image.network(
  data['image'],
  height: 100,
  width: 100,
  fit: BoxFit.cover,
  ),
  Flexible(
  child: Padding(
  padding: const EdgeInsets.all(8.0),
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: <Widget>[
  Text(
  data['title'],
  style: TextStyle(
  fontWeight: FontWeight.bold,
  color: Colors.black),
  ),
  SizedBox(
  height: 4,
  ),
  Text(
  data['description'],
  ),
  SizedBox(
  height: 4,
  ),
  Row(
  children: <Widget>[
  Image.network(
  data['favIcon'],
  height: 12,
  width: 12,
  ),
  SizedBox(
  width: 4,
  ),
  Text(data['url'],
  style: TextStyle(
  color: Colors.grey, fontSize: 12))
  ],
  )
  ],
  ),
  )),
  ],
  ),
  ),
  )*/

  updateLinkPreview(res) {
    setState(() {
      widgetList.add(_buildPreviewWidget(res));
//      widgetList.add(_buildCardCovid());
    });
  }
}
