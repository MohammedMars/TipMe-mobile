import 'package:tipme_app/core/dio/client/dio_client.dart';
import '../models/country.dart';

class CacheService {
  static CacheService? _instance;

  final DioClient _dioClient;

  // Private constructor
  CacheService._internal(this._dioClient);

  // Initialize with DioClient
  factory CacheService(DioClient dioClient) {
    _instance ??= CacheService._internal(dioClient);
    return _instance!;
  }

  List<Country>? _countries;

  Future<List<Country>> getCountries() async {
    if (_countries != null) return _countries!;

    final response = await _dioClient.get('Countries');
    final List countriesJson = response.data['data'];
    _countries =
        countriesJson.map((e) => Country.fromJson(e)).toList().cast<Country>();
    return _countries!;
  }

  void clearCountriesCache() {
    _countries = null;
  }

  Future<List<City>> getCities(String countryId) async {
    final countries = await getCountries();

    final country = countries.firstWhere(
      (c) => c.id == countryId,
      orElse: () => throw Exception("Country not found"),
    );

    if (country.cities != null && country.cities!.isNotEmpty) {
      return country.cities!;
    }

    final response = await _dioClient.get('Cities/$countryId');
    final List citiesJson = response.data['data'];
    final cities =
        citiesJson.map((e) => City.fromJson(e)).toList().cast<City>();
    country.cities = cities;
    return cities;
  }

  Future<List<String>> getNationalities() async {
    final countries = await getCountries();
    return countries.map((c) => c.nationality).toList();
  }
}
