//lib\reciver\auth\widgets\wallet_widgets\stat_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tipme_app/utils/app_font.dart';
import 'package:tipme_app/utils/colors.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color backgroundColor;
  final Color valueColor;
  final String iconPath;
  final bool hasRedeem;
  final String? redeemText;

  const StatCard({
    Key? key,
    required this.title,
    required this.value,
    required this.backgroundColor,
    required this.valueColor,
    required this.iconPath,
    this.hasRedeem = false,
    this.redeemText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppFonts.smMedium(context, color: AppColors.black),
                  maxLines: 2,
                ),
              ),
              const SizedBox(width: 8),
              SvgPicture.asset(
                iconPath,
                width: 42,
                height: 42,
              ),
            ],
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  value,
                  style: AppFonts.h4(context, color: valueColor),
                  maxLines: 1,
                ),
              ),
              if (hasRedeem && redeemText != null) ...[
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: valueColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    redeemText!,
                    style: AppFonts.smMedium(context, color: Colors.white),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
