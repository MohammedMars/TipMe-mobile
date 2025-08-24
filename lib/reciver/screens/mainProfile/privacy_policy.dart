// lib/auth/screens/profile/pivacy_policy.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tipme_app/reciver/widgets/mainProfile_widgets/terms_section_card.dart';
import 'package:tipme_app/reciver/widgets/wallet_widgets/custom_top_bar.dart';
import 'package:tipme_app/utils/app_font.dart';
import 'package:tipme_app/utils/colors.dart';
import 'package:tipme_app/data/services/language_service.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languageService = Provider.of<LanguageService>(context);

    // Terms and Conditions data
    final List<Map<String, dynamic>> termsData = [
      {
        'title': 'Use of Service',
        'description':
            'You agree to use the service only for lawful purposes and in accordance with these terms. You are responsible for any activity that occurs under your account.',
        'isNumbered': true,
        'number': 1,
      },
      {
        'title': 'Account Registration',
        'description':
            'To access certain features, you may need to create an account. You are responsible for keeping your login information secure and notifying us immediately of any unauthorized use.',
        'isNumbered': true,
        'number': 2,
      },
      {
        'title': 'Intellectual Property',
        'description':
            'All content, including logos, images, text, and software, is owned by [Your Company Name] and protected by copyright and other laws.',
        'isNumbered': true,
        'number': 3,
      },
      {
        'title': 'Prohibited Activities',
        'description':
            'You may not use the service for any unlawful purpose or in a way that could harm, disable, or interfere with the site or its users.',
        'isNumbered': true,
        'number': 4,
      },
      {
        'title': 'Termination',
        'description':
            'We may suspend or terminate your access to the service at any time for violations of these terms.',
        'isNumbered': true,
        'number': 5,
      },
      {
        'title': 'Changes to Terms',
        'description':
            'We may update these terms from time to time. Any changes will be posted on this page with the updated date.',
        'isNumbered': true,
        'number': 6,
      },
      {
        'title': 'Contact Us',
        'description':
            'If you have any questions about these Terms and Conditions, please contact us at support@tipme.com.',
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
                'Terms and Condition',
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
                              'Last Updated: 5 April, 2025',
                              style: AppFonts.mdBold(context,
                                  color: AppColors.black),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'At TipMe, your privacy is important to us. This Privacy Policy explains how we collect, use, and protect your information.',
                              style: AppFonts.smRegular(
                                context,
                                color: AppColors.text,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ],
                        ),
                      ),

                      // Terms sections
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
