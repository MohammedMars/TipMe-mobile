//lib/auth/widgets/selected_bank_display.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tipme_app/utils/app_font.dart';
import '../../utils/colors.dart';
import '../../data/services/language_service.dart';

class SelectedBankDisplay extends StatelessWidget {
  final String bankName;
  final String? iconPath;

  const SelectedBankDisplay({
    Key? key,
    required this.bankName,
    this.iconPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languageService = Provider.of<LanguageService>(context);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: iconPath != null
                  ? Image.asset(
                      iconPath!,
                      width: 24,
                      height: 24,
                    )
                  : Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: AppColors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  languageService.getText('selectedBank'),
                  style: AppFonts.smMedium(context,
                      color: AppColors.white.withOpacity(0.7)),
                ),
                const SizedBox(height: 2),
                Text(
                  bankName,
                  style: AppFonts.mdBold(context, color: AppColors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
