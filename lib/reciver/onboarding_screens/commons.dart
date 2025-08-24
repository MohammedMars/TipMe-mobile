import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tipme_app/utils/app_font.dart';
import 'package:tipme_app/utils/colors.dart';

class CreateAccountButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color backgroundColor;
  final bool isMobile;

  const CreateAccountButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.backgroundColor = AppColors.primary,
    this.isMobile = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttonWidth = isMobile ? 205.0 : 250.0;
    final buttonHeight = isMobile ? 50.0 : 56.0;
    final spacing = isMobile ? 10.0 : 12.0;

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        minimumSize: Size(buttonWidth, buttonHeight),
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16 : 24,
          vertical: 16,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: AppFonts.mdBold(context, color: AppColors.white),
          ),
          SizedBox(width: spacing),
          SvgPicture.asset(
            'assets/icons/arrow-right.svg',
            width: 20,
            height: 20,
            colorFilter: const ColorFilter.mode(
              AppColors.white,
              BlendMode.srcIn,
            ),
          ),
        ],
      ),
    );
  }
}
