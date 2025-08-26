//lib\di\gitIt.dart
import 'package:get_it/get_it.dart';
import 'package:tipme_app/core/dio/client/dio_client.dart';
import 'package:tipme_app/core/dio/client/dio_client_pool.dart';
import 'package:tipme_app/core/dio/dio_factory.dart';
import 'package:tipme_app/core/dio/service/api_service_type.dart';
import 'package:tipme_app/services/signalRService.dart';
import 'package:tipme_app/services/notificationPopupService.dart';
import 'package:tipme_app/services/cacheService.dart';
import 'package:tipme_app/services/qrCodeService.dart';
import 'package:tipme_app/services/tipReceiverService.dart';
import 'package:tipme_app/services/tipReceiverStatisticsService.dart';
import 'package:tipme_app/services/tipTransactionService.dart';
import 'package:tipme_app/services/authTipReceiverService.dart';

final sl = GetIt.instance;
final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  registerSingilton();

  // Register SignalR services
  sl.registerLazySingleton<SignalRService>(() => SignalRService.instance);
  sl.registerLazySingleton<NotificationPopupService>(
      () => NotificationPopupService.instance);

  // Register CacheService
  sl.registerLazySingleton<CacheService>(
      () => CacheService(sl<DioClient>(instanceName: 'CacheService')));

  // Register QRCodeService with CacheService
  sl.registerLazySingleton<QRCodeService>(() => QRCodeService(
        sl<DioClient>(instanceName: 'QrCode'),
        cacheService: sl<CacheService>(),
      ));

  // Register TipReceiverService with CacheService
  sl.registerLazySingleton<TipReceiverService>(() => TipReceiverService(
        sl<DioClient>(instanceName: 'TipReceiver'),
        cacheService: sl<CacheService>(),
      ));

  // Register TipReceiverStatisticsService
  sl.registerLazySingleton<TipReceiverStatisticsService>(
    () => TipReceiverStatisticsService(
        sl<DioClient>(instanceName: 'Statistics'),
        cacheService: sl<CacheService>()),
  );

  // Register TipTransactionService with CacheService
  sl.registerLazySingleton<TipTransactionService>(() => TipTransactionService(
        dioClient: sl<DioClient>(instanceName: 'TipTransaction'),
        cacheService: sl<CacheService>(),
      ));

  // Register AuthTipReceiverService with CacheService and TipReceiverService
  sl.registerLazySingleton<AuthTipReceiverService>(() => AuthTipReceiverService(
        sl<DioClient>(instanceName: 'AuthTipReceiver'),
        cacheService: sl<CacheService>(),
        tipReceiverService: sl<TipReceiverService>(),
      ));
}

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
  sl.registerLazySingleton<DioClient>(
    () => createDioClient(ApiServiceType.SupportIssue),
    instanceName: 'SupportIssue',
  );
  sl.registerLazySingleton<DioClient>(
    () => createDioClient(ApiServiceType.Notification),
    instanceName: 'Notification',
  );
}

DioClient createDioClient(ApiServiceType apiServiceType) {
  return DioClient.create(
      DioFactory.createDioInstance(
          baseURL: DioClientPool.instance.findUrl(apiServiceType)),
      apiServiceType);
}
