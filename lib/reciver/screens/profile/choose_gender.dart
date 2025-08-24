//lib\auth\screens\profile\choose_gender.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tipme_app/core/storage/storage_service.dart';
import 'package:tipme_app/providersChangeNotifier/profileSetupProvider.dart';
import 'package:tipme_app/utils/app_font.dart';
import '../../../routs/app_routs.dart';
import '../../../utils/colors.dart';
import '../../../data/services/language_service.dart';
import '../../widgets/onboarding_layout.dart';
import '../../widgets/gender_selection_card.dart';
import '../../widgets/progress_next_button.dart';

class ChooseGenderPage extends StatefulWidget {
  const ChooseGenderPage({Key? key}) : super(key: key);

  @override
  State<ChooseGenderPage> createState() => _ChooseGenderPageState();
}

class _ChooseGenderPageState extends State<ChooseGenderPage> {
  String? _selectedGender;

  Future<void> _onGenderSelected(String gender) async {
    setState(() {
      _selectedGender = gender;
    });
    final provider = Provider.of<ProfileSetupProvider>(context, listen: false);
    provider.update(
      mobileNumber: await StorageService.get('mobile_number'),
      genderString: gender,
      gender: gender == 'Male' ? 0 : 1,
    );
  }

  void _onNext() {
    if (_selectedGender != null) {
      Navigator.of(context).pushNamed(
        AppRoutes.profileSetup
      );
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
            languageService.getText('personalizeProfileByGender'),
            style: AppFonts.mdMedium(context,
                color: AppColors.white.withOpacity(0.9)),
            textAlign: TextAlign.center,
            maxLines: 3,
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

  @override
  Widget build(BuildContext context) {
    final languageService = Provider.of<LanguageService>(context);

    return OnboardingLayout(
      step: 1,
      totalSteps: 5,
      titleKey: 'chooseYourGender',
      headerComponent: _buildHeaderComponent(),
      content: _buildGenderSelection(),
      nextButton: ProgressNextButton(
        onPressed: _selectedGender != null ? _onNext : null,
        isEnabled: _selectedGender != null,
        currentStep: 1,
        totalSteps: 5,
      ),
      topPadding: 16.0,
      bottomPadding: 48.0,
    );
  }

  Widget _buildGenderSelection() {
    final languageService = Provider.of<LanguageService>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: GenderSelectionCard(
                genderKey: 'male',
                gender: languageService.getText('male'),
                isSelected: _selectedGender == 'Male',
                onTap: () => _onGenderSelected('Male'),
                svgPath: 'assets/images/male.svg',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: GenderSelectionCard(
                genderKey: 'female',
                gender: languageService.getText('female'),
                isSelected: _selectedGender == 'Female',
                onTap: () => _onGenderSelected('Female'),
                svgPath: 'assets/images/female.svg',
              ),
            ),
          ],
        ),
        const Spacer(),
      ],
    );
  }
}
