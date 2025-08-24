// lib/reciver/auth/widgets/custom_list_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tipme_app/utils/app_font.dart';
import 'package:tipme_app/utils/colors.dart';

enum CardBorderType {
  none,
  bottom,
  all,
}

enum TrailingType {
  arrow,
  radio,
  none,
}

class CustomListCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? iconPath;
  final VoidCallback? onTap;
  final CardBorderType borderType;
  final Color? borderColor;
  final double borderWidth;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final Color? backgroundColor;
  final TrailingType trailingType;
  final bool? isSelected;
  final Color? iconColor;
  final double? iconSize;
  final Widget? customIcon;
  final Widget? customTrailing;
  final Color? iconBackgroundColor;

  const CustomListCard({
    Key? key,
    required this.title,
    this.subtitle,
    this.iconPath,
    this.onTap,
    this.borderType = CardBorderType.bottom,
    this.borderColor,
    this.borderWidth = 1.0,
    this.borderRadius = 0.0,
    this.padding,
    this.titleStyle,
    this.subtitleStyle,
    this.backgroundColor,
    this.trailingType = TrailingType.arrow,
    this.isSelected,
    this.iconColor,
    this.iconSize,
    this.customIcon,
    this.customTrailing,
    this.iconBackgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.transparent,
          borderRadius: BorderRadius.circular(borderRadius),
          border: _getBorder(),
        ),
        child: Padding(
          padding: padding ??
              const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16.0,
              ),
          child: Row(
            children: [
              if (iconPath != null || customIcon != null) ...[
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: iconBackgroundColor ??
                        AppColors.secondary_500.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: customIcon ??
                        SvgPicture.asset(
                          iconPath!,
                          width: iconSize ?? 24,
                          height: iconSize ?? 24,
                          colorFilter: iconColor != null
                              ? ColorFilter.mode(iconColor!, BlendMode.srcIn)
                              : null,
                        ),
                  ),
                ),
                const SizedBox(width: 16),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: titleStyle ??
                          AppFonts.mdSemiBold(
                            context,
                            color: AppColors.black,
                          ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle!,
                        style: subtitleStyle ??
                            AppFonts.xsMedium(
                              context,
                              color: AppColors.text,
                            ),
                      ),
                    ],
                  ],
                ),
              ),
              if (customTrailing != null) customTrailing! else _buildTrailing(),
            ],
          ),
        ),
      ),
    );
  }

  Border? _getBorder() {
    if (borderType == CardBorderType.none) return null;

    final BorderSide borderSide = BorderSide(
      color: borderColor ?? AppColors.border_2,
      width: borderWidth,
    );

    switch (borderType) {
      case CardBorderType.bottom:
        return Border(bottom: borderSide);
      case CardBorderType.all:
        return Border.all(
          color: borderColor ?? AppColors.border_2,
          width: borderWidth,
        );
      case CardBorderType.none:
        return null;
    }
  }

  Widget _buildTrailing() {
    switch (trailingType) {
      case TrailingType.arrow:
        return const Icon(
          Icons.chevron_right,
          color: AppColors.black,
          size: 28,
        );
      case TrailingType.radio:
        return Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color:
                  isSelected == true ? AppColors.primary : AppColors.border_2!,
              width: 2,
            ),
            color: isSelected == true ? AppColors.primary : Colors.transparent,
          ),
          child: isSelected == true
              ? const Icon(
                  Icons.check,
                  color: AppColors.white,
                  size: 16,
                )
              : null,
        );
      case TrailingType.none:
        return const SizedBox.shrink();
    }
  }
}
