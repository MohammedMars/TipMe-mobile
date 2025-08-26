import 'package:tipme_app/core/dio/client/dio_client.dart';
import 'package:tipme_app/core/storage/storage_service.dart';
import 'package:tipme_app/viewModels/apiResponse.dart';
import 'package:tipme_app/viewModels/verifyOtpData.dart';
import 'package:tipme_app/dtos/signInUpDto.dart';
import 'package:tipme_app/dtos/verifyOtpDto.dart';
import 'package:tipme_app/dtos/changeMobileNumberDto.dart';
import 'package:dio/dio.dart';
import 'package:tipme_app/services/cacheService.dart';
import 'package:tipme_app/services/tipReceiverService.dart';

class AuthTipReceiverService {
  final DioClient dioClient;
  final CacheService? cacheService;
  final TipReceiverService? tipReceiverService;

  AuthTipReceiverService(this.dioClient, {this.cacheService, this.tipReceiverService});

  Future<ApiResponse<void>> signUp(SignInUpDto dto) async {
    final response = await dioClient.post(
      'Signup',
      data: dto.toJson(),
    );
    return ApiResponse<void>.fromJson(
      response.data,
      (data) => null,
    );
  }

  Future<ApiResponse<VerifyOtpData>> verifyOtp(VerifyOtpDto dto) async {
    final response = await dioClient.post(
      'VerifyOtp',
      data: dto.toJson(),
    );
    return ApiResponse<VerifyOtpData>.fromJson(
      response.data,
      (data) => VerifyOtpData.fromJson(data),
    );
  }

  Future<ApiResponse<void>> completeProfile(FormData dto) async {
    final response = await dioClient.post(
      'CompleteProfile',
      data: dto,
      options: Options(contentType: 'multipart/form-data'),
    );
    return ApiResponse<void>.fromJson(response.data, (_) => null);
  }

  Future<ApiResponse<void>> editProfile(
      String userId, FormData formData) async {
    final response = await dioClient.put(
      'EditProfile/$userId',
      data: formData,
      options: Options(
        contentType: 'multipart/form-data',
        headers: {
          'Authorization': 'Bearer ${await StorageService.get("user_token")}',
        },
      ),
    );

    final apiResponse = ApiResponse<void>.fromJson(response.data, (_) => null);

    // If profile update was successful, clear cache and fetch fresh data
    if (apiResponse.success) {
      // Clear the user data cache
      if (cacheService != null) {
        cacheService!.clearUserDataCache(userId);
      }

      // Fetch fresh user data and cache it
      if (tipReceiverService != null) {
        try {
          await tipReceiverService!.GetMe();
        } catch (e) {
          print('Failed to refresh user data after profile update: $e');
        }
      }
    }

    return apiResponse;
  }

  Future<ApiResponse<void>> login(SignInUpDto dto) async {
    final response = await dioClient.post(
      'Login',
      data: dto.toJson(),
    );
    return ApiResponse<void>.fromJson(
      response.data,
      (data) => null,
    );
  }

  Future<ApiResponse<VerifyOtpData>> verifyLoginOtp(VerifyOtpDto dto) async {
    final response = await dioClient.post(
      'VerifyLoginOtp',
      data: dto.toJson(),
    );
    return ApiResponse<VerifyOtpData>.fromJson(
      response.data,
      (data) => VerifyOtpData.fromJson(data),
    );
  }

  Future<ApiResponse<String>> requestChangeMobileNumber(String userId, ChangeMobileNumberDto dto) async {
    final response = await dioClient.post(
      'ChangeMobileNumberRequest/$userId',
      data: dto.toJson(),
      options: Options(
        headers: {
          'Authorization': 'Bearer ${await StorageService.get("user_token")}',
        },
      ),
    );
    return ApiResponse<String>.fromJson(
      response.data,
      (data) => data?.toString() ?? '',
    );
  }
  
  Future<ApiResponse<String>> changeMobileNumber(String userId, VerifyOtpDto dto) async {
    final response = await dioClient.post(
      'ChangeMobileNumber/$userId',
      data: dto.toJson(),
      options: Options(
        headers: {
          'Authorization': 'Bearer ${await StorageService.get("user_token")}',
        },
      ),
    );

    final apiResponse = ApiResponse<String>.fromJson(
      response.data,
      (data) => data?.toString() ?? '',
    );

    // If mobile number change was successful, clear cache and fetch fresh data
    if (apiResponse.success) {
      // Clear the user data cache
      if (cacheService != null) {
        cacheService!.clearUserDataCache(userId);
      }

      // Fetch fresh user data and cache it
      if (tipReceiverService != null) {
        try {
          await tipReceiverService!.GetMe();
        } catch (e) {
          print('Failed to refresh user data after mobile number change: $e');
        }
      }
    }

    return apiResponse;
  }
}
