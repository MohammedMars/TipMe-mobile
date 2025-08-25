import 'package:tipme_app/core/dio/client/dio_client.dart';
import 'package:tipme_app/core/storage/storage_service.dart';
import 'package:tipme_app/viewModels/apiResponse.dart';
import 'package:tipme_app/viewModels/groupedNotificationModel.dart';
import 'package:dio/dio.dart';

class NotificationService {
  final DioClient dioClient;
  NotificationService(this.dioClient);

  Future<ApiResponse<List<GroupedNotificationModel>>>
      getAllNotificationsGrouped() async {
    String? userId = await StorageService.get('user_id');
    if (userId == null) {
      throw Exception('User ID not found');
    }

    final response = await dioClient.get(
      'Grouped/$userId',
      options: Options(
        headers: {
          'Authorization': 'Bearer ${await StorageService.get("user_token")}',
        },
      ),
    );

    return ApiResponse<List<GroupedNotificationModel>>.fromJson(
      response.data,
      (data) => (data as List)
          .map((item) => GroupedNotificationModel.fromJson(item))
          .toList(),
    );
  }
}
