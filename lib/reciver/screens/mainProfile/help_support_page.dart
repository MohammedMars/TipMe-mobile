// lib/auth/screens/profile/help_support_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tipme_app/reciver/widgets/mainProfile_widgets/contact_support_bottom.dart';
import 'package:tipme_app/reciver/widgets/mainProfile_widgets/custom_list_card.dart';
import 'package:tipme_app/reciver/widgets/wallet_widgets/custom_top_bar.dart';
import 'package:tipme_app/routs/app_routs.dart';
import 'package:tipme_app/utils/app_font.dart';
import 'package:tipme_app/utils/colors.dart';
import 'package:tipme_app/data/services/language_service.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({Key? key}) : super(key: key);

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
                languageService.getText('helpAndSupport'),
                style: AppFonts.lgBold(context, color: AppColors.white),
              ),
              leading: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.white.withOpacity(0.2),
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
                  color: AppColors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  children: [
                    CustomListCard(
                      title: languageService.getText('contactSupport'),
                      subtitle: languageService.getText('reachOutForHelp'),
                      iconPath: 'assets/icons/headphones.svg',
                      iconColor: AppColors.secondary_500,
                      onTap: () {
                        ContactSupportBottomSheet.show(context);
                      },
                      borderType: CardBorderType.bottom,
                      borderRadius: 0.0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 16.0,
                      ),
                      trailingType: TrailingType.arrow,
                    ),
                    CustomListCard(
                      title: languageService.getText('reportAProblem'),
                      subtitle: languageService.getText('letUsKnowIssues'),
                      iconPath: 'assets/icons/exclamation-circle.svg',
                      iconColor: AppColors.secondary_500,
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.reportProblem);
                      },
                      borderType: CardBorderType.bottom,
                      borderRadius: 0.0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 16.0,
                      ),
                      trailingType: TrailingType.arrow,
                    ),
                    CustomListCard(
                      title: languageService.getText('faq'),
                      subtitle: languageService.getText('findQuickAnswers'),
                      iconPath: 'assets/icons/progress-help.svg',
                      iconColor: AppColors.secondary_500,
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.faq);
                      },
                      borderType: CardBorderType.bottom,
                      borderRadius: 0.0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 16.0,
                      ),
                      trailingType: TrailingType.arrow,
                    ),
                    CustomListCard(
                      title: languageService.getText('termsAndConditions'),
                      subtitle: languageService.getText('readTheRules'),
                      iconPath: 'assets/icons/file-text.svg',
                      iconColor: AppColors.secondary_500,
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.termsConditions);
                      },
                      borderType: CardBorderType.bottom,
                      borderRadius: 0.0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 16.0,
                      ),
                      trailingType: TrailingType.arrow,
                    ),
                    CustomListCard(
                      title: languageService.getText('privacyPolicy'),
                      subtitle: languageService.getText('seeHowWeHandleData'),
                      iconPath: 'assets/icons/file-text-shield.svg',
                      iconColor: AppColors.secondary_500,
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.privacyPolicy);
                      },
                      borderType: CardBorderType.none,
                      borderRadius: 0.0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 16.0,
                      ),
                      trailingType: TrailingType.arrow,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
