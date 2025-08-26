// lib/auth/screens/profile/terms_conditions_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tipme_app/reciver/widgets/mainProfile_widgets/terms_section_card.dart';
import 'package:tipme_app/reciver/widgets/wallet_widgets/custom_top_bar.dart';
import 'package:tipme_app/utils/app_font.dart';
import 'package:tipme_app/utils/colors.dart';
import 'package:tipme_app/data/services/language_service.dart';

class TermsConditionsPage extends StatelessWidget {
  const TermsConditionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languageService = Provider.of<LanguageService>(context);

    final List<Map<String, dynamic>> termsData = [
      {
        'title': languageService.getText('useOfService'),
        'description': languageService.getText('useOfServiceDesc'),
        'isNumbered': true,
        'number': 1,
      },
      {
        'title': languageService.getText('accountRegistration'),
        'description': languageService.getText('accountRegistrationDesc'),
        'isNumbered': true,
        'number': 2,
      },
      {
        'title': languageService.getText('intellectualProperty'),
        'description': languageService.getText('intellectualPropertyDesc'),
        'isNumbered': true,
        'number': 3,
      },
      {
        'title': languageService.getText('prohibitedActivities'),
        'description': languageService.getText('prohibitedActivitiesDesc'),
        'isNumbered': true,
        'number': 4,
      },
      {
        'title': languageService.getText('termination'),
        'description': languageService.getText('terminationDesc'),
        'isNumbered': true,
        'number': 5,
      },
      {
        'title': languageService.getText('changesToTerms'),
        'description': languageService.getText('changesToTermsDesc'),
        'isNumbered': true,
        'number': 6,
      },
      {
        'title': languageService.getText('contactUs'),
        'description': languageService.getText('contactUsDesc'),
        'isNumbered': true,
        'number': 7,
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: SafeArea(
        child: Column(
          children: [
            CustomTopBar.withTitle(
              title: Text(
                languageService.getText('termsAndConditions'),
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
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              languageService.getText('lastUpdated'),
                              style: AppFonts.mdBold(context,
                                  color: AppColors.black),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              languageService
                                  .getText('welcomeToTipMeTerms&Condition'),
                              style: AppFonts.smRegular(
                                context,
                                color: AppColors.text,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ],
                        ),
                      ),
                      ...termsData
                          .map((term) => TermsSectionCard(
                                title: term['title'],
                                description: term['description'],
                                isNumbered: term['isNumbered'] ?? true,
                                number: term['number'],
                              ))
                          .toList(),
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
