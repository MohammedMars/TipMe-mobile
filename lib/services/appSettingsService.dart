import 'package:dio/dio.dart';
import 'package:tipme_app/core/dio/client/dio_client.dart';
import 'package:tipme_app/core/storage/storage_service.dart';
import 'package:tipme_app/viewModels/apiResponse.dart';
import 'package:tipme_app/viewModels/contactSupportData.dart';
import 'package:tipme_app/viewModels/faqData.dart';

class AppSettingsService {
  final DioClient _dioClient;

  AppSettingsService(this._dioClient);
  Future<Options> _getAuthOptions() async {
    final token = await StorageService.get("user_token");
    return Options(
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
  }
  Future<ApiResponse<String>> getPrivacyPolicy({String lang = 'en'}) async {
    try {
      final response = await _dioClient.get(
        'PrivacyPolicy/$lang',
        options: await _getAuthOptions(),
      );

      return ApiResponse<String>.fromJson(
        response.data,
        (data) => data as String,
      );
    } catch (e) {
      print('Error getting privacy policy: $e');
      rethrow;
    }
  }

  Future<ApiResponse<String>> getTermsAndConditions(
      {String lang = 'en'}) async {
    try {
      final response = await _dioClient.get(
        'TermsAndConditions/$lang',
        options: await _getAuthOptions(),
      );

      return ApiResponse<String>.fromJson(
        response.data,
        (data) => data as String,
      );
    } catch (e) {
      print('Error getting terms and conditions: $e');
      rethrow;
    }
  }

  Future<ApiResponse<List<FAQData>>> getFAQ({String lang = 'en'}) async {
    try {
      final response = await _dioClient.get(
        'FAQ/$lang',
        options: await _getAuthOptions(),
      );

      return ApiResponse<List<FAQData>>.fromJson(
        response.data,
        (data) => (data as List).map((e) => FAQData.fromJson(e)).toList(),
      );
    } catch (e) {
      print('Error getting FAQ: $e');
      rethrow;
    }
  }

  Future<ApiResponse<ContactSupportData>> getContactSupport(
      {String lang = 'en'}) async {
    try {
      final response = await _dioClient.get(
        'ContactSupport/$lang',
        options: await _getAuthOptions(),
      );

      return ApiResponse<ContactSupportData>.fromJson(
        response.data,
        (data) => ContactSupportData.fromJson(data),
      );
    } catch (e) {
      print('Error getting contact support: $e');
      rethrow;
    }
  }
}
