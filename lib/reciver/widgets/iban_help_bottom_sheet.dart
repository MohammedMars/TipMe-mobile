//lib/auth/widgets/help_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tipme_app/utils/app_font.dart';
import '../../utils/colors.dart';
import '../../data/services/language_service.dart';

class HelpBottomSheet extends StatelessWidget {
  final String titleKey;
  final List<String> paragraphKeys;
  final String buttonTextKey;
  final VoidCallback? onButtonPressed;

  const HelpBottomSheet({
    Key? key,
    required this.titleKey,
    required this.paragraphKeys,
    required this.buttonTextKey,
    this.onButtonPressed,
  }) : super(key: key);

  static void show(
    BuildContext context, {
    required String titleKey,
    required List<String> paragraphKeys,
    required String buttonTextKey,
    VoidCallback? onButtonPressed,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => HelpBottomSheet(
        titleKey: titleKey,
        paragraphKeys: paragraphKeys,
        buttonTextKey: buttonTextKey,
        onButtonPressed: onButtonPressed,
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
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              languageService.getText(titleKey),
              style: AppFonts.h3(context, color: AppColors.black),
            ),
            const SizedBox(height: 16),
            ...paragraphKeys.asMap().entries.map((entry) {
              final index = entry.key;
              final paragraphKey = entry.value;

              return Column(
                children: [
                  Text(
                    languageService.getText(paragraphKey),
                    style: AppFonts.mdMedium(context, color: AppColors.text),
                    textAlign: TextAlign.center,
                  ),
                  if (index < paragraphKeys.length - 1)
                    const SizedBox(height: 16),
                ],
              );
            }).toList(),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: onButtonPressed ?? () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(48),
                  ),
                  side: BorderSide(
                    color: AppColors.secondary,
                    width: 1.5,
                  ),
                ),
                child: Text(
                  languageService.getText(buttonTextKey),
                  style: AppFonts.mdBold(context, color: AppColors.secondary),
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
