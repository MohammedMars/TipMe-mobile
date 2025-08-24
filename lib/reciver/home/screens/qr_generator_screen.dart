import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tipme_app/core/dio/client/dio_client.dart';
import 'package:tipme_app/di/gitIt.dart';
import 'package:tipme_app/reciver/home/widgets/qr_section.dart';
import 'package:tipme_app/reciver/home/widgets/qr_title_section.dart';
import 'package:tipme_app/reciver/home/widgets/qr_utils.dart';
import 'package:tipme_app/reciver/widgets/custom_button.dart';
import 'package:tipme_app/routs/app_routs.dart';
import 'package:tipme_app/data/services/language_service.dart';
import 'package:tipme_app/services/qrCodeService.dart';
import 'package:tipme_app/utils/colors.dart';
import 'package:tipme_app/dtos/generateQRCodeDto.dart';

class QRGeneratorScreen extends StatefulWidget {
  const QRGeneratorScreen({Key? key}) : super(key: key);

  @override
  State<QRGeneratorScreen> createState() => _QRGeneratorScreenState();
}

class _QRGeneratorScreenState extends State<QRGeneratorScreen> {
  Uint8List? qrImageBytes;
  String? qrDataUri;
  bool isGenerating = false;
  bool isLoading = true; // New state for initial loading
  bool isFirstGeneration = true;
  String? errorMessage;
  QRCodeService? qrCodeService;

  @override
  void initState()  {
    super.initState();
    _initializeService();
    _loadExistingQRCode();
  }

  void _initializeService() {
    qrCodeService = QRCodeService(sl<DioClient>(instanceName: 'QrCode'));
  }

  Future<void> _loadExistingQRCode() async {
    
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await qrCodeService?.getQRCode();

      if (response != null && response.success) {
        // Assuming QRCodeData has a qrCodeBase64 property
        final base64Data = response.data?.qrCodeBase64;

        if (base64Data != null && base64Data.isNotEmpty) {
          final bytes = QRUtils.decodeBase64Robust(base64Data);
          final normalizedForUri = QRUtils.normalizeBase64(base64Data);
          final mime = QRUtils.detectMime(bytes);
          final dataUri = QRUtils.buildDataUri(normalizedForUri, mime);

          setState(() {
            qrImageBytes = bytes;
            qrDataUri = dataUri;
            isFirstGeneration = false;
          });
        } else {
          // No existing QR code, show placeholder
          _setPlaceholderQRCode();
        }
      } else {
        // API call succeeded but returned non-success response
        _setPlaceholderQRCode();
      }
    } catch (e) {
      // Error loading QR code, show placeholder
      _setPlaceholderQRCode();
      print('Error loading QR code: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _setPlaceholderQRCode() {
    final placeholderText = "Tap Generate to create your QR code";
    final placeholderBytes = _createPlaceholderQRCode(placeholderText);

    setState(() {
      qrImageBytes = placeholderBytes;
      qrDataUri = null; // No data URI for placeholder
      isFirstGeneration = true;
    });
  }

  Uint8List _createPlaceholderQRCode(String text) {
    
    // This is a simplified example - you might want to use a proper QR generator
    // or a placeholder image asset
    final code =
        '''
      <svg width="200" height="200" xmlns="http://www.w3.org/2000/svg">
        <rect width="200" height="200" fill="#f0f0f0" />
        <text x="100" y="100" text-anchor="middle" fill="#666">QR Code</text>
        <text x="100" y="120" text-anchor="middle" fill="#666" font-size="10">Tap to Generate</text>
      </svg>
    ''';

    // Convert SVG to bytes (simplified - in practice you might use a proper converter)
    return Uint8List.fromList(code.codeUnits);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const Spacer(flex: 2),
            const QRTitleSection(),
            const SizedBox(height: 65),
            isLoading
                ? const CircularProgressIndicator() // Show loading indicator
                : QRSection(
                    isGenerating: isGenerating,
                    qrImageBytes: qrImageBytes,
                    qrDataUri: qrDataUri,
                    errorMessage: errorMessage,
                    isFirstGeneration: isFirstGeneration,
                    onGeneratePressed: _generateQRCode,
                  ),
            const Spacer(flex: 2),
            _buildContinueButton(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Future<void> _generateQRCode() async {
    setState(() {
      isGenerating = true;
      errorMessage = null;
    });

    try {
      // Generate a new QR code using the service
      final response = await qrCodeService?.generateQRCode(GenerateQRCodeDto());

      if (response != null && response.success) {
        final base64Data = response.data?.qrCodeBase64;

        if (base64Data != null && base64Data.isNotEmpty) {
          final bytes = QRUtils.decodeBase64Robust(base64Data);
          final normalizedForUri = QRUtils.normalizeBase64(base64Data);
          final mime = QRUtils.detectMime(bytes);
          final dataUri = QRUtils.buildDataUri(normalizedForUri, mime);

          setState(() {
            qrImageBytes = bytes;
            qrDataUri = dataUri;
            isFirstGeneration = false;
            isGenerating = false;
          });
        } else {
          throw 'Generated QR code is empty';
        }
      } else {
        throw response?.message ?? 'Failed to generate QR code';
      }
    } catch (e) {
      setState(() {
        isGenerating = false;
        errorMessage = "Error generating QR code: $e";
      });
    }
  }

  Widget _buildContinueButton() {
    final languageService = Provider.of<LanguageService>(context);
    return CustomButton(
      text: languageService.getText('continue'),
      isEnabled:
          qrImageBytes != null && errorMessage == null && !isFirstGeneration,
      onPressed: () {
        Navigator.pushNamed(
          context,
          AppRoutes.logInQRHome,
          arguments: {
            'qrBytes': qrImageBytes,
            'qrDataUri': qrDataUri,
          },
        );
      },
    );
  }
}
