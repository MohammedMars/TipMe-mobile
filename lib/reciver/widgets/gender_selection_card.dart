//lib\reciver\auth\widgets\gender_selection_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tipme_app/utils/app_font.dart';
import 'package:tipme_app/utils/colors.dart';

class GenderSelectionCard extends StatelessWidget {
  final String? genderKey;
  final String gender;
  final bool isSelected;
  final VoidCallback onTap;
  final String svgPath;

  const GenderSelectionCard({
    Key? key,
    this.genderKey,
    required this.gender,
    required this.isSelected,
    required this.onTap,
    required this.svgPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.height < 700;

    // Use genderKey if provided, otherwise fall back to gender text for backward compatibility
    final isMaleCard = (genderKey?.toLowerCase() == 'male') ||
        (genderKey == null && gender.toLowerCase() == 'male');

    final Color backgroundColor =
        isMaleCard ? AppColors.secondary : AppColors.white;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: isSmallScreen ? 200 : 240,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(gender,
                        style: AppFonts.mdSemiBold(context,
                            color: isMaleCard
                                ? AppColors.white
                                : AppColors.black)),
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: !isSelected
                            ? Border.all(color: Colors.black, width: 2)
                            : null,
                      ),
                      child: isSelected
                          ? SvgPicture.asset(
                              'assets/icons/circle-check.svg',
                              color: AppColors.primary,
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 72,
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                alignment: Alignment.bottomCenter,
                child: SvgPicture.asset(
                  svgPath,
                  fit: BoxFit.fitHeight,
                  alignment: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
