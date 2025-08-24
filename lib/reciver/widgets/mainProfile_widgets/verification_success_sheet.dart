//lib\reciver\auth\widgets\mainProfile_widgets\verification_success_sheet.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tipme_app/data/services/language_service.dart';
import 'package:tipme_app/utils/app_font.dart';
import 'package:tipme_app/utils/colors.dart';

class VerificationSuccessSheet extends StatelessWidget {
  final String titleKey;
  final String descriptionKey;
  final String buttonTextKey;
  final Color iconColor;
  final Color iconBackgroundColor;
  final Color buttonColor;
  final Color buttonTextColor;
  final VoidCallback? onButtonPressed;
  final IconData icon;

  const VerificationSuccessSheet({
    Key? key,
    required this.titleKey,
    required this.descriptionKey,
    required this.buttonTextKey,
    this.iconColor = Colors.green,
    this.iconBackgroundColor = Colors.white,
    this.buttonColor = Colors.white,
    this.buttonTextColor = Colors.white,
    this.onButtonPressed,
    this.icon = Icons.check,
  }) : super(key: key);

  static void show(
    BuildContext context, {
    required String titleKey,
    required String descriptionKey,
    required String buttonTextKey,
    Color iconColor = Colors.green,
    Color iconBackgroundColor = Colors.white,
    Color buttonColor = Colors.cyan,
    Color buttonTextColor = Colors.white,
    VoidCallback? onButtonPressed,
    IconData icon = Icons.check,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      builder: (context) => VerificationSuccessSheet(
        titleKey: titleKey,
        descriptionKey: descriptionKey,
        buttonTextKey: buttonTextKey,
        iconColor: iconColor,
        iconBackgroundColor: iconBackgroundColor,
        buttonColor: buttonColor,
        buttonTextColor: buttonTextColor,
        onButtonPressed: onButtonPressed,
        icon: icon,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final languageService = Provider.of<LanguageService>(context);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: iconBackgroundColor,
                border: Border.all(
                  color: iconColor,
                  width: 2,
                ),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 32,
              ),
            ),
            const SizedBox(height: 28),

            // Title
            Text(
              languageService.getText(titleKey),
              style: AppFonts.h3(context, color: AppColors.black),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            // Description
            Text(
              languageService.getText(descriptionKey),
              style: AppFonts.mdMedium(context, color: AppColors.text),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Single Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onButtonPressed ?? () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(48),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  languageService.getText(buttonTextKey),
                  style: AppFonts.mdBold(context, color: buttonTextColor),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
          ],
        ),
      ),
    );
  }
}
