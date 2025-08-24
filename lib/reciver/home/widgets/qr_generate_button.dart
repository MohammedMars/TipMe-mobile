import 'package:flutter/material.dart';
import 'package:tipme_app/utils/colors.dart';

class QRGenerateButton extends StatelessWidget {
  final bool isGenerating;
  final bool isFirstGeneration;
  final VoidCallback onPressed;

  const QRGenerateButton({
    super.key,
    required this.isGenerating,
    required this.isFirstGeneration,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 219,
      height: 50,
      child: ElevatedButton(
        onPressed: isGenerating ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: AppColors.secondary),
          ),
          elevation: 0,
        ),
        child: Text(
          isFirstGeneration ? 'Generate QR Code' : 'Re-Generate QR Code',
        ),
      ),
    );
  }
}