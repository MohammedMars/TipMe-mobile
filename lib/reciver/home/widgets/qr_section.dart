import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:tipme_app/utils/colors.dart';
import 'qr_content.dart';
import 'qr_generate_button.dart';
import 'qr_error_message.dart';

class QRSection extends StatelessWidget {
  final bool isGenerating;
  final Uint8List? qrImageBytes;
  final String? qrDataUri;
  final String? errorMessage;
  final bool isFirstGeneration;
  final VoidCallback onGeneratePressed;

  const QRSection({
    super.key,
    required this.isGenerating,
    this.qrImageBytes,
    this.qrDataUri,
    this.errorMessage,
    required this.isFirstGeneration,
    required this.onGeneratePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 354,
      height: 336,
      child: Card(
        elevation: 8,
        color: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              QRContent(
                isGenerating: isGenerating,
                qrImageBytes: qrImageBytes,
                qrDataUri: qrDataUri,
                errorMessage: errorMessage,
              ),
              const SizedBox(height: 24),
              QRGenerateButton(
                isGenerating: isGenerating,
                isFirstGeneration: isFirstGeneration,
                onPressed: onGeneratePressed,
              ),
              if (errorMessage != null) ...[
                const SizedBox(height: 16),
                QRErrorMessage(errorMessage: errorMessage!),
              ],
            ],
          ),
        ),
      ),
    );
  }
}