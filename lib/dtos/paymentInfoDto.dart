//lib\dtos\paymentInfoDto.dart
class PaymentInfoDto {
  final String accountHolderName;
  final String iban;
  final String bankName;
  final String bankCountryId;

  PaymentInfoDto({
    required this.accountHolderName,
    required this.iban,
    required this.bankName,
    required this.bankCountryId,
  });

  factory PaymentInfoDto.fromJson(Map<String, dynamic> json) {
    return PaymentInfoDto(
      accountHolderName: json['accountHolderName'] as String,
      iban: json['iban'] as String,
      bankName: json['bankName'] as String,
      bankCountryId: json['bankCountryId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accountHolderName': accountHolderName,
      'iban': iban,
      'bankName': bankName,
      'bankCountryId': bankCountryId,
    };
  }

  @override
  String toString() {
    return 'PaymentInfoDto{accountHolderName: $accountHolderName, iban: $iban, bankName: $bankName, bankCountryId: $bankCountryId}';
  }
}
