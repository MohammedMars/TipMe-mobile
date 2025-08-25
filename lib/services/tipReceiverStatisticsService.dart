import 'package:dio/dio.dart';
import 'package:tipme_app/core/dio/client/dio_client.dart';
import 'package:tipme_app/core/storage/storage_service.dart';
import 'package:tipme_app/dtos/dateRangeDto.dart';
import 'package:tipme_app/services/cacheService.dart';
import 'package:tipme_app/viewModels/apiResponse.dart';
import 'package:tipme_app/viewModels/tipReceiverStatisticsData.dart';

class TipReceiverStatisticsService {
  final DioClient dioClient;
  final CacheService? cacheService;

  TipReceiverStatisticsService(this.dioClient, {this.cacheService});

  Future<ApiResponse<TipReceiverStatisticsData>> getTodayStatistics() async {
    String? user_id = await StorageService.get('user_id');
    if (user_id == null) {
      throw Exception('User ID not found');
    }

    final cacheKey = 'today_stats_$user_id';
    
    // Try to get from cache first
    if (cacheService != null) {
      final cachedStats = cacheService!.getStatisticsFromCache(cacheKey);
      if (cachedStats != null) {
        return ApiResponse<TipReceiverStatisticsData>(
          success: true,
          message: 'Statistics loaded from cache',
          data: cachedStats,
          errors: [],
          errorCode: null,
        );
      }
    }

    // If not in cache or expired, fetch from server
    final response = await dioClient.get(
      'Today/$user_id',
      options: Options(
        headers: {
          'Authorization': 'Bearer ${await StorageService.get("user_token")}',
        },
      ),
    );
    
    final apiResponse = ApiResponse<TipReceiverStatisticsData>.fromJson(
      response.data,
      (data) => TipReceiverStatisticsData.fromJson(data),
    );

    // Cache the fetched statistics
    if (apiResponse.success && apiResponse.data != null && cacheService != null) {
      cacheService!.cacheStatistics(cacheKey, apiResponse.data!);
    }

    return apiResponse;
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

  Future<ApiResponse<TipReceiverStatisticsData>> getStatisticsCalculatedBetween(
      DateTime from, DateTime to) async {
    String? user_id = await StorageService.get('user_id');
    if (user_id == null) {
      throw Exception('User ID not found');
    }

    final cacheKey = 'calculated_stats_${user_id}_${from.millisecondsSinceEpoch}_${to.millisecondsSinceEpoch}';
    
    // Try to get from cache first
    if (cacheService != null) {
      final cachedStats = cacheService!.getStatisticsFromCache(cacheKey);
      if (cachedStats != null) {
        return ApiResponse<TipReceiverStatisticsData>(
          success: true,
          message: 'Statistics loaded from cache',
          data: cachedStats,
          errors: [],
          errorCode: null,
        );
      }
    }

    // Create DateRangeDto
    final dateRangeDto = DateRangeDto(from: from, to: to);

    final response = await dioClient.post(
      'CalculatedBetween/$user_id',
      data: dateRangeDto.toJson(),
      options: Options(
        headers: {
          'Authorization': 'Bearer ${await StorageService.get("user_token")}',
        },
      ),
    );

    final apiResponse = ApiResponse<TipReceiverStatisticsData>.fromJson(
      response.data,
      (data) => TipReceiverStatisticsData.fromJson(data),
    );

    // Cache the fetched statistics
    if (apiResponse.success && apiResponse.data != null && cacheService != null) {
      cacheService!.cacheStatistics(cacheKey, apiResponse.data!);
    }

    return apiResponse;
  }

  Future<ApiResponse> getBalance() async {
    String? userId = await StorageService.get('user_id');
    if (userId == null) {
      throw Exception('User ID not found');
    }

    final cacheKey = 'balance_$userId';
    
    // Try to get from cache first
    if (cacheService != null) {
      final cachedBalance = cacheService!.getBalanceFromCache(cacheKey);
      if (cachedBalance != null) {
        return ApiResponse(
          success: true,
          message: 'Balance loaded from cache',
          data: cachedBalance,
          errors: [],
          errorCode: null,
        );
      }
    }

    // If not in cache or expired, fetch from server
    final response = await dioClient.get(
      'Balance/$userId',
      options: Options(
        headers: {
          'Authorization': 'Bearer ${await StorageService.get("user_token")}',
        },
      ),
    );

    final apiResponse = ApiResponse.fromJson(
      response.data,
      (data) => data, 
    );

    // Cache the fetched balance
    if (apiResponse.success && apiResponse.data != null && cacheService != null) {
      cacheService!.cacheBalance(cacheKey, apiResponse.data!);
    }

    return apiResponse;
  }
}
