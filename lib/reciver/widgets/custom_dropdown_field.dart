//lib\reciver\auth\widgets\custom_dropdown_field.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tipme_app/utils/app_font.dart';
import '../../utils/colors.dart';

class CustomDropdownField extends StatelessWidget {
  final String hintText;
  final String? value;
  final List<DropdownMenuItem<String>> items;
  final void Function(String?)? onChanged;
  final String? Function(String?)? validator;

  const CustomDropdownField({
    Key? key,
    required this.hintText,
    this.value,
    required this.items,
    this.onChanged,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.gray_bg_2,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.border_2,
          width: 1,
        ),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        onChanged: onChanged,
        validator: validator,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: AppFonts.mdMedium(context, color: AppColors.text),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          border: InputBorder.none,
        ),
        icon: SvgPicture.asset(
          'assets/icons/chevron-down.svg',
          width: 24,
          height: 24,
          color: AppColors.text,
        ),
        dropdownColor: Colors.white,
        style: AppFonts.mdMedium(context, color: AppColors.black),
        items: items,
      ),
    );
  }
}
