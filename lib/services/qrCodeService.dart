import 'package:dio/dio.dart';
import 'package:tipme_app/core/dio/client/dio_client.dart';
import 'package:tipme_app/core/storage/storage_service.dart';
import 'package:tipme_app/dtos/generateQRCodeDto.dart';
import 'package:tipme_app/viewModels/apiResponse.dart';
import 'package:tipme_app/viewModels/qrCodeData.dart';

class QRCodeService {
  final DioClient dioClient;
  QRCodeService(this.dioClient);

  Future<Options> _getAuthOptions() async {
    final token = await StorageService.get("user_token");
    return Options(
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
  }

  Future<String?> _getUserId() async {
    return await StorageService.get('user_id');
  }

  Future<ApiResponse<QRCodeData>?> generateQRCode(GenerateQRCodeDto dto) async {
    try {
      final userId = await _getUserId();
      if (userId == null) throw Exception('User ID not found');

      if (dto.logo != null) {
        final formData = FormData.fromMap({
          'logo': MultipartFile.fromBytes(
            dto.logo!,
            filename: 'logo.jpg',
          ),
        });

        final response = await dioClient.post(
          'Generate/$userId',
          data: formData,
          options: await _getAuthOptions(),
        );

        return ApiResponse<QRCodeData>.fromJson(
          response.data,
          (data) => QRCodeData.fromJson(data),
        );
      } else {
        final response = await dioClient.post(
          'Generate/$userId',
          data: {},
          options: await _getAuthOptions(),
        );

        return ApiResponse<QRCodeData>.fromJson(
          response.data,
          (data) => QRCodeData.fromJson(data),
        );
      }
    } catch (e) {
      // Handle error appropriately
      print('Generate QR Code error: $e');
      rethrow;
    }
  }

  Future<ApiResponse<QRCodeData>?> getQRCode() async {
    try {
      final userId = await _getUserId();
      if (userId == null) throw Exception('User ID not found');

      final response = await dioClient.get(
        userId,
        options: await _getAuthOptions(),
      );

      return ApiResponse<QRCodeData>.fromJson(
        response.data,
        (data) => QRCodeData.fromJson(data),
      );
    } catch (e) {
      print('Get QR Code error: $e');
      rethrow;
    }
  }

  Future<bool> IsQRCodeExists() async {
    try {
      final userId = await _getUserId();
      if (userId == null) throw Exception('User ID not found');

      final response = await dioClient.get(
        userId,
        options: await _getAuthOptions(),
      );
      var data = ApiResponse<QRCodeData>.fromJson(
        response.data,
        (data) => QRCodeData.fromJson(data),
      );
      return data.success;
    } catch (e) {
      print('Is QR Code exists error: $e');
      return false;
    }
  }
}
