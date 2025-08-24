import 'package:intl/intl.dart';

class TransactionItem {
  final String id;
  final String time;
  final int status;
  final String amount;
  final String currency;
  final String balance;
  final bool isPositive;
  final bool isPending;
  final String type;
  final DateTime date;

  TransactionItem({
    required this.id,
    required this.time,
    required this.status,
    required this.amount,
    this.currency = 'SAR',
    required this.balance,
    required this.isPositive,
    required this.isPending,
    required this.type,
    required this.date,
  });

  factory TransactionItem.fromJson(Map<String, dynamic> json) {
    final date = DateTime.parse(json['createdAt']);
    final isPositive = json['status'] == 1 ? true : false;
    final isPending = json['status'] == 0 ? true : false;
    return TransactionItem(
      id: json['id'],
      time: DateFormat('h:mm a').format(date),
      status: json['status'],
      amount: json['amount'].toString(),
      balance: json['balanceAfterTransaction']?.toString() ?? '0',
      isPositive: isPositive,
      isPending: isPending,
      type: json['status'] == 1 ? 'received' : 'redeemed',
      date: date,
    );
  }



  String get formattedDate => DateFormat('d MMMM').format(date);
  String get formattedTime => DateFormat('h:mm a').format(date);
}
