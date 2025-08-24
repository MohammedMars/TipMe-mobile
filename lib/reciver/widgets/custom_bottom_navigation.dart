//lib\reciver\auth\widgets\custom_bottom_navigation.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tipme_app/data/services/language_service.dart';
import 'package:tipme_app/utils/app_font.dart';
import 'package:tipme_app/utils/colors.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languageService = Provider.of<LanguageService>(context);

    return Container(
      height: 75 + MediaQuery.of(context).padding.bottom + 16,
      decoration: const BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x0A000000),
            offset: Offset(0, -10),
            blurRadius: 15,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Container(
        height: 75,
        padding: const EdgeInsets.symmetric(horizontal: 36),
        margin:
            EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildNavItem(
              context: context,
              index: 0,
              iconPath: 'assets/icons/home.svg',
              label: languageService.getText('home'),
              isActive: currentIndex == 0,
            ),
            _buildNavItem(
              context: context,
              index: 1,
              iconPath: 'assets/icons/wallet.svg',
              label: languageService.getText('wallet'),
              isActive: currentIndex == 1,
            ),
            _buildNavItem(
              context: context,
              index: 2,
              iconPath: 'assets/icons/arrows-exchange.svg',
              label: languageService.getText('transactions'),
              isActive: currentIndex == 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required int index,
    required String iconPath,
    required String label,
    required bool isActive,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        child: Container(
          height: 75,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                iconPath,
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  isActive ? AppColors.primary : const Color(0xFFADB5BD),
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                label,
                style: AppFonts.xsSemiBold(
                  context,
                  color: isActive ? AppColors.primary : const Color(0xFFADB5BD),
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
