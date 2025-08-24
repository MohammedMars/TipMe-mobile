//lib/reciver/auth/screens/login/sign_in_up.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tipme_app/core/dio/client/dio_client.dart';
import 'package:tipme_app/di/gitIt.dart';
import 'package:tipme_app/services/authTipReceiverService.dart';
import 'package:tipme_app/dtos/signInUpDto.dart';
import 'package:tipme_app/utils/app_font.dart';
import '../../../utils/colors.dart';
import '../../../routs/app_routs.dart';
import '../../../data/services/language_service.dart';
import '../../widgets/phone_input.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class SignInUpPage extends StatefulWidget {
  const SignInUpPage({Key? key}) : super(key: key);

  @override
  State<SignInUpPage> createState() => _SignInUpPageState();
}

class _SignInUpPageState extends State<SignInUpPage> {
  final TextEditingController _phoneController = TextEditingController();
  String _phoneNumber = '';
  String _countryCode = '+971';

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(() {
      setState(() {
        _phoneNumber = _phoneController.text;
      });
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _onPhoneChanged(String value) {
    setState(() {
      _phoneNumber = value;
    });
  }

  void _onCountryChanged(String countryCode) {
    setState(() {
      _countryCode = countryCode;
    });
  }

  void _onContinue() async {
    if (_phoneNumber.isNotEmpty && _phoneNumber.length == 11) {
      final cleanedPhoneNumber = _phoneNumber.replaceAll(' ', '');
      final cleanedCountryCode = _countryCode.replaceAll(' ', '');
      final fullPhoneNumber = '$cleanedCountryCode$cleanedPhoneNumber';

      try {
        final service = AuthTipReceiverService(
            sl<DioClient>(instanceName: 'AuthTipReceiver'));
        final dto = SignInUpDto(mobileNumber: fullPhoneNumber);
        final result = await service.signUp(dto);

        if (result.success) {
          Navigator.of(context).pushNamed(
            AppRoutes.verifyPhone,
            arguments: {'phoneNumber': fullPhoneNumber},
          );
        } else {
          if (result.errorCode == -2) {
            // User already exists, so call Login API
            final loginResult = await service.login(dto);

            if (loginResult.success) {
              Navigator.of(context).pushNamed(
                AppRoutes.verifyPhone,
                arguments: {'phoneNumber': fullPhoneNumber, 'isLogin': true},
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(loginResult.message.isNotEmpty
                      ? loginResult.message
                      : 'Login failed. Please try again.'),
                  backgroundColor: Colors.red,
                ),
              );
              print("Login failed: ${loginResult.message}");
            }
          }
          print("Signup failed: ${result.message}");
        }
      } catch (e, s) {
        print("Error: $e");
        print("StackTrace: $s");
      }
    } else {
      print("Invalid phone number");
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageService = Provider.of<LanguageService>(context);
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;
    final isSmallScreen = screenSize.height < 700;

    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(
        backgroundColor: AppColors.secondary,
        elevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/arrow-left.svg',
            width: 20,
            height: 20,
            colorFilter: const ColorFilter.mode(
              AppColors.white,
              BlendMode.srcIn,
            ),
          ),
          onPressed: () =>
              Navigator.of(context).pushNamed(AppRoutes.onboardingWelcome),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  AppBar().preferredSize.height,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? 80 : 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      SizedBox(height: isSmallScreen ? 10 : 20),
                      Image.asset(
                        'assets/images/Isolation_Mode.png',
                        width: isSmallScreen ? 48 : 58,
                        height: isSmallScreen ? 46 : 56,
                      ),
                      SizedBox(height: isSmallScreen ? 24 : 40),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          languageService.getText('signInUpTitle'),
                          style: AppFonts.h3(context, color: AppColors.white),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                        ),
                      ),
                      SizedBox(height: isSmallScreen ? 12 : 16),
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: isTablet ? 400 : screenSize.width - 48,
                        ),
                        child: Text(
                          languageService.getText('signInUpSubtitle'),
                          style: AppFonts.mdMedium(context,
                              color: AppColors.white.withOpacity(0.9)),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                        ),
                      ),
                      SizedBox(height: isSmallScreen ? 20 : 40),
                      Container(
                        width: isTablet ? 400 : double.infinity,
                        padding: EdgeInsets.all(isSmallScreen ? 20 : 24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Column(
                          children: [
                            CustomPhoneInput(
                              controller: _phoneController,
                              onPhoneChanged: _onPhoneChanged,
                              onCountryChanged: _onCountryChanged,
                              phoneNumber: _phoneNumber,
                            ),
                            SizedBox(height: 24),
                            CustomButton(
                              text: languageService.getText('continue'),
                              onPressed: _phoneNumber.length == 11
                                  ? _onContinue
                                  : null,
                              isEnabled: _phoneNumber.length == 11,
                              showArrow: true,
                            ),
                            SizedBox(height: 24),
                            TermsText(
                              onTermsTapped: () {
                                print('Terms tapped'); //to be handled later
                              },
                              onPrivacyTapped: () {
                                print('Privacy tapped'); //to be handled later
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: isSmallScreen ? 20 : 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
