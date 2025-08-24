//lib\reciver\auth\widgets\mainProfile_widgets\otp_card.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tipme_app/reciver/widgets/otp_input.dart';
import 'package:tipme_app/reciver/widgets/mainProfile_widgets/verification_success_sheet.dart';
import 'package:tipme_app/utils/app_font.dart';
import 'package:tipme_app/utils/colors.dart';
import 'package:tipme_app/data/services/language_service.dart';

void showOtpPopup(BuildContext context, String phoneNumber) {
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

      void onOtpChanged(String code) {
        otpCode = code;
        isButtonEnabled.value = otpCode.length == 6;
      }

      void onVerify() {
        if (otpCode.length == 6) {
          print("OTP Verified: $otpCode");
          Navigator.of(context).pop();

          VerificationSuccessSheet.show(
            context,
            titleKey: 'Verified Successfully',
            descriptionKey: 'Your OTP has been verified successfully.',
            buttonTextKey: 'Close',
            icon: Icons.check,
            iconColor: AppColors.success,
            iconBackgroundColor: AppColors.white,
            buttonColor: AppColors.primary,
            buttonTextColor: AppColors.white,
            onButtonPressed: () {
              Navigator.of(context).pop();
            },
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(languageService.getText("invalidOtp"))),
          );
        }
      }

      void onResend() {
        print("Resend OTP clicked");
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
                        languageService.getText("enterOtpTitle"),
                        textAlign: TextAlign.center,
                        style: AppFonts.h3(context, color: AppColors.black),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        languageService
                            .getText("enterOtpSubtitle")!
                            .replaceAll("{phoneNumber}", phoneNumber),
                        textAlign: TextAlign.center,
                        style:
                            AppFonts.mdMedium(context, color: AppColors.text),
                      ),
                      const SizedBox(height: 24),
                      OtpInput(
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
                            languageService.getText("didntGetOtp"),
                            style:
                                AppFonts.mdBold(context, color: AppColors.text),
                          ),
                          TextButton(
                            onPressed: onResend,
                            child: Text(
                              languageService.getText("resendCode"),
                              style: AppFonts.mdMedium(context,
                                  color: AppColors.primary),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ValueListenableBuilder<bool>(
                        valueListenable: isButtonEnabled,
                        builder: (context, enabled, child) {
                          return SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: enabled ? onVerify : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                disabledBackgroundColor:
                                    AppColors.primary.withOpacity(0.4),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: Text(
                                languageService.getText("verifyPhoneNumber"),
                                style: AppFonts.mdBold(context,
                                    color: AppColors.white),
                              ),
                            ),
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
