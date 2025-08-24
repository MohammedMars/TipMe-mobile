//lib\reciver\auth\widgets\warning_message.dart
import 'package:flutter/material.dart';
import 'package:tipme_app/utils/app_font.dart';
import '../../utils/colors.dart';

class InfoMessage extends StatelessWidget {
  final String message;

  const InfoMessage({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.warning_50,
        border: Border.all(color: AppColors.warning),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: AppColors.warning_50,
            offset: const Offset(10, 9),
            blurRadius: 16,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: AppFonts.smMedium(context, color: AppColors.warning),
      ),
    );
  }
}
