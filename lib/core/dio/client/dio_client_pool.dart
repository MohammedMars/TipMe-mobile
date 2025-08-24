//lib\core\dio\client\dio_client_pool.dart
import 'package:tipme_app/core/dio/client/dio_client.dart';
import 'package:tipme_app/core/dio/service/api_service_type.dart';
import 'package:tipme_app/core/dio/service/service_configration.dart';

class DioClientPool {
  DioClientPool._();
  static final DioClientPool _instance = DioClientPool._();
  static DioClientPool get instance => _instance;
  final Map<ApiServiceType, DioClient> _clients = {};
  final Map<ApiServiceType, String> _baseUrl = {};
  void init() {
    final urls = ServiceConfigration().config;
    _baseUrl.addAll(urls);
  }

  String findUrl(ApiServiceType apiServiceType) {
    return _baseUrl[apiServiceType] ?? "";
  }

  void register(DioClient client, ApiServiceType apiServiceType) {
    _clients[apiServiceType] = client;
  }
}
