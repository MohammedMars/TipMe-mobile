import 'package:dio/dio.dart';
import 'package:tipme_app/core/dio/client/dio_client.dart';
import 'package:tipme_app/core/storage/storage_service.dart';
import 'package:tipme_app/dtos/dateRangeDto.dart';
import 'package:tipme_app/viewModels/apiResponse.dart';
import 'package:tipme_app/viewModels/tipReceiverStatisticsData.dart';

class TipReceiverStatisticsService {
  final DioClient dioClient;

  TipReceiverStatisticsService(this.dioClient);

  Future<ApiResponse<TipReceiverStatisticsData>> getTodayStatistics() async {
    String? user_id = await StorageService.get('user_id');
    if (user_id == null) {
      throw Exception('User ID not found');
    }
    final response = await dioClient.get(
      'Today/$user_id',
      options: Options(
        headers: {
          'Authorization': 'Bearer ${await StorageService.get("user_token")}',
        },
      ),
    );
    return ApiResponse<TipReceiverStatisticsData>.fromJson(
      response.data,
      (data) => TipReceiverStatisticsData.fromJson(data),
    );
  }

  Future<ApiResponse<List<TipReceiverStatisticsData>>> getStatisticsBetween(
      DateTime from, DateTime to) async {
    String? user_id = await StorageService.get('user_id');
    if (user_id == null) {
      throw Exception('User ID not found');
    }

    // Create DateRangeDto
    final dateRangeDto = DateRangeDto(from: from, to: to);

    final response = await dioClient.post(
      'Between/$user_id',
      data: dateRangeDto.toJson(),
      options: Options(
        headers: {
          'Authorization': 'Bearer ${await StorageService.get("user_token")}',
        },
      ),
    );

    return ApiResponse<List<TipReceiverStatisticsData>>.fromJson(
      response.data,
      (data) {
        if (data is List) {
          return data
              .map((item) => TipReceiverStatisticsData.fromJson(item))
              .toList();
        }
        throw Exception(
            'Invalid response format: expected List but got ${data.runtimeType}');
      },
    );
  }

  Future<ApiResponse> getBalance() async {
    String? userId = await StorageService.get('user_id');
    if (userId == null) {
      throw Exception('User ID not found');
    }

    final response = await dioClient.get(
      'Balance/$userId',
      options: Options(
        headers: {
          'Authorization': 'Bearer ${await StorageService.get("user_token")}',
        },
      ),
    );

    return ApiResponse.fromJson(
      response.data,
      (data) => data, // since your API just returns { "total": number }
    );
  }
}
