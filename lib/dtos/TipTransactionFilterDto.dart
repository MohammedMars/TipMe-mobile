class TipTransactionFilterDto {
  final String? tipReceiverId;
  final String? transactionId;
  final int? status;

  TipTransactionFilterDto({
    this.tipReceiverId,
    this.transactionId,
    this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'tipReceiverId': tipReceiverId,
      'transactionId': transactionId,
      'status': status,
    }..removeWhere((key, value) => value == null);
  }
}
