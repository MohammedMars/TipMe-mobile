enum TransactionStatus {
  pending(0),
  paid(1),
  redeemed(2),
  failed(-1);

  const TransactionStatus(this.value);
  final int value;

  static TransactionStatus fromValue(int value) {
    return TransactionStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => TransactionStatus.pending,
    );
  }
}
