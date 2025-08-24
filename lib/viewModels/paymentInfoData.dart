class PaymentInfoData {
  final String accountHolderName;
  final String iban;
  final String bankName;
  final String countryId;
  final String countryName;
  final String? id;

  PaymentInfoData({
    required this.accountHolderName,
    required this.iban,
    required this.bankName,
    required this.countryId,
    required this.countryName,
    this.id,
  });

  factory PaymentInfoData.fromJson(Map<String, dynamic> json) {
    return PaymentInfoData(
      accountHolderName: json['accountHolderName'] as String,
      iban: json['iban'] as String,
      bankName: (json['bankName'] ?? "") as String,
      countryId: (json['countryId'] ?? "") as String,
      countryName: (json['countryName'] ?? "") as String,
      id: json['id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accountHolderName': accountHolderName,
      'iban': iban,
      'bankName': bankName,
      'countryId': countryId,
      if (id != null) 'id': id,
    };
  }

  @override
  String toString() {
    return 'PaymentInfo{accountHolderName: $accountHolderName, iban: $iban, bankName: $bankName, countryId: $countryId, id: $id}';
  }
}
