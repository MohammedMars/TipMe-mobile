//lib/reciver/auth/widgets/transaction_widgets/custom_switch_widget.dart
import 'package:flutter/material.dart';
import 'package:tipme_app/utils/app_font.dart';
import 'package:tipme_app/utils/colors.dart';

class CustomSwitchWidget extends StatelessWidget {
  final String leftText;
  final String rightText;
  final bool isLeftSelected;
  final Function(bool) onToggle;

  const CustomSwitchWidget({
    Key? key,
    required this.leftText,
    required this.rightText,
    required this.isLeftSelected,
    required this.onToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(96),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => onToggle(true),
              child: Container(
                height: 34,
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color:
                      isLeftSelected ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Center(
                  child: Text(
                    leftText,
                    style: AppFonts.smSemiBold(
                      context,
                      color: isLeftSelected ? AppColors.white : AppColors.text,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => onToggle(false),
              child: Container(
                height: 34,
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color:
                      !isLeftSelected ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Center(
                  child: Text(
                    rightText,
                    style: AppFonts.smSemiBold(
                      context,
                      color: !isLeftSelected ? AppColors.white : AppColors.text,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
