// lib/reciver/auth/widgets/custom_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../utils/colors.dart';
import '../../utils/app_font.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isEnabled;
  final bool isLoading;
  final String text;
  final bool showArrow;

  const CustomButton({
    Key? key,
    this.onPressed,
    this.isEnabled = true,
    this.isLoading = false,
    required this.text,
    this.showArrow = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: (isEnabled && !isLoading) ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          disabledBackgroundColor: AppColors.primary.withOpacity(0.3),
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(48),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    text,
                    style: AppFonts.mdBold(context, color: AppColors.white),
                  ),
                  if (showArrow) ...[
                    const SizedBox(width: 8),
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
                ],
              ),
      ),
    );
  }
}
