//lib\net\auth_tip_receiver\verify_otp\model\verify_otp_response.dart
class VerifyOtpResponse {
  final bool success;
  final String message;
  final VerifyOtpData? data;
  final List<dynamic> errors;
  final String? errorCode;

  VerifyOtpResponse({
    required this.success,
    required this.message,
    this.data,
    required this.errors,
    this.errorCode,
  });

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: json['data'] != null && json['data'].isNotEmpty
          ? VerifyOtpData.fromJson(json['data'])
          : null,
      errors: json['errors'] as List<dynamic>,
      errorCode: json['errorCode'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
      'errors': errors,
      'errorCode': errorCode,
    };
  }
}

class VerifyOtpData {
  final String token;

  VerifyOtpData({required this.token});

  factory VerifyOtpData.fromJson(Map<String, dynamic> json) {
    return VerifyOtpData(
      token: json['token'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
    };
  }
}
