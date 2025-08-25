//lib/reciver/auth/widgets/transaction_widgets/transaction_card.dart
import 'package:flutter/material.dart';
import 'package:tipme_app/utils/app_font.dart';
import 'package:tipme_app/utils/colors.dart';

class TransactionCard extends StatelessWidget {
  final String time;
  final int status;
  final String amount;
  final String currency;
  final String balance;
  final bool isPositive;
  final bool isPending;

  const TransactionCard({
    Key? key,
    required this.time,
    required this.status,
    required this.amount,
    required this.currency,
    required this.balance,
    this.isPositive = true,
    this.isPending = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  time,
                  style: AppFonts.smMedium(context, color: AppColors.black),
                ),
                const SizedBox(height: 2),
                Text(
                  _getStatus(status),
                  style: AppFonts.smMedium(
                    context,
                    color: status == -1 ? AppColors.danger_500 :
                                          isPending ? AppColors.warning_500 : AppColors.success,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  status == 1 ? '+$amount' : amount,
                  style: AppFonts.smMedium(context, color: AppColors.black),
                ),
                const SizedBox(height: 2),
                Text(
                  currency,
                  style: AppFonts.smMedium(context, color: AppColors.text),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  balance,
                  style: AppFonts.smMedium(context, color: AppColors.black),
                ),
                const SizedBox(height: 2),
                Text(
                  currency,
                  style: AppFonts.smMedium(context, color: AppColors.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getStatus(int status) {
    switch (status) {
      case 0:
        return 'Pending';
      case 1:
        return 'Paid';
      case 2:
        return 'Redeemed';
      default:
        return 'Failed';
    }
  }
}
