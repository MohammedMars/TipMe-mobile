//lib\core\dio\dio_factory.dart
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:tipme_app/core/dio/interceptors/auth_interceptor.dart';

abstract final class DioFactory {
  static Dio createDioInstance({
    required String baseURL,
    List<Interceptor>? interceptors,
  }) {
    final dio = Dio(
      BaseOptions(
          baseUrl: baseURL,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30)),
    );
    
    // Add AuthInterceptor first to handle 401 errors
    dio.interceptors.add(AuthInterceptor());
    
    if (interceptors != null) {
      dio.interceptors.addAll(interceptors);
    }
    if (kDebugMode) {
      dio.interceptors.add(PrettyDioLogger(
          request: true,
          requestBody: true,
          responseBody: true,
          responseHeader: true));
    }
    return dio;
  }
}
