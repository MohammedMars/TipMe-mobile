//lib\auth\widgets\custom_checkbox.dart
import 'package:flutter/material.dart';
import 'package:tipme_app/utils/app_font.dart';
import '../../utils/colors.dart';

class CustomCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String text;
  final String? linkText;
  final VoidCallback? onLinkTap;

  const CustomCheckbox({
    Key? key,
    required this.value,
    required this.onChanged,
    required this.text,
    this.linkText,
    this.onLinkTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 20,
              height: 20,
              margin: const EdgeInsets.only(right: 12, top: 2),
              decoration: BoxDecoration(
                color: value ? AppColors.primary : Colors.transparent,
                border: Border.all(
                  color: value ? AppColors.primary : AppColors.border_2,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: value
                  ? const Icon(
                      Icons.check,
                      color: AppColors.white,
                      size: 14,
                    )
                  : null,
            ),
            Expanded(
              child: _buildTextContent(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextContent(BuildContext context) {
    if (linkText != null) {
      return GestureDetector(
        onTap: onLinkTap,
        child: RichText(
          text: TextSpan(
            style: AppFonts.mdMedium(context, color: AppColors.text),
            children: [
              TextSpan(text: text),
              TextSpan(
                text: linkText,
                style: AppFonts.mdMedium(context, color: AppColors.primary),
              ),
            ],
          ),
        ),
      );
    }

    return Text(
      text,
      style: AppFonts.mdMedium(context, color: AppColors.text),
    );
  }
}
