import 'package:dio/dio.dart';
import 'package:tipme_app/core/dio/client/dio_client.dart';
import 'package:tipme_app/core/storage/storage_service.dart';
import 'package:tipme_app/viewModels/apiResponse.dart';
import 'package:tipme_app/viewModels/settingsData.dart';

class SettingsService {
  final DioClient _dioClient;

  SettingsService(this._dioClient);

  Future<ApiResponse<TipReceiveerSettingsData>?> getSettings() async {
    try {
      final user_id = await StorageService.get("user_id");
      final token = await StorageService.get("user_token");
      if (token == null) return null;

      final response = await _dioClient.get(
        user_id!,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.data != null) {
        return ApiResponse<TipReceiveerSettingsData>.fromJson(
          response.data,
          (data) => TipReceiveerSettingsData.fromJson(data),
        );
      }
      return null;
    } catch (e) {
      print('Error getting settings: $e');
      rethrow;
    }
  }

  Future<bool> updateSettings(TipReceiveerSettingsData settings) async {
    try {
      final user_id = await StorageService.get("user_id");
      final token = await StorageService.get("user_token");
      if (token == null) return false;

      await _dioClient.put(
        user_id!,
        data: settings.toJson(),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
      return true;
    } catch (e) {
      print('Error updating settings: $e');
      rethrow;
    }
  }
}
