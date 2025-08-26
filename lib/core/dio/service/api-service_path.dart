//lib\core\dio\service\api-service_path.dart
import 'package:tipme_app/core/config/app_config.dart';


class ApiServicePath {
  static String get serverUrl => AppConfig.serverUrl;
  static String get fileServiceUrl => AppConfig.fileServiceUrl;
  static String get baseUrl => AppConfig.baseUrl;
  static String get notificationHubUrl => AppConfig.notificationHubUrl;
  static const version = "v1";
  static get authTipReceiverPath => "${baseUrl}/${version}/AuthTipReceiver/";
  static get cacheServicePath => "${baseUrl}/${version}/Lookups/";
  static get tipReceiverPath => "${baseUrl}/${version}/TipReceiver/";
  static get qrCodePath => "${baseUrl}/${version}/QrCode/";
  static get statisticsPath => "${baseUrl}/${version}/Statistics/";
  static get tipTransactionPath => "${baseUrl}/${version}/TipTransaction/";
  static get settingsPath => "${baseUrl}/${version}/TipReceiverSettings/";
  static get appSettingsPath => "${baseUrl}/${version}/AppSettings/";
  static get supportIssuePath => "${baseUrl}/${version}/SupportIssue/";
  static get notificationPath => "${baseUrl}/${version}/Notification/";
}
