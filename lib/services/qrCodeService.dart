import 'package:dio/dio.dart';
import 'package:tipme_app/core/dio/client/dio_client.dart';
import 'package:tipme_app/core/storage/storage_service.dart';
import 'package:tipme_app/dtos/generateQRCodeDto.dart';
import 'package:tipme_app/services/cacheService.dart';
import 'package:tipme_app/viewModels/apiResponse.dart';
import 'package:tipme_app/viewModels/qrCodeData.dart';

class QRCodeService {
  final DioClient dioClient;
  final CacheService? cacheService;

  QRCodeService(this.dioClient, {this.cacheService});

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

      // Clear cache before generating new QR code
      if (cacheService != null) {
        cacheService!.clearQRCodeCache(userId);
      }

      ApiResponse<QRCodeData>? response;

      if (dto.logo != null) {
        final formData = FormData.fromMap({
          'logo': MultipartFile.fromBytes(
            dto.logo!,
            filename: 'logo.jpg',
          ),
        });

        final apiResponse = await dioClient.post(
          'Generate/$userId',
          data: formData,
          options: await _getAuthOptions(),
        );

        response = ApiResponse<QRCodeData>.fromJson(
          apiResponse.data,
          (data) => QRCodeData.fromJson(data),
        );
      } else {
        final apiResponse = await dioClient.post(
          'Generate/$userId',
          data: {},
          options: await _getAuthOptions(),
        );

        response = ApiResponse<QRCodeData>.fromJson(
          apiResponse.data,
          (data) => QRCodeData.fromJson(data),
        );
      }

      // Cache the newly generated QR code
      if (response != null &&
          response.success &&
          response.data != null &&
          cacheService != null) {
        cacheService!.cacheQRCode(userId, response.data!);
        print('QRCodeService: Cached newly generated QR code');
      }

      return response;
    } catch (e) {
      print('Generate QR Code error: $e');
      rethrow;
    }
  }

  Future<ApiResponse<QRCodeData>?> getQRCode() async {
    try {
      final userId = await _getUserId();
      if (userId == null) throw Exception('User ID not found');
      // Try to get from cache first
      if (cacheService != null) {
        final cachedQRCode = cacheService!.getQRCodeFromCache(userId);
        if (cachedQRCode != null) {
          return ApiResponse<QRCodeData>(
            success: true,
            message: 'QR Code loaded from cache',
            data: cachedQRCode,
            errors: [],
            errorCode: null,
          );
        }
      }
      final response = await dioClient.get(
        userId,
        options: await _getAuthOptions(),
      );

      final apiResponse = ApiResponse<QRCodeData>.fromJson(
        response.data,
        (data) => QRCodeData.fromJson(data),
      );

      // Cache the fetched QR code
      if (apiResponse.success &&
          apiResponse.data != null &&
          cacheService != null) {
        cacheService!.cacheQRCode(userId, apiResponse.data!);
      }

      return apiResponse;
    } catch (e) {
      print('QRCodeService: Get QR Code error: $e');

      // On error, try to return cached data if available
      if (cacheService != null) {
        final userId = await _getUserId();
        if (userId != null) {
          final cachedQRCode = cacheService!.getQRCodeFromCache(userId);
          if (cachedQRCode != null) {
            return ApiResponse<QRCodeData>(
              success: true,
              message: 'QR Code loaded from cache (offline)',
              data: cachedQRCode,
              errors: [],
              errorCode: null,
            );
          }
        }
      }

      rethrow;
    }
  }

  Future<void> clearCache() async {
    if (cacheService != null) {
      final userId = await _getUserId();
      if (userId != null) {
        cacheService!.clearQRCodeCache(userId);
      }
    }
  }
}
