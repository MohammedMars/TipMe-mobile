//lib/auth/widgets/wallet_widgets/bank_info_card.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tipme_app/data/services/language_service.dart';
import 'package:tipme_app/utils/app_font.dart';
import 'package:tipme_app/utils/colors.dart';

class BankInfoCard extends StatelessWidget {
  final String bankName;
  final String accountHolderName;
  final String country;
  final String iban;
  final String? bankIconPath;

  const BankInfoCard({
    Key? key,
    required this.bankName,
    required this.accountHolderName,
    required this.country,
    required this.iban,
    this.bankIconPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languageService = Provider.of<LanguageService>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoField(
          context: context,
          label: languageService.getText('bank'),
          value: bankName,
          showBankIcon: true,
          iconPath: bankIconPath,
        ),
        const SizedBox(height: 16),
        _buildInfoField(
          context: context,
          label: languageService.getText('accountHolderName'),
          value: accountHolderName,
        ),
        const SizedBox(height: 16),
        _buildInfoField(
          context: context,
          label: languageService.getText('country'),
          value: country,
        ),
        const SizedBox(height: 16),
        _buildInfoField(
          context: context,
          label: languageService.getText('iban'),
          value: iban,
        ),
        const Spacer(),
      ],
    );
  }

  Widget _buildInfoField({
    required BuildContext context,
    required String label,
    required String value,
    bool showBankIcon = false,
    String? iconPath,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F8FB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: AppFonts.smMedium(context, color: AppColors.text),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: AppFonts.mdBold(context, color: AppColors.black),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (showBankIcon) ...[
            const SizedBox(width: 12),
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: iconPath != null
                    ? Image.asset(
                        iconPath,
                        width: 24,
                        height: 24,
                      )
                    : Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
