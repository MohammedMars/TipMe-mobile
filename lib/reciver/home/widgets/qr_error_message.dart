import 'package:flutter/material.dart';

class QRErrorMessage extends StatelessWidget {
  final String errorMessage;

  const QRErrorMessage({super.key, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE5E5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 16),
          const SizedBox(width: 8),
          Flexible(
            child: Text(errorMessage, textAlign: TextAlign.center),
          ),
        ],
      ),
    );
  }
}