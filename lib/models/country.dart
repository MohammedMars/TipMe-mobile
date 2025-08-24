class City {
  final String id;
  final String name;

  City({required this.id, required this.name});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'],
      name: json['name'],
    );
  }
}

class Country {
  final String id;
  final String name;
  final String code;
  final String phoneCode;
  String nationality;
  final String currency;
  List<City> cities;
  final String flag;
  Country({
    required this.id,
    required this.name,
    required this.code,
    required this.phoneCode,
    required this.nationality,
    required this.currency,
    required this.cities,
    required this.flag,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      phoneCode: json['phoneCode'],
      nationality: json['nationality'],
      currency: json['currency'],
      cities: (json['cities'] as List).map((city) => City.fromJson(city)).toList(),
      flag: json['code'],
    );
  }
}
