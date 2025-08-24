// lib/auth/widgets/profile_widgets/action_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../utils/colors.dart';
import '../../../utils/app_font.dart';

class ActionButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback? onPressed;
  final double? width;
  final double height;
  final String? svgIcon;

  const ActionButton({
    Key? key,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    this.onPressed,
    this.width,
    this.height = 36,
    this.svgIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          elevation: 0,
          shadowColor: Colors.transparent,
          side: BorderSide(
            color: textColor.withOpacity(0.3),
            width: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (svgIcon != null) ...[
              SvgPicture.asset(
                svgIcon!,
                width: 14,
                height: 14,
                colorFilter: ColorFilter.mode(
                  textColor,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 4),
            ],
            Text(
              text,
              style: AppFonts.smSemiBold(context, color: textColor),
            ),
          ],
        ),
      ),
    );
  }
}
