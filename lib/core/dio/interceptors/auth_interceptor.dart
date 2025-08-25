import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tipme_app/core/storage/storage_service.dart';
import 'package:tipme_app/services/cacheService.dart';
import 'package:tipme_app/routs/app_routs.dart';
import 'package:tipme_app/di/gitIt.dart';

class AuthInterceptor extends Interceptor {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      await _handleUnauthorized();
    }
    super.onError(err, handler);
  }

  Future<void> _handleUnauthorized() async {
    try {
      // Clear all cache
      final cacheService = sl<CacheService>();
      cacheService.clearAllCache();

      // Clear all storage
      await StorageService.clear();

      // Navigate to login page
      final context = navigatorKey.currentContext;
      if (context != null) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          AppRoutes.signInUp,
          (route) => false,
        );
      }
    } catch (e) {
      print('Error handling 401 unauthorized: $e');
    }
  }
}
