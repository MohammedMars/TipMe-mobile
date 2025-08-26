// lib/reciver/auth/widgets/mainProfile_widgets/otp_card.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tipme_app/reciver/widgets/otp_input.dart';
import 'package:tipme_app/reciver/widgets/mainProfile_widgets/verification_success_sheet.dart';
import 'package:tipme_app/utils/app_font.dart';
import 'package:tipme_app/utils/colors.dart';
import 'package:tipme_app/data/services/language_service.dart';
import 'package:tipme_app/services/authTipReceiverService.dart';
import 'package:tipme_app/dtos/verifyOtpDto.dart';
import 'package:tipme_app/di/gitIt.dart';

ValueNotifier<bool> isPhoneVerified = ValueNotifier(false);

void showOtpPopup(
  BuildContext context,
  String phoneNumber,
  VoidCallback onVerificationSuccess, {
  String? userId,
}) {
  final authService = sl<AuthTipReceiverService>();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(0.5),
    isDismissible: true,
    builder: (context) {
      final languageService =
          Provider.of<LanguageService>(context, listen: false);
      String otpCode = "";
      final ValueNotifier<bool> isButtonEnabled = ValueNotifier(false);
      final ValueNotifier<bool> isResending = ValueNotifier(false);
      final ValueNotifier<bool> isVerifying = ValueNotifier(false);

      final GlobalKey<OtpInputState> otpInputKey = GlobalKey<OtpInputState>();

      void onOtpChanged(String code) {
        otpCode = code;
        isButtonEnabled.value = otpCode.length == 6;
      }

      void onVerify() async {
        if (otpCode.length == 6) {
          isVerifying.value = true;

          bool verificationSuccess = false;

          // Call ChangeMobileNumber API if userId is provided
          if (userId != null) {
            try {
              print('Verifying OTP and changing mobile number: $otpCode');

              final verifyDto = VerifyOtpDto(
                mobileNumber: phoneNumber,
                otp: otpCode,
              );
              final changeResponse =
                  await authService.changeMobileNumber(userId, verifyDto);

              print(
                  'Change mobile number response: ${changeResponse.success}, message: ${changeResponse.message}');

              if (changeResponse.success) {
                verificationSuccess = true;
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        Text(changeResponse.message ?? 'Failed to verify OTP'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            } catch (e) {
              print('Error verifying OTP: $e');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error verifying OTP: $e'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          } else {
            // Default behavior for non-mobile-change scenarios
            verificationSuccess = true;
          }

          isVerifying.value = false;

          if (verificationSuccess) {
            print("OTP Verified: $otpCode");

            Navigator.of(context).pop();

            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              isScrollControlled: true,
              builder: (context) => VerificationSuccessSheet(
                titleKey: languageService.getText('verifiedSuccessfully'),
                descriptionKey: userId != null
                    ? languageService.getText('mobileNumberChangedSuccessfully')
                    : languageService.getText('otpVerifiedSuccessfully'),
                buttonTextKey: languageService.getText('close'),
                iconColor: AppColors.success,
                iconBackgroundColor: AppColors.white,
                buttonColor: AppColors.primary,
                buttonTextColor: AppColors.white,
                onButtonPressed: () {
                  onVerificationSuccess();
                  Navigator.of(context).pop();
                },
                icon: Icons.check,
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    languageService.getText("invalidOtp") ?? "Invalid OTP")),
          );
        }
      }

      void onResend() async {
        isResending.value = true;
        print("Resend OTP clicked");

        try {
          await Future.delayed(const Duration(seconds: 2));

          otpInputKey.currentState?.restartTimer();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Verification code sent successfully'),
              backgroundColor: Colors.green,
            ),
          );

          otpCode = "";
          isButtonEnabled.value = false;
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to resend code. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
          print("Resend OTP Error: $e");
        } finally {
          isResending.value = false;
        }
      }

      return WillPopScope(
        onWillPop: () async {
          otpCode = "";
          return true;
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => Navigator.of(context).pop(),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        languageService.getText("enterOtpTitle") ?? "Enter OTP",
                        textAlign: TextAlign.center,
                        style: AppFonts.h3(context, color: AppColors.black),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        (languageService.getText("enterOtpSubtitle") ??
                                "We've sent an OTP to {phoneNumber}")
                            .replaceAll("{phoneNumber}", phoneNumber),
                        textAlign: TextAlign.center,
                        style:
                            AppFonts.mdMedium(context, color: AppColors.text),
                      ),
                      const SizedBox(height: 24),
                      OtpInput(
                        key: otpInputKey,
                        length: 6,
                        otpCode: otpCode,
                        onOtpChanged: onOtpChanged,
                        onTimerExpired: () {
                          print("OTP timer expired");
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            languageService.getText("didntGetOtp") ??
                                "Didn't get OTP?",
                            style:
                                AppFonts.mdBold(context, color: AppColors.text),
                          ),
                          ValueListenableBuilder<bool>(
                            valueListenable: isResending,
                            builder: (context, resending, child) {
                              return TextButton(
                                onPressed: resending ? null : onResend,
                                child: Text(
                                  resending
                                      ? 'Sending...'
                                      : languageService.getText("resendCode") ??
                                          "Resend Code",
                                  style: AppFonts.mdMedium(
                                    context,
                                    color: resending
                                        ? Colors.grey[400]
                                        : AppColors.primary,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ValueListenableBuilder<bool>(
                        valueListenable: isButtonEnabled,
                        builder: (context, enabled, child) {
                          return ValueListenableBuilder<bool>(
                            valueListenable: isVerifying,
                            builder: (context, verifying, child) {
                              return SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed:
                                      (enabled && !verifying) ? onVerify : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    disabledBackgroundColor:
                                        AppColors.primary.withOpacity(0.4),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: verifying
                                      ? SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Colors.white),
                                          ),
                                        )
                                      : Text(
                                          languageService.getText(
                                                  "verifyPhoneNumber") ??
                                              "Verify Phone Number",
                                          style: AppFonts.mdBold(context,
                                              color: AppColors.white),
                                        ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  ).whenComplete(() {
    print("OTP Popup closed, reset values");
  });
}
