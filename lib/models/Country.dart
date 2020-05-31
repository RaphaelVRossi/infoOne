class Country {
  final String recordType;
  final String countryCode;
  final String description;

  Country({this.recordType, this.countryCode, this.description});

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      recordType: json['record_type'],
      countryCode: json['country_code'],
      description: json['description'],
    );
  }
}
