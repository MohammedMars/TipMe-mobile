class TipTransactionData {
  final double amount;
  final double netAmount;
  final String paymentMethod;
  final String? paymentReference;
  final String mobileNumber;
  final String? tipReceiverId;
  final String receiverType;
  final String status;
  final String? note;
  final DateTime createdAt;

  TipTransactionData({
    required this.amount,
    required this.netAmount,
    required this.paymentMethod,
    this.paymentReference,
    required this.mobileNumber,
    this.tipReceiverId,
    required this.receiverType,
    this.status = 'Pending',
    this.note,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now().toUtc();

  factory TipTransactionData.fromJson(Map<String, dynamic> json) {
    return TipTransactionData(
      amount: (json['amount'] as num).toDouble(),
      netAmount: (json['netAmount'] as num).toDouble(),
      paymentMethod: json['paymentMethod'] as String,
      paymentReference: json['paymentReference'] as String?,
      mobileNumber: json['mobileNumber'] as String,
      tipReceiverId: json['tipReceiverId'] as String?,
      receiverType: json['receiverType'] as String,
      status: json['status'] as String? ?? 'Pending',
      note: json['note'] as String?,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt'] as String).toUtc()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'netAmount': netAmount,
      'paymentMethod': paymentMethod,
      'paymentReference': paymentReference,
      'mobileNumber': mobileNumber,
      'tipReceiverId': tipReceiverId,
      'receiverType': receiverType,
      'status': status,
      'note': note,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}