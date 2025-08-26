import 'package:tipme_app/core/dio/client/dio_client.dart';
import 'package:tipme_app/viewModels/qrCodeData.dart';
import 'package:tipme_app/viewModels/tipReceiveerData.dart';
import 'package:tipme_app/viewModels/tipReceiverStatisticsData.dart';
import '../models/country.dart';

class CacheService {
  static CacheService? _instance;
  final DioClient dioClient;

  static const Duration STATISTICS_CACHE_DURATION = Duration(minutes: 1);

  CacheService(this.dioClient);

  factory CacheService.instance(DioClient dioClient) {
    _instance ??= CacheService(dioClient);
    return _instance!;
  }

  List<Country>? _countries;
  final Map<String, QRCodeData> _qrCodeCache = {};
  final Map<String, TipReceiveerData> _userDataCache = {};

  // Statistics cache with timestamps
  final Map<String, TipReceiverStatisticsData> _statisticsCache = {};
  final Map<String, DateTime> _statisticsTimestamps = {};

  // Transactions cache with timestamps
  final Map<String, Map<String, dynamic>> _transactionsCache = {};
  final Map<String, DateTime> _transactionsTimestamps = {};

  // Balance cache with timestamps
  final Map<String, dynamic> _balanceCache = {};
  final Map<String, DateTime> _balanceTimestamps = {};

  Future<List<Country>> getCountries() async {
    if (_countries != null) return _countries!;

    final response = await dioClient.get('Countries');
    final Map<String, dynamic> responseData = response.data;
    final List<dynamic> data = responseData['data'];
    _countries = data.map((json) => Country.fromJson(json)).toList();
    return _countries!;
  }

  void clearCountriesCache() {
    _countries = null;
  }

  Future<List<City>> getCities(String countryId) async {
    final response = await dioClient.get('Cities/$countryId');
    final Map<String, dynamic> responseData = response.data;
    final List<dynamic> data = responseData['data'];
    return data.map((json) => City.fromJson(json)).toList();
  }

  Future<List<String>> getNationalities() async {
    final countries = await getCountries();
    return countries.map((c) => c.nationality).toList();
  }

  QRCodeData? getQRCodeFromCache(String userId) {
    final cacheKey = 'qr_code_$userId';
    if (_qrCodeCache.containsKey(cacheKey)) {
      return _qrCodeCache[cacheKey];
    }

    return null;
  }

  void cacheQRCode(String userId, QRCodeData qrCode) {
    final cacheKey = 'qr_code_$userId';
    _qrCodeCache[cacheKey] = qrCode;
  }

  void clearQRCodeCache(String userId) {
    final cacheKey = 'qr_code_$userId';
    _qrCodeCache.remove(cacheKey);
  }

  TipReceiveerData? getUserDataFromCache(String userId) {
    final cacheKey = 'user_data_$userId';
    if (_userDataCache.containsKey(cacheKey)) {
      return _userDataCache[cacheKey];
    }
    return null;
  }

  void cacheUserData(String userId, TipReceiveerData userData) {
    final cacheKey = 'user_data_$userId';
    _userDataCache[cacheKey] = userData;
  }

  void clearUserDataCache(String userId) {
    final cacheKey = 'user_data_$userId';
    _userDataCache.remove(cacheKey);
  }

  TipReceiverStatisticsData? getStatisticsFromCache(String cacheKey) {
    if (_statisticsCache.containsKey(cacheKey) &&
        _statisticsTimestamps.containsKey(cacheKey)) {
      final cachedTime = _statisticsTimestamps[cacheKey]!;
      final now = DateTime.now();

      if (now.difference(cachedTime) < STATISTICS_CACHE_DURATION) {
        return _statisticsCache[cacheKey];
      }
    }
    return null;
  }

  void cacheStatistics(String cacheKey, TipReceiverStatisticsData statistics) {
    _statisticsCache[cacheKey] = statistics;
    _statisticsTimestamps[cacheKey] = DateTime.now();

    clearAllTransactionsCache();
    clearAllBalanceCache();
  }

  void clearStatisticsCache(String cacheKey) {
    _statisticsCache.remove(cacheKey);
    _statisticsTimestamps.remove(cacheKey);
  }

  void clearAllStatisticsCache() {
    _statisticsCache.clear();
    _statisticsTimestamps.clear();
  }

  Map<String, dynamic>? getTransactionsFromCache(String cacheKey) {
    if (_transactionsCache.containsKey(cacheKey) &&
        _transactionsTimestamps.containsKey(cacheKey)) {
      final cachedTime = _transactionsTimestamps[cacheKey]!;
      final now = DateTime.now();

      if (now.difference(cachedTime) < STATISTICS_CACHE_DURATION) {
        return _transactionsCache[cacheKey];
      }
    }
    return null;
  }

  void cacheTransactions(String cacheKey, Map<String, dynamic> transactions) {
    _transactionsCache[cacheKey] = transactions;
    _transactionsTimestamps[cacheKey] = DateTime.now();

    clearAllStatisticsCache();
    clearAllBalanceCache();
  }

  void clearTransactionsCache(String cacheKey) {
    _transactionsCache.remove(cacheKey);
    _transactionsTimestamps.remove(cacheKey);
  }

  void clearAllTransactionsCache() {
    _transactionsCache.clear();
    _transactionsTimestamps.clear();
  }

  dynamic getBalanceFromCache(String cacheKey) {
    if (_balanceCache.containsKey(cacheKey) &&
        _balanceTimestamps.containsKey(cacheKey)) {
      final cachedTime = _balanceTimestamps[cacheKey]!;
      final now = DateTime.now();

      if (now.difference(cachedTime) < STATISTICS_CACHE_DURATION) {
        return _balanceCache[cacheKey];
      }
    }
    return null;
  }

  void cacheBalance(String cacheKey, dynamic balance) {
    _balanceCache[cacheKey] = balance;
    _balanceTimestamps[cacheKey] = DateTime.now();

    clearAllStatisticsCache();
    clearAllTransactionsCache();
  }

  void clearBalanceCache(String cacheKey) {
    _balanceCache.remove(cacheKey);
    _balanceTimestamps.remove(cacheKey);
  }

  void clearAllBalanceCache() {
    _balanceCache.clear();
    _balanceTimestamps.clear();
  }

  void clearAllCache() {
    clearCountriesCache();
    _qrCodeCache.clear();
    _userDataCache.clear();
    clearAllStatisticsCache();
    clearAllTransactionsCache();
    clearAllBalanceCache();
  }
}
