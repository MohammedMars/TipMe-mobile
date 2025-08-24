import 'package:flutter/material.dart';
import 'package:tipme_app/utils/colors.dart';
import 'package:tipme_app/utils/text_styles.dart';

class QRTitleSection extends StatelessWidget {
  const QRTitleSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 283,
      height: 70,
      alignment: Alignment.center,
      child: Text(
        'Generating Your Unique QR Code Badge',
        style:AppTextStyles.welcomeTitle(context, color: AppColors.white),

        textAlign: TextAlign.center,
      ),
    );
  }
}