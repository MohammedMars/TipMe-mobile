//lib\net\auth_tip_receiver\model\sign_up_body_request.dart
class SignUpBodyRequest {
  final String mobileNumber;

  SignUpBodyRequest({required this.mobileNumber});

  /// Create object from JSON
  factory SignUpBodyRequest.fromJson(Map<String, dynamic> json) {
    return SignUpBodyRequest(
      mobileNumber: json['mobileNumber'] as String,
    );
  }

  /// Convert object to JSON
  Map<String, dynamic> toJson() {
    return {
      'mobileNumber': mobileNumber,
    };
  }
}
