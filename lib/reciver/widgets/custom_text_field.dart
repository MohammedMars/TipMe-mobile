//lib/reciver/auth/widgets/custom_text_field.dart
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import '../../utils/colors.dart';
import '../../utils/app_font.dart';
import '../../data/services/language_service.dart';

class TermsText extends StatelessWidget {
  final VoidCallback? onTermsTapped;
  final VoidCallback? onPrivacyTapped;

  const TermsText({
    Key? key,
    this.onTermsTapped,
    this.onPrivacyTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languageService = Provider.of<LanguageService>(context);

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style:
            AppFonts.xsMedium(context, color: AppColors.text.withOpacity(0.8)),
        children: [
          TextSpan(text: languageService.getText('termsText')),
          TextSpan(
            text: languageService.getText('termsOfService'),
            style: AppFonts.xsMedium(context, color: AppColors.primary),
            recognizer: TapGestureRecognizer()..onTap = onTermsTapped,
          ),
          const TextSpan(text: ', '),
          TextSpan(
            text: languageService.getText('privacyPolicy'),
            style: AppFonts.xsMedium(context, color: AppColors.primary),
            recognizer: TapGestureRecognizer()..onTap = onPrivacyTapped,
          ),
          TextSpan(text: languageService.getText('termsEndText')),
        ],
      ),
    );
  }
}
