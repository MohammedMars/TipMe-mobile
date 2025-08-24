//lib\auth\widgets\custom_app_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tipme_app/utils/app_font.dart';
import '../../../utils/colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int step;
  final int totalSteps;

  const CustomAppBar({
    Key? key,
    required this.step,
    required this.totalSteps,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight + 44),
      child: Container(
        color: AppColors.secondary,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: SvgPicture.asset(
                'assets/icons/arrow-left.svg',
                width: 20,
                height: 20,
                colorFilter: const ColorFilter.mode(
                  AppColors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
            const Spacer(),
            Text('$step/$totalSteps',
                style: AppFonts.mdSemiBold(context, color: AppColors.white)),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 44);
}
