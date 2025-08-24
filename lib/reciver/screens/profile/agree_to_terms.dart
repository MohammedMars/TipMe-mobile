//lib\auth\screens\profile\agree_to_terms.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tipme_app/core/dio/client/dio_client.dart';
import 'package:tipme_app/di/gitIt.dart';
import 'package:tipme_app/utils/app_font.dart';
import 'package:tipme_app/services/authTipReceiverService.dart';
import 'package:tipme_app/providersChangeNotifier/profileSetupProvider.dart';
import '../../../routs/app_routs.dart';
import '../../../utils/colors.dart';
import '../../../data/services/language_service.dart';
import '../../widgets/onboarding_layout.dart';
import '../../widgets/progress_next_button.dart';
import '../../widgets/custom_checkbox.dart';

class AgreeToTermsPage extends StatefulWidget {
  const AgreeToTermsPage({Key? key}) : super(key: key);

  @override
  State<AgreeToTermsPage> createState() => _AgreeToTermsPageState();
}

class _AgreeToTermsPageState extends State<AgreeToTermsPage> {
  bool _agreeToTerms = false;
  bool _confirmAccurateInfo = false;

  void _onTermsChanged(bool value) {
    setState(() {
      _agreeToTerms = value;
    });
  }

  void _onAccurateInfoChanged(bool value) {
    setState(() {
      _confirmAccurateInfo = value;
    });
  }

  void _onNext() async {
    if (_agreeToTerms && _confirmAccurateInfo) {
      final provider =
          Provider.of<ProfileSetupProvider>(context, listen: false);

      final profileProvider = context.read<ProfileSetupProvider>();

      final formData = profileProvider.toFormData();

      final authClient = sl<DioClient>(instanceName: 'AuthTipReceiver');
      final result = await AuthTipReceiverService(authClient).completeProfile(formData);

      if (result.success) {
        Navigator.of(context).pushNamed(AppRoutes.verificationPending);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.message.isNotEmpty
                ? result.message
                : 'Profile completion failed. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildHeaderComponent() {
    final languageService = Provider.of<LanguageService>(context);

    return Builder(
      builder: (context) {
        final screenSize = MediaQuery.of(context).size;
        final isTablet = screenSize.width > 600;

        return Container(
          constraints: BoxConstraints(
            maxWidth: isTablet ? 400 : screenSize.width - 48,
          ),
          child: Text(
            languageService.getText('confirmAgreementToTerms'),
            style: AppFonts.mdMedium(context,
                color: AppColors.white.withOpacity(0.9)),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        );
      },
    );
  }

  double _getResponsiveSubtitleFontSize(Size screenSize) {
    if (screenSize.width > 600) return 18;
    if (screenSize.width > 400) return 16;
    if (screenSize.width > 350) return 15;
    return 14;
  }

  Widget _buildTermsContent() {
    final languageService = Provider.of<LanguageService>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomCheckbox(
          value: _agreeToTerms,
          onChanged: _onTermsChanged,
          text: languageService.getText('iAgreeToTipMeTerms'),
          linkText: languageService.getText('termsAndConditions'),
          onLinkTap: () {},
        ),
        const SizedBox(height: 8),
        CustomCheckbox(
          value: _confirmAccurateInfo,
          onChanged: _onAccurateInfoChanged,
          text: languageService.getText('iConfirmAccurateInfo'),
        ),
        const Spacer(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingLayout(
      step: 5,
      totalSteps: 5,
      titleKey: 'agreeToOurTerms',
      headerComponent: _buildHeaderComponent(),
      content: _buildTermsContent(),
      nextButton: ProgressNextButton(
        onPressed: (_agreeToTerms && _confirmAccurateInfo) ? _onNext : null,
        isEnabled: _agreeToTerms && _confirmAccurateInfo,
        currentStep: 5,
        totalSteps: 5,
      ),
      topPadding: 16.0,
      bottomPadding: 48.0,
    );
  }
}
