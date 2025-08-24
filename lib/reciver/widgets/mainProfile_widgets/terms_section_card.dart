// lib/reciver/auth/widgets/terms_widgets/terms_section_card.dart
import 'package:flutter/material.dart';
import 'package:tipme_app/utils/app_font.dart';
import 'package:tipme_app/utils/colors.dart';

class TermsSectionCard extends StatelessWidget {
  final String title;
  final String description;
  final bool isNumbered;
  final int? number;

  const TermsSectionCard({
    Key? key,
    required this.title,
    required this.description,
    this.isNumbered = true,
    this.number,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isNumbered && number != null ? '$number. $title' : title,
            style: AppFonts.mdBold(context, color: AppColors.black),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: AppFonts.smMedium(
              context,
              color: AppColors.text,
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}
