//lib\auth\widgets\onboarding_layout.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tipme_app/utils/app_font.dart';
import '../../../utils/colors.dart';
import '../../data/services/language_service.dart';
import 'custom_app_bar.dart';

class OnboardingLayout extends StatelessWidget {
  final int step;
  final int totalSteps;
  final String? title;
  final String? titleKey;
  final Widget headerComponent;
  final Widget content;
  final Widget nextButton;
  final double topPadding;
  final double bottomPadding;

  const OnboardingLayout({
    Key? key,
    required this.step,
    required this.totalSteps,
    this.title,
    this.titleKey,
    required this.headerComponent,
    required this.content,
    required this.nextButton,
    this.topPadding = 40.0,
    this.bottomPadding = 40.0,
  }) : super(key: key);

  // Factory constructor for subtitle (backward compatibility)
  factory OnboardingLayout.withSubtitle({
    Key? key,
    required int step,
    required int totalSteps,
    String? title,
    String? titleKey,
    String? subtitle,
    String? subtitleKey,
    required Widget content,
    required Widget nextButton,
    double topPadding = 40.0,
    double bottomPadding = 40.0,
  }) {
    return OnboardingLayout(
      key: key,
      step: step,
      totalSteps: totalSteps,
      title: title,
      titleKey: titleKey,
      headerComponent: Builder(
        builder: (context) {
          final languageService = Provider.of<LanguageService>(context);
          final screenSize = MediaQuery.of(context).size;
          final isTablet = screenSize.width > 600;

          final displaySubtitle = subtitleKey != null
              ? languageService.getText(subtitleKey)
              : subtitle ?? '';

          return Container(
            constraints: BoxConstraints(
              maxWidth: isTablet ? 400 : screenSize.width - 48,
            ),
            child: Text(
              displaySubtitle,
              style: AppFonts.mdMedium(context,
                  color: AppColors.white.withOpacity(0.9)),
              textAlign: TextAlign.center,
              maxLines: 3,
            ),
          );
        },
      ),
      content: content,
      nextButton: nextButton,
      topPadding: topPadding,
      bottomPadding: bottomPadding,
    );
  }

  @override
  Widget build(BuildContext context) {
    final languageService = Provider.of<LanguageService>(context);
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;
    final isSmallScreen = screenSize.height < 700;

    final displayTitle =
        titleKey != null ? languageService.getText(titleKey!) : title ?? '';

    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: CustomAppBar(
        step: step,
        totalSteps: totalSteps,
      ),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            // Blue section with configurable padding
            SizedBox(height: topPadding),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? 80 : 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      displayTitle,
                      style: AppFonts.h3(context, color: AppColors.white),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 12 : 16),
                  headerComponent,
                ],
              ),
            ),
            SizedBox(height: bottomPadding),

            // White container that takes remaining space
            Expanded(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(isSmallScreen ? 20 : 24),
                      child: content,
                    ),
                  ),
                  Positioned(
                    bottom: 40,
                    left: 0,
                    right: 0,
                    child: Center(child: nextButton),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _getResponsiveTitleFontSize(Size screenSize) {
    if (screenSize.width > 600) return 28;
    if (screenSize.width > 400) return 24;
    if (screenSize.width > 350) return 22;
    return 20;
  }

  static double _getResponsiveSubtitleFontSize(Size screenSize) {
    if (screenSize.width > 600) return 18;
    if (screenSize.width > 400) return 16;
    if (screenSize.width > 350) return 15;
    return 14;
  }
}
