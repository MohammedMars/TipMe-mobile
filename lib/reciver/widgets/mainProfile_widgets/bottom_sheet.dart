//lib\reciver\auth\widgets\mainProfile_widgets\bottom_sheet.dart
import 'package:flutter/material.dart';
import 'package:tipme_app/utils/app_font.dart';
import 'package:tipme_app/utils/colors.dart';

class SuccessBottomSheet extends StatelessWidget {
  final String title;
  final String description;
  final String primaryButtonText;
  final String secondaryButtonText;
  final Color iconColor;
  final Color iconBackgroundColor;
  final Color primaryButtonColor;
  final Color primaryButtonTextColor;
  final Color secondaryButtonBorderColor;
  final Color secondaryButtonTextColor;
  final VoidCallback? onPrimaryButtonPressed;
  final VoidCallback? onSecondaryButtonPressed;
  final IconData icon;

  const SuccessBottomSheet({
    Key? key,
    required this.title,
    required this.description,
    required this.primaryButtonText,
    required this.secondaryButtonText,
    this.iconColor = Colors.green,
    this.iconBackgroundColor = Colors.transparent,
    this.primaryButtonColor = Colors.cyan,
    this.primaryButtonTextColor = Colors.white,
    this.secondaryButtonBorderColor = Colors.grey,
    this.secondaryButtonTextColor = Colors.black,
    this.onPrimaryButtonPressed,
    this.onSecondaryButtonPressed,
    this.icon = Icons.check,
  }) : super(key: key);

  static void show(
    BuildContext context, {
    required String title,
    required String description,
    required String primaryButtonText,
    required String secondaryButtonText,
    Color iconColor = Colors.green,
    Color iconBackgroundColor = Colors.white,
    Color primaryButtonColor = Colors.cyan,
    Color primaryButtonTextColor = Colors.white,
    Color secondaryButtonBorderColor = Colors.grey,
    Color secondaryButtonTextColor = Colors.black,
    VoidCallback? onPrimaryButtonPressed,
    VoidCallback? onSecondaryButtonPressed,
    IconData icon = Icons.check,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => SuccessBottomSheet(
        title: title,
        description: description,
        primaryButtonText: primaryButtonText,
        secondaryButtonText: secondaryButtonText,
        iconColor: iconColor,
        iconBackgroundColor: iconBackgroundColor,
        primaryButtonColor: primaryButtonColor,
        primaryButtonTextColor: primaryButtonTextColor,
        secondaryButtonBorderColor: secondaryButtonBorderColor,
        secondaryButtonTextColor: secondaryButtonTextColor,
        onPrimaryButtonPressed: onPrimaryButtonPressed,
        onSecondaryButtonPressed: onSecondaryButtonPressed,
        icon: icon,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 12),
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
            Text(
              title,
              style: AppFonts.h3(context, color: AppColors.black),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: AppFonts.mdMedium(context, color: AppColors.text),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onSecondaryButtonPressed ??
                        () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(48),
                      ),
                      side: BorderSide(
                        color: secondaryButtonBorderColor,
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      secondaryButtonText,
                      style: AppFonts.mdBold(context,
                          color: secondaryButtonTextColor),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onPrimaryButtonPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryButtonColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(48),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      primaryButtonText,
                      style: AppFonts.mdBold(context,
                          color: primaryButtonTextColor),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
          ],
        ),
      ),
    );
  }
}
