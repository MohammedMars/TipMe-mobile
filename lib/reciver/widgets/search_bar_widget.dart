//lib/auth/widgets/search_bar_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tipme_app/utils/app_font.dart';
import '../../utils/colors.dart';
import '../../data/services/language_service.dart';

class SearchBarWidget extends StatelessWidget {
  final String? hintTextKey;
  final String? hintText;
  final Function(String)? onChanged;
  final TextEditingController? controller;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? hintTextColor;
  final Color? iconColor;
  final String? prefixIconPath;
  final bool showFilterIcon;

  const SearchBarWidget({
    Key? key,
    this.hintTextKey,
    this.hintText,
    this.onChanged,
    this.controller,
    this.backgroundColor,
    this.textColor,
    this.hintTextColor,
    this.iconColor,
    this.prefixIconPath,
    this.showFilterIcon = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languageService = Provider.of<LanguageService>(context);

    final displayHintText = hintTextKey != null
        ? languageService.getText(hintTextKey!)
        : hintText ?? '';

    final defaultBackgroundColor =
        backgroundColor ?? AppColors.white.withOpacity(0.10);
    final defaultTextColor = textColor ?? AppColors.white;
    final defaultHintTextColor = hintTextColor ?? AppColors.white;
    final defaultIconColor = iconColor ?? AppColors.white.withOpacity(0.7);
    final defaultIconPath = prefixIconPath ?? 'assets/icons/search.svg';

    return Container(
      decoration: BoxDecoration(
        color: defaultBackgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: AppFonts.mdMedium(context, color: defaultTextColor),
              decoration: InputDecoration(
                hintText: displayHintText,
                hintStyle:
                    AppFonts.mdMedium(context, color: defaultHintTextColor),
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SvgPicture.asset(
                    defaultIconPath,
                    width: 20,
                    height: 20,
                    colorFilter: ColorFilter.mode(
                      defaultIconColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
          if (showFilterIcon) ...[
            const SizedBox(width: 8),
            Container(
              height: 32,
              width: 32,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/icons/adjustments.svg',
                  width: 20,
                  height: 20,
                  colorFilter: ColorFilter.mode(
                    defaultIconColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
