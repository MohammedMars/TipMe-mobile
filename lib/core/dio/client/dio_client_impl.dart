//lib\core\dio\client\dio_client_impl.dart
import 'package:dio/dio.dart';
import 'package:tipme_app/core/dio/client/dio_client.dart';
import 'package:tipme_app/core/dio/service/api_service_type.dart';

class DioClientImpl extends DioClient {
  final Dio _dio;

  DioClientImpl(this._dio, ApiServiceType apiServiceType)
      : super(apiServiceType);

  void updateBaseUrl(String baseUrl) {
    _dio.options.baseUrl = baseUrl;
  }

  @override
  Future<Response<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? query,
    Options? options,
    CancelToken? cancelTocken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onRecieveProgress,
  }) {
    return _dio.post(
      path,
      data: data,
      queryParameters: query,
      options: options,
      cancelToken: cancelTocken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onRecieveProgress,
    );
  }

  @override
  Future<Response<T>> get<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? query,
    Options? options,
    CancelToken? cancelTocken,
    ProgressCallback? onRecieveProgress,
  }) {
    return _dio.get(
      path,
      data: data,
      queryParameters: query,
      options: options,
      cancelToken: cancelTocken,
      onReceiveProgress: onRecieveProgress,
    );
  }

  @override
  Future<Response<T>> delete<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? query,
    Options? options,
    CancelToken? cancelTocken,
  }) {
    return _dio.delete(
      path,
      data: data,
      queryParameters: query,
      options: options,
      cancelToken: cancelTocken,
    );
  }

  @override
  Future<Response<T>> put<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? query,
    Options? options,
    CancelToken? cancelTocken,
    ProgressCallback? onRecieveProgress,
  }) {
    return _dio.put(
      path,
      data: data,
      queryParameters: query,
      options: options,
      onReceiveProgress: onRecieveProgress,
    );
  }
}
