//lib\di\gitIt.dart
import 'package:get_it/get_it.dart';
import 'package:tipme_app/core/dio/client/dio_client.dart';
import 'package:tipme_app/core/dio/client/dio_client_pool.dart';
import 'package:tipme_app/core/dio/dio_factory.dart';
import 'package:tipme_app/core/dio/service/api_service_type.dart';

final sl = GetIt.instance;
void registerSingilton() {
  // Register DioClient for AuthTipReceiver
  sl.registerLazySingleton<DioClient>(
    () => createDioClient(ApiServiceType.AuthTipReceiver),
    instanceName: 'AuthTipReceiver',
  );
  // CacheService DioClient
  sl.registerLazySingleton<DioClient>(
    () => createDioClient(ApiServiceType.CacheService),
    instanceName: 'CacheService',
  );

  sl.registerLazySingleton<DioClient>(
    () => createDioClient(ApiServiceType.TipReceiver),
    instanceName: 'TipReceiver',
  );

  sl.registerLazySingleton<DioClient>(
    () => createDioClient(ApiServiceType.QrCode),
    instanceName: 'QrCode',
  );
  sl.registerLazySingleton<DioClient>(
    () => createDioClient(ApiServiceType.Statistics),
    instanceName: 'Statistics',
  );
  sl.registerLazySingleton<DioClient>(
      () => createDioClient(ApiServiceType.TipTransaction),
      instanceName: 'TipTransaction');

  sl.registerLazySingleton<DioClient>(
      () => createDioClient(ApiServiceType.Settings),
      instanceName: 'TipReceiverSettings');

  sl.registerLazySingleton<DioClient>(
    () => createDioClient(ApiServiceType.AppSettings),
    instanceName: 'AppSettings',
  );
}

DioClient createDioClient(ApiServiceType apiServiceType) {
  return DioClient.create(
      DioFactory.createDioInstance(
          baseURL: DioClientPool.instance.findUrl(apiServiceType)),
      apiServiceType);
}
