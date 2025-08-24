//lib\services\tipReceiverService.dart
import 'package:tipme_app/core/dio/client/dio_client.dart';
import 'package:tipme_app/core/storage/storage_service.dart';
import 'package:tipme_app/dtos/paymentInfoDto.dart';
import 'package:tipme_app/viewModels/apiResponse.dart';
import 'package:tipme_app/viewModels/paymentInfoData.dart';
import 'package:tipme_app/viewModels/tipReceiveerData.dart';
import 'package:dio/dio.dart';

class TipReceiverService {
  final DioClient dioClient;

  TipReceiverService(this.dioClient);

  Future<ApiResponse<TipReceiveerData>?> GetMe() async {
    String? user_id = await StorageService.get('user_id');
    if (user_id == null) {
      return null;
    }
    final response = await dioClient.get(
      user_id,
      options: Options(
        headers: {
          'Authorization': 'Bearer ${await StorageService.get("user_token")}',
        },
      ),
    );
    return ApiResponse<TipReceiveerData>.fromJson(
      response.data,
      (data) => TipReceiveerData.fromJson(data),
    );
  }

  Future<ApiResponse> GetPaymentInfo() async {
    String? user_id = await StorageService.get('user_id');
    if (user_id == null) {
      throw Exception('User ID not found');
    }
    final response = await dioClient.get(
      'PaymentInfo/$user_id',
      options: Options(
        headers: {
          'Authorization': 'Bearer ${await StorageService.get("user_token")}',
        },
      ),
    );
    return ApiResponse<PaymentInfoData>.fromJson(
      response.data,
      (data) => PaymentInfoData.fromJson(data),
    );
  }

  Future<ApiResponse<PaymentInfoData>> updatePaymentInfo(
      PaymentInfoDto dto) async {
    String? user_id = await StorageService.get('user_id');
    if (user_id == null) {
      throw Exception('User ID not found');
    }

    final response = await dioClient.put(
      'PaymentInfo/$user_id',
      data: dto.toJson(),
      options: Options(
        headers: {
          'Authorization': 'Bearer ${await StorageService.get("user_token")}',
        },
      ),
    );

    return ApiResponse<PaymentInfoData>.fromJson(
      response.data,
      (data) => PaymentInfoData.fromJson(data),
    );
  }
}
