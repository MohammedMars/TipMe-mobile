//lib/auth/screens/profile/bank_account_details.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tipme_app/providersChangeNotifier/profileSetupProvider.dart';
import 'package:tipme_app/utils/app_font.dart';
import '../../../routs/app_routs.dart';
import '../../../utils/colors.dart';
import '../../../data/services/language_service.dart';
import '../../widgets/onboarding_layout.dart';
import '../../widgets/custom_input_field.dart';
import '../../widgets/progress_next_button.dart';
import '../../widgets/selected_bank_display.dart';
import '../../widgets/iban_help_bottom_sheet.dart';

class BankAccountDetailsPage extends StatefulWidget {
  final String bankName;
  final String? bankIconPath;

  const BankAccountDetailsPage({
    Key? key,
    required this.bankName,
    this.bankIconPath,
  }) : super(key: key);

  @override
  State<BankAccountDetailsPage> createState() => _BankAccountDetailsPageState();
}

class _BankAccountDetailsPageState extends State<BankAccountDetailsPage> {
  final TextEditingController _accountHolderController =
      TextEditingController();
  final TextEditingController _ibanController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool get _isFormValid {
    return _accountHolderController.text.trim().isNotEmpty &&
        _ibanController.text.trim().isNotEmpty;
  }

  void _onNext() {
    if (_isFormValid && _formKey.currentState!.validate()) {
      final provider = Provider.of<ProfileSetupProvider>(context, listen: false);
      provider.update(
        accountHolderName: _accountHolderController.text.trim(),
        iban: _ibanController.text.trim(),
        bankName: widget.bankName
      );
      Navigator.of(context).pushNamed(
        AppRoutes.agreeToTerms,
        arguments: {
          'bankName': widget.bankName,
          'accountHolderName': _accountHolderController.text.trim(),
          'iban': _ibanController.text.trim(),
        },
      );
    }
  }

  Widget _buildHeaderComponent() {
    return Column(
      children: [
        SelectedBankDisplay(
          bankName: widget.bankName,
          iconPath: widget.bankIconPath,
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  String? _validateAccountHolderName(
      String? value, LanguageService languageService) {
    if (value == null || value.trim().isEmpty) {
      return languageService.getText('accountHolderNameRequired');
    }
    if (value.trim().length < 2) {
      return languageService.getText('pleaseEnterValidName');
    }
    return null;
  }

  String? _validateIBAN(String? value, LanguageService languageService) {
    if (value == null || value.trim().isEmpty) {
      return languageService.getText('ibanRequired');
    }
    if (value.trim().length < 15) {
      return languageService.getText('pleaseEnterValidIban');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingLayout(
      step: 4,
      totalSteps: 5,
      titleKey: 'addNewBankAccount',
      headerComponent: _buildHeaderComponent(),
      content: _buildContent(),
      nextButton: ProgressNextButton(
        onPressed: _isFormValid ? _onNext : null,
        isEnabled: _isFormValid,
        currentStep: 4,
        totalSteps: 5,
      ),
      topPadding: 16.0,
      bottomPadding: 16.0,
    );
  }

  Widget _buildContent() {
    final languageService = Provider.of<LanguageService>(context);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            languageService.getText('enterIbanToLinkBank'),
            style: AppFonts.mdBold(context, color: AppColors.black),
          ),
          const SizedBox(height: 24),
          CustomTextField(
            hintText: languageService.getText('accountHolderName'),
            controller: _accountHolderController,
            keyboardType: TextInputType.name,
            validator: (value) =>
                _validateAccountHolderName(value, languageService),
            onChanged: (value) {
              setState(() {});
            },
          ),
          const SizedBox(height: 16),
          CustomTextField(
            hintText: languageService.getText('enterIban'),
            controller: _ibanController,
            keyboardType: TextInputType.text,
            validator: (value) => _validateIBAN(value, languageService),
            suffixIcon: GestureDetector(
              onTap: () => HelpBottomSheet.show(
                context,
                titleKey: 'iban',
                paragraphKeys: ['ibanDescription', 'ibanLocation'],
                buttonTextKey: 'back',
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: SvgPicture.asset(
                  'assets/icons/progress-help.svg',
                  width: 20,
                  height: 20,
                  colorFilter: ColorFilter.mode(
                    AppColors.text.withOpacity(0.6),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            onChanged: (value) {
              setState(() {});
            },
          ),
          const Spacer(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _accountHolderController.dispose();
    _ibanController.dispose();
    super.dispose();
  }
}
