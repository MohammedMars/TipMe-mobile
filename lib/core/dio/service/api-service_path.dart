//lib\core\dio\service\api-service_path.dart
class ApiServicePath {
  static const fileServiceUrl = "http://localhost:5081/uploads";
  static const baseUrl = "http://localhost:5081/api";
  static const version = "v1"; // DONT CHANGE
  static get authTipReceiverPath => "${baseUrl}/${version}/AuthTipReceiver/";
  static get cacheServicePath => "${baseUrl}/${version}/Lookups/";
  static get tipReceiverPath => "${baseUrl}/${version}/TipReceiver/";
  static get qrCodePath => "${baseUrl}/${version}/QrCode/";
  static get statisticsPath => "${baseUrl}/${version}/Statistics/";
  static get tipTransactionPath => "${baseUrl}/${version}/TipTransaction/";
  static get settingsPath => "${baseUrl}/${version}/TipReceiverSettings/";
  static get appSettingsPath => "${baseUrl}/${version}/AppSettings/";
  static get supportIssuePath => "${baseUrl}/${version}/SupportIssue/";
}
