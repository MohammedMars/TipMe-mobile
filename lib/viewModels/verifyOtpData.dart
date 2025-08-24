class VerifyOtpData {
  final String token;
  final String? firstName;
  final String? surName;
  final String? id;

  VerifyOtpData({
    required this.token,
    this.firstName,
    this.surName,
    this.id,
  });

  factory VerifyOtpData.fromJson(Map<String, dynamic> json) {
    return VerifyOtpData(
      token: json['token'] as String,
      firstName: json['firstName'] as String?,
      surName: json['surName'] as String?,
      id: json['id'] as String?,
    );
  }
}