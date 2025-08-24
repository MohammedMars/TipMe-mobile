//lib/utils/app_fonts.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/services/language_service.dart';

class AppFonts {
  static const String _englishFontFamily = 'Quicksand';
  static const String _arabicFontFamily = 'Tajawal';

  static TextStyle _createStyle(
    BuildContext? context, {
    required double fontSize,
    required FontWeight fontWeight,
    Color color = Colors.black,
    double? letterSpacing,
    double? height,
    TextDecoration decoration = TextDecoration.none,
    String? forceFamily,
  }) {
    String fontFamily = forceFamily ?? _englishFontFamily;

    if (context != null && forceFamily == null) {
      final languageService =
          Provider.of<LanguageService>(context, listen: false);
      fontFamily = languageService.currentLanguage == 'ar'
          ? _arabicFontFamily
          : _englishFontFamily;
    }

    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
      decoration: decoration,
    );
  }

  static TextStyle xlLight(BuildContext? context, {Color? color}) =>
      _createStyle(
        context,
        fontSize: 20,
        fontWeight: FontWeight.w300,
        color: color ?? Colors.black,
      );

  static TextStyle xlRegular(BuildContext? context, {Color? color}) =>
      _createStyle(
        context,
        fontSize: 20,
        fontWeight: FontWeight.w400,
        color: color ?? Colors.black,
      );

  static TextStyle xlMedium(BuildContext? context, {Color? color}) =>
      _createStyle(
        context,
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: color ?? Colors.black,
      );

  static TextStyle xlSemiBold(BuildContext? context, {Color? color}) =>
      _createStyle(
        context,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: color ?? Colors.black,
      );

  static TextStyle xlBold(BuildContext? context, {Color? color}) =>
      _createStyle(
        context,
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: color ?? Colors.black,
      );

  static TextStyle lgLight(BuildContext? context, {Color? color}) =>
      _createStyle(
        context,
        fontSize: 18,
        fontWeight: FontWeight.w300,
        color: color ?? Colors.black,
      );

  static TextStyle lgRegular(BuildContext? context, {Color? color}) =>
      _createStyle(
        context,
        fontSize: 18,
        fontWeight: FontWeight.w400,
        color: color ?? Colors.black,
      );

  static TextStyle lgMedium(BuildContext? context, {Color? color}) =>
      _createStyle(
        context,
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: color ?? Colors.black,
      );

  static TextStyle lgSemiBold(BuildContext? context, {Color? color}) =>
      _createStyle(
        context,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: color ?? Colors.black,
      );

  static TextStyle lgBold(BuildContext? context, {Color? color}) =>
      _createStyle(
        context,
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: color ?? Colors.black,
      );

  static TextStyle mdLight(BuildContext? context, {Color? color}) =>
      _createStyle(
        context,
        fontSize: 16,
        fontWeight: FontWeight.w300,
        color: color ?? Colors.black,
      );

  static TextStyle mdRegular(BuildContext? context, {Color? color}) =>
      _createStyle(
        context,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: color ?? Colors.black,
      );

  static TextStyle mdMedium(BuildContext? context, {Color? color}) =>
      _createStyle(
        context,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: color ?? Colors.black,
      );

  static TextStyle mdSemiBold(BuildContext? context, {Color? color}) =>
      _createStyle(
        context,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: color ?? Colors.black,
      );

  static TextStyle mdBold(BuildContext? context, {Color? color}) =>
      _createStyle(
        context,
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: color ?? Colors.black,
      );

  static TextStyle smLight(BuildContext? context, {Color? color}) =>
      _createStyle(
        context,
        fontSize: 14,
        fontWeight: FontWeight.w300,
        color: color ?? Colors.black,
      );

  static TextStyle smRegular(BuildContext? context, {Color? color}) =>
      _createStyle(
        context,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: color ?? Colors.black,
      );

  static TextStyle smMedium(BuildContext? context, {Color? color}) =>
      _createStyle(
        context,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: color ?? Colors.black,
      );

  static TextStyle smSemiBold(BuildContext? context, {Color? color}) =>
      _createStyle(
        context,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: color ?? Colors.black,
      );

  static TextStyle smBold(BuildContext? context, {Color? color}) =>
      _createStyle(
        context,
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: color ?? Colors.black,
      );

  static TextStyle xsLight(BuildContext? context, {Color? color}) =>
      _createStyle(
        context,
        fontSize: 12,
        fontWeight: FontWeight.w300,
        color: color ?? Colors.black,
      );

  static TextStyle xsRegular(BuildContext? context, {Color? color}) =>
      _createStyle(
        context,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: color ?? Colors.black,
      );

  static TextStyle xsMedium(BuildContext? context, {Color? color}) =>
      _createStyle(
        context,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: color ?? Colors.black,
      );

  static TextStyle xsSemiBold(BuildContext? context, {Color? color}) =>
      _createStyle(
        context,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: color ?? Colors.black,
      );

  static TextStyle xsBold(BuildContext? context, {Color? color}) =>
      _createStyle(
        context,
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: color ?? Colors.black,
      );

  static TextStyle xxsLight(BuildContext? context, {Color? color}) =>
      _createStyle(
        context,
        fontSize: 10,
        fontWeight: FontWeight.w300,
        color: color ?? Colors.black,
      );

  static TextStyle xxsRegular(BuildContext? context, {Color? color}) =>
      _createStyle(
        context,
        fontSize: 10,
        fontWeight: FontWeight.w400,
        color: color ?? Colors.black,
      );

  static TextStyle xxsMedium(BuildContext? context, {Color? color}) =>
      _createStyle(
        context,
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: color ?? Colors.black,
      );

  static TextStyle xxsSemiBold(BuildContext? context, {Color? color}) =>
      _createStyle(
        context,
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: color ?? Colors.black,
      );

  static TextStyle xxsBold(BuildContext? context, {Color? color}) =>
      _createStyle(
        context,
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: color ?? Colors.black,
      );

  static TextStyle h1(BuildContext? context, {Color? color}) => _createStyle(
        context,
        fontSize: 38,
        fontWeight: FontWeight.w700,
        color: color ?? Colors.black,
      );

  static TextStyle h2(BuildContext? context, {Color? color}) => _createStyle(
        context,
        fontSize: 30,
        fontWeight: FontWeight.w700,
        color: color ?? Colors.black,
      );

  static TextStyle h3(BuildContext? context, {Color? color}) => _createStyle(
        context,
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: color ?? Colors.black,
      );

  static TextStyle h4(BuildContext? context, {Color? color}) => _createStyle(
        context,
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: color ?? Colors.black,
      );

  static TextStyle h5(BuildContext? context, {Color? color}) => _createStyle(
        context,
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: color ?? Colors.black,
      );

  static TextStyle h6(BuildContext? context, {Color? color}) => _createStyle(
        context,
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: color ?? Colors.black,
      );

  static TextStyle forceEnglish({
    required double fontSize,
    required FontWeight fontWeight,
    Color? color,
  }) =>
      _createStyle(
        null,
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color ?? Colors.black,
        forceFamily: _englishFontFamily,
      );

  static TextStyle forceArabic({
    required double fontSize,
    required FontWeight fontWeight,
    Color? color,
  }) =>
      _createStyle(
        null,
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color ?? Colors.black,
        forceFamily: _arabicFontFamily,
      );
}
