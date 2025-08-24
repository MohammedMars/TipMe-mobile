import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tipme_app/utils/app_font.dart';
import '../../../routs/app_routs.dart';
import '../../../utils/colors.dart';
import '../../../data/services/language_service.dart';
import '../../widgets/custom_button.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  void _onCompleteProfile(BuildContext context) {
    // Create UserDataObject 
    Navigator.of(context).pushNamed(AppRoutes.chooseGender);
  }

  @override
  Widget build(BuildContext context) {
    final languageService = Provider.of<LanguageService>(context);
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;
    final isSmallScreen = screenSize.height < 700;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
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
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/circle-check.svg',
                        width: 76,
                        height: 76,
                        colorFilter: ColorFilter.mode(
                          AppColors.primary,
                          BlendMode.srcIn,
                        ),
                      ),
                      SizedBox(height: 24),
                      Text(
                        languageService.getText('welcomeToTipMe'),
                        style: AppFonts.h3(context, color: AppColors.white),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: isTablet ? 400 : screenSize.width - 48,
                        ),
                        child: Text(
                          languageService.getText('welcomeAccountSetMessage'),
                          style: AppFonts.mdMedium(context,
                              color: AppColors.white.withOpacity(0.9)),
                          textAlign: TextAlign.center,
                          maxLines: 3,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: isTablet ? 400 : double.infinity,
                  margin: EdgeInsets.only(
                    bottom: isSmallScreen ? 20 : 40,
                  ),
                  child: CustomButton(
                    text: languageService.getText('completeYourProfile'),
                    onPressed: () => _onCompleteProfile(context),
                    isEnabled: true,
                    showArrow: true,
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
    return 14;
  }
}
