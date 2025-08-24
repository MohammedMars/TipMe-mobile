//lib/auth/screens/profile/linked_bank_account_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tipme_app/reciver/screens/wallet/change_bank_account.dart';
import 'package:tipme_app/reciver/widgets/custom_button.dart';
import 'package:tipme_app/reciver/widgets/wallet_widgets/bank_info_card.dart';
import 'package:tipme_app/reciver/widgets/wallet_widgets/custom_top_bar.dart';
import 'package:tipme_app/utils/app_font.dart';
import '../../../utils/colors.dart';
import '../../../data/services/language_service.dart';

class LinkedBankAccountPage extends StatelessWidget {
  final String bankName;
  final String accountHolderName;
  final String country;
  final String iban;
  final String? bankIconPath;

  const LinkedBankAccountPage({
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

    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: SafeArea(
        child: Column(
          children: [
            CustomTopBar.withTitle(
              title: Text(
                languageService.getText('linkedBankAccount'),
                style: AppFonts.lgBold(context, color: AppColors.white),
              ),
              leading: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              showNotification: false,
              showProfile: false,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Expanded(
                        child: BankInfoCard(
                          bankName: bankName,
                          accountHolderName: accountHolderName,
                          country: country,
                          iban: iban,
                          bankIconPath: bankIconPath,
                        ),
                      ),
                      const SizedBox(height: 20),
                      CustomButton(
                        text: languageService.getText('changeBankAccount'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChangeBankAccountPage(
                                currentBankName: bankName,
                                currentBankIconPath: bankIconPath,
                              ),
                            ),
                          );
                        },
                        showArrow: true,
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
