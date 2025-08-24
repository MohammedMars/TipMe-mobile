//lib\reciver\auth\widgets\selectable_item_card.dart
import 'package:flutter/material.dart';
import 'package:tipme_app/utils/app_font.dart';
import '../../utils/colors.dart';

enum CardStyle {
  country,
  bank,
}

class SelectableItemCard extends StatelessWidget {
  final String title;
  final String? iconPath;
  final bool isSelected;
  final VoidCallback onTap;
  final bool showBottomBorder;
  final CardStyle cardStyle;

  const SelectableItemCard({
    Key? key,
    required this.title,
    this.iconPath,
    required this.isSelected,
    required this.onTap,
    this.showBottomBorder = false,
    this.cardStyle = CardStyle.bank,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: cardStyle == CardStyle.country
          ? const EdgeInsets.only(bottom: 16)
          : EdgeInsets.zero,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: _getDecoration(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              if (iconPath != null)
                Container(
                  width: 48,
                  height: cardStyle == CardStyle.country ? 32 : 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: cardStyle == CardStyle.bank
                        ? Border.all(
                            color: AppColors.border_2,
                            width: 1,
                          )
                        : null,
                  ),
                  child: cardStyle == CardStyle.country
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.asset(
                            iconPath!,
                            width: 48,
                            height: 32,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            iconPath!,
                            fit: BoxFit.contain,
                          ),
                        ),
                )
              else
                Container(
                  width: 48,
                  height: cardStyle == CardStyle.country ? 32 : 48,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                    border: cardStyle == CardStyle.bank
                        ? Border.all(
                            color: AppColors.border_2,
                            width: 1,
                          )
                        : null,
                  ),
                ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: isSelected
                      ? AppFonts.mdBold(context, color: AppColors.primary)
                      : AppFonts.mdSemiBold(context, color: AppColors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _getDecoration() {
    switch (cardStyle) {
      case CardStyle.country:
        return BoxDecoration(
          color: AppColors.gray_bg_2,
          border: Border.all(
            color: AppColors.border_2,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(16),
        );

      case CardStyle.bank:
        return BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.1)
              : Colors.transparent,
          border: showBottomBorder
              ? const Border(
                  bottom: BorderSide(
                    color: AppColors.border_2,
                    width: 1,
                  ),
                )
              : null,
        );
    }
  }
}
