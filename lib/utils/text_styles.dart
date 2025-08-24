//lib/utils/app_text_styles.dart
import 'package:flutter/material.dart';
import 'package:tipme_app/utils/app_font.dart';
import 'colors.dart';

class AppTextStyles {
  // Body Text Styles with proper line heights
  static TextStyle bodyLarge(BuildContext context, {Color? color}) =>
      AppFonts.mdMedium(context, color: color ?? AppColors.black)
          .copyWith(height: 1.5);

  static TextStyle bodyMedium(BuildContext context, {Color? color}) =>
      AppFonts.smMedium(context, color: color ?? AppColors.black)
          .copyWith(height: 1.4);

  static TextStyle bodySmall(BuildContext context, {Color? color}) =>
      AppFonts.xsMedium(context, color: color ?? AppColors.black)
          .copyWith(height: 1.3);

  // Button Styles
  static TextStyle button(BuildContext context, {Color? color}) =>
      AppFonts.mdSemiBold(context, color: color ?? Colors.white)
          .copyWith(letterSpacing: 0.5);

  static TextStyle buttonSecondary(BuildContext context, {Color? color}) =>
      AppFonts.mdSemiBold(context, color: color ?? AppColors.primary)
          .copyWith(letterSpacing: 0.5);

  static TextStyle buttonSmall(BuildContext context, {Color? color}) =>
      AppFonts.smSemiBold(context, color: color ?? Colors.white)
          .copyWith(letterSpacing: 0.4);

  // Input Styles
  static TextStyle inputText(BuildContext context, {Color? color}) =>
      AppFonts.mdMedium(context, color: color ?? AppColors.black);

  static TextStyle inputLabel(BuildContext context, {Color? color}) =>
      AppFonts.smSemiBold(context, color: color ?? AppColors.black);

  static TextStyle inputPlaceholder(BuildContext context, {Color? color}) =>
      AppFonts.mdRegular(context,
          color: color ?? AppColors.text.withOpacity(0.6));

  // Hint and Help Text
  static TextStyle hint(BuildContext context, {Color? color}) =>
      AppFonts.smLight(context,
          color: color ?? AppColors.text.withOpacity(0.7));

  static TextStyle hintSmall(BuildContext context, {Color? color}) =>
      AppFonts.xsLight(context, color: color ?? AppColors.text.withOpacity(0.7))
          .copyWith(height: 1.3);

  // Caption Styles
  static TextStyle caption(BuildContext context, {Color? color}) =>
      AppFonts.xsMedium(context, color: color ?? AppColors.text);

  static TextStyle captionLight(BuildContext context, {Color? color}) =>
      AppFonts.xsLight(context, color: color ?? AppColors.text);

  static TextStyle captionSmall(BuildContext context, {Color? color}) =>
      AppFonts.xxsMedium(context, color: color ?? AppColors.text);

  // Link Styles
  static TextStyle link(BuildContext context, {Color? color}) =>
      AppFonts.smSemiBold(context, color: color ?? AppColors.primary);

  static TextStyle linkSmall(BuildContext context, {Color? color}) =>
      AppFonts.xsSemiBold(context, color: color ?? AppColors.primary);

  static TextStyle linkLarge(BuildContext context, {Color? color}) =>
      AppFonts.mdSemiBold(context, color: color ?? AppColors.primary);

  // Status Text Styles
  static TextStyle error(BuildContext context, {Color? color}) =>
      AppFonts.xsMedium(context, color: color ?? Colors.red);

  static TextStyle success(BuildContext context, {Color? color}) =>
      AppFonts.xsMedium(context, color: color ?? Colors.green);

  static TextStyle warning(BuildContext context, {Color? color}) =>
      AppFonts.xsMedium(context, color: color ?? Colors.orange);

  static TextStyle info(BuildContext context, {Color? color}) =>
      AppFonts.xsMedium(context, color: color ?? Colors.blue);

  // Navigation Styles
  static TextStyle tabActive(BuildContext context, {Color? color}) =>
      AppFonts.smSemiBold(context, color: color ?? AppColors.primary);

  static TextStyle tabInactive(BuildContext context, {Color? color}) =>
      AppFonts.smRegular(context,
          color: color ?? AppColors.text.withOpacity(0.6));

  static TextStyle navigationTitle(BuildContext context, {Color? color}) =>
      AppFonts.lgSemiBold(context, color: color ?? AppColors.black);

  // Card and List Styles
  static TextStyle cardTitle(BuildContext context, {Color? color}) =>
      AppFonts.mdSemiBold(context, color: color ?? AppColors.black);

  static TextStyle cardSubtitle(BuildContext context, {Color? color}) =>
      AppFonts.smRegular(context, color: color ?? AppColors.text);

  static TextStyle listTitle(BuildContext context, {Color? color}) =>
      AppFonts.mdMedium(context, color: color ?? AppColors.black);

  static TextStyle listSubtitle(BuildContext context, {Color? color}) =>
      AppFonts.smRegular(context, color: color ?? AppColors.text);

  // Special Styles for Welcome Screen
  static TextStyle welcomeTitle(BuildContext context, {Color? color}) =>
      AppFonts.h3(context, color: color ?? AppColors.black);

  static TextStyle welcomeSubtitle(BuildContext context, {Color? color}) =>
      AppFonts.mdRegular(context, color: color ?? AppColors.text);

  static TextStyle stepTitle(BuildContext context, {Color? color}) =>
      AppFonts.lgSemiBold(context, color: color ?? AppColors.black);

  static TextStyle stepDescription(BuildContext context, {Color? color}) =>
      AppFonts.mdRegular(context, color: color ?? AppColors.text);

  // Language Toggle Styles
  static TextStyle languageToggleActive(BuildContext context, {Color? color}) =>
      AppFonts.smSemiBold(context, color: color ?? AppColors.white);

  static TextStyle languageToggleInactive(BuildContext context,
          {Color? color}) =>
      AppFonts.smSemiBold(context, color: color ?? AppColors.text);
}
