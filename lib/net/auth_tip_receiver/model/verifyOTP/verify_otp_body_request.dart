//lib\net\auth_tip_receiver\verify_otp\model\verify_otp_body_request.dart
class VerifyOtpBodyRequest {
  final String mobileNumber;
  final String otp;

  VerifyOtpBodyRequest({
    required this.mobileNumber,
    required this.otp,
  });

  /// Create object from JSON
  factory VerifyOtpBodyRequest.fromJson(Map<String, dynamic> json) {
    return VerifyOtpBodyRequest(
      mobileNumber: json['mobileNumber'] as String,
      otp: json['otp'] as String,
    );
  }

  /// Convert object to JSON
  Map<String, dynamic> toJson() {
    return {
      'mobileNumber': mobileNumber,
      'otp': otp,
    };
  }
}
