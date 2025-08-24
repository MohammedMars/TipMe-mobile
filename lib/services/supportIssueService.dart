import 'package:dio/dio.dart';
import 'package:tipme_app/core/dio/client/dio_client.dart';
import 'package:tipme_app/core/storage/storage_service.dart';
import 'package:tipme_app/dtos/CreateSupportIssueDto.dart';
import 'package:tipme_app/viewModels/apiResponse.dart';

class SupportIssueService {
  final DioClient dioClient;
  SupportIssueService(this.dioClient);

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

  Future<ApiResponse<bool>?> createSupportIssue(
      CreateSupportIssueDto dto) async {
    try {
      final userId = await _getUserId();
      if (userId == null) throw Exception('User ID not found');

      final response = await dioClient.post(
        '',
        data: dto.toJson(),
        options: await _getAuthOptions(),
      );

      return ApiResponse<bool>.fromJson(
        response.data,
        (data) => response.data['success'] ?? false,
      );
    } catch (e) {
      print('Create support issue error: $e');
      rethrow;
    }
  }
}
