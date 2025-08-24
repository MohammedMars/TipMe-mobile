import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:tipme_app/utils/colors.dart';

class QRContent extends StatelessWidget {
  final bool isGenerating;
  final Uint8List? qrImageBytes;
  final String? qrDataUri;
  final String? errorMessage;

  const QRContent({
    super.key,
    required this.isGenerating,
    this.qrImageBytes,
    this.qrDataUri,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: _buildQRContent(),
          ),
          ..._buildCornerDecorations(),
        ],
      ),
    );
  }

  Widget _buildQRContent() {
    if (isGenerating) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)),
      );
      
    }

    if (qrImageBytes != null && errorMessage == null) {
      return _buildImageWithFallback();
    }

    return const Center(
      child: Icon(Icons.qr_code, size: 60, color: AppColors.text),
    );
  }

  Widget _buildImageWithFallback() {
    return Image.memory(
      qrImageBytes!,
      fit: BoxFit.contain,
      gaplessPlayback: true,
      errorBuilder: (context, error, stackTrace) {
        return qrDataUri != null 
            ? Image.network(qrDataUri!, fit: BoxFit.contain)
            : _failedWidget(error);
      },
    );
  }

  Widget _failedWidget(Object error) {
    return Center(
      child: Text('Failed to render image:\n$error', textAlign: TextAlign.center),
    );
  }

  List<Widget> _buildCornerDecorations() {
    return [
      Positioned(top: 0, left: 0, child: _buildCornerPiece(top: true, left: true)),
      Positioned(top: 0, right: 0, child: _buildCornerPiece(top: true, right: true)),
      Positioned(bottom: 0, left: 0, child: _buildCornerPiece(bottom: true, left: true)),
      Positioned(bottom: 0, right: 0, child: _buildCornerPiece(bottom: true, right: true)),
    ];
  }

  Widget _buildCornerPiece({bool top = false, bool left = false, bool bottom = false, bool right = false}) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        border: Border(
          top: top ? const BorderSide(color: AppColors.primary, width: 4) : BorderSide.none,
          left: left ? const BorderSide(color: AppColors.primary, width: 4) : BorderSide.none,
          bottom: bottom ? const BorderSide(color: AppColors.primary, width: 4) : BorderSide.none,
          right: right ? const BorderSide(color: AppColors.primary, width: 4) : BorderSide.none,
        ),
        borderRadius: BorderRadius.only(
          topLeft: top && left ? const Radius.circular(12) : Radius.zero,
          topRight: top && right ? const Radius.circular(12) : Radius.zero,
          bottomLeft: bottom && left ? const Radius.circular(12) : Radius.zero,
          bottomRight: bottom && right ? const Radius.circular(12) : Radius.zero,
        ),
      ),
    );
  }
}