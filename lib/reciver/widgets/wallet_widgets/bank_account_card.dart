//lib/reciver/auth/widgets/wallet_widgets/bank_account_card.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tipme_app/reciver/widgets/info_message.dart';
import 'package:tipme_app/data/services/language_service.dart';
import 'package:tipme_app/utils/app_font.dart';
import 'package:tipme_app/utils/colors.dart';

class BankAccountCard extends StatelessWidget {
  final String bankName;
  final String accountNumber;
  final String? iconPath;
  final bool showPendingVerification;
  final VoidCallback onTap;

  const BankAccountCard({
    Key? key,
    required this.bankName,
    required this.accountNumber,
    this.iconPath,
    this.showPendingVerification = false,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languageService = Provider.of<LanguageService>(context);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color(0x00000008).withOpacity(0.031),
            offset: const Offset(0, 10),
            blurRadius: 15,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: showPendingVerification
                        ? Colors.transparent
                        : const Color(0xFFE0E0E0),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.border_2,
                        width: 1,
                      ),
                    ),
                    child: iconPath != null
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              iconPath!,
                              fit: BoxFit.contain,
                            ),
                          )
                        : Icon(
                            Icons.account_balance,
                            color: AppColors.primary,
                            size: 24,
                          ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bankName,
                          style: AppFonts.mdSemiBold(context,
                              color: AppColors.black),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          accountNumber,
                          style:
                              AppFonts.xsMedium(context, color: AppColors.text),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: AppColors.text,
                  ),
                ],
              ),
            ),
          ),
          if (showPendingVerification) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xFFE0E0E0),
                    width: 1,
                  ),
                ),
              ),
              child: InfoMessage(
                message: languageService.getText('pendingVerification'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
