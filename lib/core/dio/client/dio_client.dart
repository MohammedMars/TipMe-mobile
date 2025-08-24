//lib\core\dio\client\api_client.dart
import 'package:dio/dio.dart';
import 'package:tipme_app/core/dio/client/dio_client_impl.dart';
import 'package:tipme_app/core/dio/service/api_service_type.dart';

abstract class DioClient {
  final ApiServiceType apiService;

  DioClient(this.apiService);
  static DioClient create(Dio dio, ApiServiceType apiServiceType) =>
      DioClientImpl(dio, apiServiceType);

  void updateBaseUrl(String baseUrl);

  Future<Response<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? query,
    Options? options,
    CancelToken? cancelTocken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onRecieveProgress,
  });

  Future<Response<T>> get<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? query,
    Options? options,
    CancelToken? cancelTocken,
    ProgressCallback? onRecieveProgress,
  });

  Future<Response<T>> delete<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? query,
    Options? options,
    CancelToken? cancelTocken,
  });

  Future<Response<T>> put<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? query,
    Options? options,
    CancelToken? cancelTocken,
    ProgressCallback? onRecieveProgress,
  });
}
