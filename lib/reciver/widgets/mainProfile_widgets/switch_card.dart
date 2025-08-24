// lib/reciver/auth/widgets/switch_card.dart
import 'package:flutter/material.dart';
import 'package:tipme_app/reciver/widgets/mainProfile_widgets/custom_switch.dart';
import 'package:tipme_app/utils/app_font.dart';
import 'package:tipme_app/utils/colors.dart';

class SwitchCard extends StatelessWidget {
  final String text;
  final bool value;
  final ValueChanged<bool> onChanged;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;
  final Color? borderColor;
  final double? borderWidth;

  const SwitchCard({
    Key? key,
    required this.text,
    required this.value,
    required this.onChanged,
    this.textStyle,
    this.padding,
    this.borderColor,
    this.borderWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: borderColor ?? AppColors.border_2,
            width: borderWidth ?? 1.0,
          ),
        ),
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                text,
                style: textStyle ??
                    AppFonts.mdMedium(context, color: AppColors.black),
              ),
            ),
            CustomSwitch(
              value: value,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}
