class VerifyOtpDto {
  final String mobileNumber;
  final String otp;

  VerifyOtpDto({
    required this.mobileNumber,
    required this.otp,
  });

  Map<String, dynamic> toJson() => {
        'mobileNumber': mobileNumber,
        'otp': otp,
      };

  factory VerifyOtpDto.fromJson(Map<String, dynamic> json) {
    return VerifyOtpDto(
      mobileNumber: json['mobileNumber'],
      otp: json['otp'],
    );
  }

}
