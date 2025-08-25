import 'package:dio/dio.dart';
import 'package:tipme_app/core/dio/client/dio_client.dart';
import 'package:tipme_app/core/storage/storage_service.dart';
import 'package:tipme_app/dtos/TipTransactionFilterDto.dart';
import 'package:tipme_app/services/cacheService.dart';
import 'package:tipme_app/viewModels/apiResponse.dart';

class TipTransactionService {
  final DioClient dioClient;
  final CacheService? cacheService;

  TipTransactionService({required this.dioClient, this.cacheService});

  Future<Options> _getAuthOptions() async {
    final token = await StorageService.get('user_token');
    return Options(
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> getTipTransactions({
    String? transactionId,
    int pageNumber = 1,
    int pageSize = 10,
  }) async {
    final userId = await _getUserId();
    if (userId == null) {
      throw Exception('User ID not found');
    }

    final cacheKey = 'transactions_${userId}_${transactionId ?? 'none'}_${pageNumber}_$pageSize';
    
    if (cacheService != null) {
      final cachedTransactions = cacheService!.getTransactionsFromCache(cacheKey);
      if (cachedTransactions != null) {
        return ApiResponse<Map<String, dynamic>>(
          success: true,
          message: 'Transactions loaded from cache',
          data: cachedTransactions,
          errors: [],
          errorCode: null,
        );
      }
    }

    final filter = TipTransactionFilterDto(
      tipReceiverId: userId,
      transactionId: transactionId,
    );

    final response = await dioClient.post(
      '',
      data: filter.toJson(),
      query: {
        'pageNumber': pageNumber,
        'pageSize': pageSize,
      },
      options: await _getAuthOptions(),
    );

    final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
      response.data,
      (data) => data as Map<String, dynamic>,
    );

    if (apiResponse.success && apiResponse.data != null && cacheService != null) {
      cacheService!.cacheTransactions(cacheKey, apiResponse.data!);
    }

    return apiResponse;
  }

  Future<String?> _getUserId() async {
    return await StorageService.get('user_id');
  }
}
