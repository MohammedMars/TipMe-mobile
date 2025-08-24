import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tipme_app/utils/app_font.dart';
import 'package:tipme_app/routs/app_routs.dart';
import '../../../utils/colors.dart';
import '../../../data/services/language_service.dart';

class VerificationPendingPage extends StatefulWidget {
  const VerificationPendingPage({Key? key}) : super(key: key);

  @override
  State<VerificationPendingPage> createState() =>
      _VerificationPendingPageState();
}

class _VerificationPendingPageState extends State<VerificationPendingPage> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.pushNamed(context, AppRoutes.logInQR);
      }
    });
  } //for now just to test the pages
//AE07 0331 2345 6789 0123 456

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final languageService = Provider.of<LanguageService>(context);
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: AppColors.secondary,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.secondary,
        appBar: AppBar(
          backgroundColor: AppColors.secondary,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: AppColors.secondary,
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.light,
          ),
          automaticallyImplyLeading: false,
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? 80 : 24,
            ),
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 76,
                          height: 76,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/icons/user-minus.svg',
                              width: 40,
                              height: 40,
                              colorFilter: const ColorFilter.mode(
                                AppColors.white,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          languageService.getText('verificationPending'),
                          style: AppFonts.h3(context, color: AppColors.white),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Container(
                          constraints: BoxConstraints(
                            maxWidth: isTablet ? 400 : screenSize.width - 48,
                          ),
                          child: Text(
                            languageService
                                .getText('verificationPendingMessage'),
                            style: AppFonts.mdMedium(context,
                                color: AppColors.white.withOpacity(0.9)),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  double _getResponsiveTitleFontSize(Size screenSize) {
    if (screenSize.width > 600) return 32;
    if (screenSize.width > 400) return 28;
    if (screenSize.width > 350) return 26;
    return 24;
  }

  double _getResponsiveSubtitleFontSize(Size screenSize) {
    if (screenSize.width > 600) return 18;
    if (screenSize.width > 400) return 16;
    if (screenSize.width > 350) return 15;
    return 16;
  }
}
