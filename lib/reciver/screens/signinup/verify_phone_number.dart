//lib/reciver/auth/screens/login/verify_phone_page.dart (Updated with resend functionality)
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tipme_app/core/dio/client/dio_client.dart';
import 'package:tipme_app/core/storage/storage_service.dart';
import 'package:tipme_app/di/gitIt.dart';
import 'package:tipme_app/services/tipReceiverService.dart';
import 'package:tipme_app/utils/app_font.dart';
import 'package:tipme_app/viewModels/verifyOtpData.dart';
import '../../../routs/app_routs.dart';
import '../../../utils/colors.dart';
import '../../../data/services/language_service.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/otp_input.dart';
import 'package:tipme_app/services/authTipReceiverService.dart';
import 'package:tipme_app/dtos/verifyOtpDto.dart';
import 'package:tipme_app/dtos/signInUpDto.dart';

class VerifyPhonePage extends StatefulWidget {
  final String phoneNumber;
  final bool isLogin;

  const VerifyPhonePage({
    Key? key,
    required this.phoneNumber,
    this.isLogin = false, // <-- Default to false
  }) : super(key: key);

  @override
  State<VerifyPhonePage> createState() => _VerifyPhonePageState();
}

class _VerifyPhonePageState extends State<VerifyPhonePage> {
  String _otpCode = '';
  final int _otpLength = 6;
  bool _isVerifying = false;
  bool _isResending = false;
  String? _errorMessage;

  void _onOtpChanged(String value) {
    setState(() {
      _otpCode = value;
      _errorMessage = null;
    });
  }

  void _onVerifyPressed() async {
    if (_otpCode.length == _otpLength) {
      setState(() {
        _isVerifying = true;
        _errorMessage = null;
      });

      try {
        final service = AuthTipReceiverService(
            sl<DioClient>(instanceName: 'AuthTipReceiver'));
        final dto = VerifyOtpDto(
          mobileNumber: widget.phoneNumber,
          otp: _otpCode,
        );
        print(widget);
        final response = widget.isLogin
            ? await service.verifyLoginOtp(dto)
            : await service.verifyOtp(dto);

        if (response.success) {
          await _saveUserData(response.data);
          if (widget.isLogin) {
            final service =
                TipReceiverService(sl<DioClient>(instanceName: 'TipReceiver'));
            var response = await service.GetMe();
            print("response: ${response!.data!.isCompleted}");
            if (response!.data!.isCompleted == true) {
              Navigator.of(context)
                  .pushReplacementNamed(AppRoutes.verificationPending);
              return;
            }
          }
          Navigator.of(context).pushReplacementNamed(AppRoutes.welcome);
        } else {
          setState(() {
            _errorMessage = response.message.isNotEmpty
                ? response.message
                : 'Verification failed. Please try again.';
          });
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'An error occurred. Please try again.';
        });
        print("Verify OTP Error: $e");
      } finally {
        setState(() {
          _isVerifying = false;
        });
      }
    }
  }

  void _onResendCode() async {
    setState(() {
      _isResending = true;
      _errorMessage = null;
    });

    try {
      final service = AuthTipReceiverService(
          sl<DioClient>(instanceName: 'AuthTipReceiver'));
      final dto = SignInUpDto(mobileNumber: widget.phoneNumber);
      print(widget.isLogin);
      final response =
          widget.isLogin ? await service.login(dto) : await service.signUp(dto);

      if (response.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Verification code sent successfully'),
            backgroundColor: Colors.green,
          ),
        );
        setState(() {
          _otpCode = '';
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message.isNotEmpty
                ? response.message
                : 'Failed to resend code. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to resend code. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
      print("Resend OTP Error: $e");
    } finally {
      setState(() {
        _isResending = false;
      });
    }
  }

  void _onEditNumber() {
    Navigator.of(context).pop();
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
          onPressed: () => Navigator.of(context).pop(),
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
                          languageService.getText('verifyPhoneTitle'),
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
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: AppFonts.mdMedium(context,
                                color: AppColors.white.withOpacity(0.9)),
                            children: [
                              TextSpan(
                                text: languageService
                                    .getText('verifyPhoneSubtitle'),
                              ),
                              TextSpan(
                                text: widget.phoneNumber,
                                style: AppFonts.mdSemiBold(context,
                                    color: AppColors.white.withOpacity(0.9)),
                              ),
                              const TextSpan(text: '" '),
                              TextSpan(
                                text: languageService.getText('editNumber'),
                                style: AppFonts.mdSemiBold(context,
                                    color: AppColors.primary),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = _onEditNumber,
                              ),
                            ],
                          ),
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
                            OtpInput(
                              length: _otpLength,
                              onOtpChanged: _onOtpChanged,
                              otpCode: _otpCode,
                            ),
                            const SizedBox(height: 16),

                            // Error message display
                            if (_errorMessage != null) ...[
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                  border:
                                      Border.all(color: Colors.red.shade200),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.error_outline,
                                      color: Colors.red.shade600,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        _errorMessage!,
                                        style: AppFonts.smMedium(context,
                                            color: Colors.red.shade600),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],

                            CustomButton(
                              text: _isVerifying
                                  ? 'Verifying...'
                                  : languageService
                                      .getText('verifyPhoneNumber'),
                              onPressed: (_otpCode.length == _otpLength &&
                                      !_isVerifying)
                                  ? _onVerifyPressed
                                  : null,
                              isEnabled: _otpCode.length == _otpLength &&
                                  !_isVerifying,
                              showArrow: !_isVerifying,
                            ),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  languageService.getText('didntGetOtp'),
                                  style: AppFonts.mdMedium(context,
                                      color: Colors.grey[600]),
                                ),
                                GestureDetector(
                                  onTap: _isResending ? null : _onResendCode,
                                  child: Text(
                                    _isResending
                                        ? 'Sending...'
                                        : languageService.getText('resendCode'),
                                    style: AppFonts.mdMedium(context,
                                        color: _isResending
                                            ? Colors.grey[400]
                                            : AppColors.primary),
                                  ),
                                ),
                              ],
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

  Future<void> _saveUserData(VerifyOtpData? data) async {
    await StorageService.save('user_token', data?.token);
    await StorageService.save('user_id', data?.id);
    await StorageService.save('mobile_number', widget.phoneNumber);
  }
}
