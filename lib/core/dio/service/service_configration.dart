//lib\core\dio\service\service_configration.dart
import 'package:tipme_app/core/dio/service/api-service_path.dart';
import 'package:tipme_app/core/dio/service/api_service_type.dart';

class ServiceConfigration {
  final Map<ApiServiceType, String> _config = {
    ApiServiceType.AuthTipReceiver: ApiServicePath.authTipReceiverPath,
    ApiServiceType.CacheService: ApiServicePath.cacheServicePath,
    ApiServiceType.TipReceiver: ApiServicePath.tipReceiverPath,
    ApiServiceType.QrCode: ApiServicePath.qrCodePath,
    ApiServiceType.Statistics: ApiServicePath.statisticsPath,
    ApiServiceType.TipTransaction: ApiServicePath.tipTransactionPath,
    ApiServiceType.Settings: ApiServicePath.settingsPath,
    ApiServiceType.AppSettings: ApiServicePath.appSettingsPath,
    ApiServiceType.SupportIssue: ApiServicePath.supportIssuePath,
    ApiServiceType.Notification: ApiServicePath.notificationPath,
  };
  Map<ApiServiceType, String> get config => _config;
}
