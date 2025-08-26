class ChangeMobileNumberDto {
  final String mobileNumber;

  ChangeMobileNumberDto({required this.mobileNumber});

  Map<String, dynamic> toJson() => {
        'mobileNumber': mobileNumber,
      };

  factory ChangeMobileNumberDto.fromJson(Map<String, dynamic> json) {
    return ChangeMobileNumberDto(
      mobileNumber: json['mobileNumber'],
    );
  }
}
