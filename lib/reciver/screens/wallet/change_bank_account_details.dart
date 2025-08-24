//lib\reciver\screens\wallet\change_bank_account_details.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tipme_app/core/dio/client/dio_client.dart';
import 'package:tipme_app/di/gitIt.dart';
import 'package:tipme_app/dtos/paymentInfoDto.dart';
import 'package:tipme_app/models/country.dart';
import 'package:tipme_app/reciver/widgets/custom_button.dart';
import 'package:tipme_app/routs/app_routs.dart';
import 'package:tipme_app/services/CacheService.dart';
import 'package:tipme_app/services/tipReceiverService.dart';
import 'package:tipme_app/utils/app_font.dart';
import 'package:tipme_app/reciver/widgets/wallet_widgets/custom_top_bar.dart';
import '../../../utils/colors.dart';
import '../../../data/services/language_service.dart';
import '../../widgets/custom_dropdown_field.dart';
import '../../widgets/custom_input_field.dart';
import '../../widgets/selected_bank_display.dart';

// import your DTO + service

class ChangeBankAccountDetailsPage extends StatefulWidget {
  final String bankName;
  final String? bankIconPath;

  const ChangeBankAccountDetailsPage({
    Key? key,
    required this.bankName,
    this.bankIconPath,
  }) : super(key: key);

  @override
  State<ChangeBankAccountDetailsPage> createState() =>
      _ChangeBankAccountDetailsPageState();
}

class _ChangeBankAccountDetailsPageState
    extends State<ChangeBankAccountDetailsPage> {
  List<Country> _countries = [];
  final TextEditingController _accountHolderController =
      TextEditingController();
  final TextEditingController _ibanController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _bankName;
  String? _selectedCountry;
  String? _accountHolderName;
  String? _iban;
  late TipReceiverService _tipReceiverService;
  final _cacheService =
      CacheService(sl<DioClient>(instanceName: 'CacheService'));

  bool _loading = false;

  bool get _isFormValid {
    return _accountHolderName != null &&
        _iban != null &&
        (_bankName ?? widget.bankName).isNotEmpty &&
        _selectedCountry != null;
  }

  @override
  void initState() {
    super.initState();
    _loadLookups();
    _bankName = widget.bankName; // prefill bank name
    _tipReceiverService =
        TipReceiverService(sl<DioClient>(instanceName: 'TipReceiver'));
  }

  Future<void> _loadLookups() async {
    final countries = await _cacheService.getCountries();
    setState(() {
      _countries = countries;
    });
  }

  void initService() {
    _tipReceiverService =
        TipReceiverService(sl<DioClient>(instanceName: 'TipReceiver'));
  }

  Future<void> _onSave() async {
    if (!_isFormValid || !_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      final dto = PaymentInfoDto(
        accountHolderName: _accountHolderController.text,
        iban: _ibanController.text,
        bankName: _bankName ?? widget.bankName,
        bankCountryId: _selectedCountry!,
      );

      final response = await _tipReceiverService.updatePaymentInfo(dto);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Bank account updated successfully")),
      );
      Navigator.pushNamed(context, AppRoutes.walletScreen);
      //Navigator.of(context).pop(response.data); // return updated info
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update bank account: $e")),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

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
                languageService.getText('editBankAccount'),
                style: AppFonts.lgBold(context, color: AppColors.white),
              ),
              leading: GestureDetector(
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.walletScreen),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _buildHeaderComponent(),
            ),
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 24,
                  ),
                  child: Column(
                    children: [
                      Expanded(child: _buildContent()),
                      const SizedBox(height: 20),
                      CustomButton(
                        onPressed: _loading ? null : _onSave,
                        isEnabled: _isFormValid && !_loading,
                        text: _loading
                            ? languageService.getText('loading')
                            : languageService.getText('submit'),
                        showArrow: false,
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

  Widget _buildContent() {
    final languageService = Provider.of<LanguageService>(context);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            languageService.getText('enterBankDetailsToUpdate'),
            style: AppFonts.mdBold(context, color: AppColors.black),
          ),
          const SizedBox(height: 24),
          CustomDropdownField(
            hintText: languageService.getText('selectCountry'),
            value: _selectedCountry,
            items: _countries
                .map((c) => DropdownMenuItem<String>(
                      value: c.id,
                      child: Text(c.name),
                    ))
                .toList(),
            validator: (value) => _validateCountry(value, languageService),
            onChanged: (value) {
              setState(() {
                _selectedCountry = value;
              });
            },
          ),
          const SizedBox(height: 16),
          CustomTextField(
            hintText: languageService.getText('accountHolderName'),
            controller: _accountHolderController,
            keyboardType: TextInputType.name,
            validator: (value) =>
                _validateAccountHolderName(value, languageService),
            onChanged: (value) {
              setState(() {
                _accountHolderName = value;
              });
            },
          ),
          const SizedBox(height: 16),
          CustomTextField(
            hintText: languageService.getText('enterIban'),
            controller: _ibanController,
            keyboardType: TextInputType.text,
            validator: (value) => _validateIBAN(value, languageService),
            suffixIcon: GestureDetector(
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
              setState(() {
                _iban = value;
              });
            },
          ),
          const Spacer(),
        ],
      ),
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

  String? _validateCountry(String? value, LanguageService languageService) {
    if (value == null || value.isEmpty) {
      return languageService.getText('countryRequired');
    }
    return null;
  }

  @override
  void dispose() {
    _accountHolderController.dispose();
    _ibanController.dispose();
    super.dispose();
  }
}
