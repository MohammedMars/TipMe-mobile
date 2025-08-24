import 'package:tipme_app/core/dio/client/dio_client.dart';
import 'package:tipme_app/core/storage/storage_service.dart';
import 'package:tipme_app/viewModels/apiResponse.dart';
import 'package:tipme_app/viewModels/verifyOtpData.dart';
import 'package:tipme_app/dtos/signInUpDto.dart';
import 'package:tipme_app/dtos/verifyOtpDto.dart';
import 'package:dio/dio.dart';

class AuthTipReceiverService {
  final DioClient dioClient;

  AuthTipReceiverService(this.dioClient);

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
    return ApiResponse<void>.fromJson(response.data, (_) => null);
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
}
