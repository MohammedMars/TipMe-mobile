class SignInUpDto {
  final String mobileNumber;

  SignInUpDto({required this.mobileNumber});

  Map<String, dynamic> toJson() => {
        'mobileNumber': mobileNumber,
      };

  factory SignInUpDto.fromJson(Map<String, dynamic> json) {
    return SignInUpDto(
      mobileNumber: json['mobileNumber'],
    );
  }
}
