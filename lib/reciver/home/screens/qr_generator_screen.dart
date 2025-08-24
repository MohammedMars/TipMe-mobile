import 'package:flutter/services.dart' show ByteData, Uint8List, rootBundle;
import 'dart:ui' as ui;
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
  void initState() {
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
        final base64Data = response.data?.qrCodeBase64;

        if (base64Data != null && base64Data.isNotEmpty) {
          final bytes = QRUtils.decodeBase64Robust(base64Data);
          final normalizedForUri = QRUtils.normalizeBase64(base64Data);
          final mime = QRUtils.detectMime(bytes);
          final dataUri = QRUtils.buildDataUri(normalizedForUri, mime);

          // Navigate to qr_flow if not first generation
          if (mounted) {
            Navigator.pushReplacementNamed(context, AppRoutes.logInQRHome);
          }
          return;
        } else {
          // No existing QR code, show placeholder
          await _setPlaceholderQRCode();
        }
      } else {
        // API call succeeded but returned non-success response
        await _setPlaceholderQRCode();
      }
    } catch (e) {
      // Error loading QR code, show placeholder
      await _setPlaceholderQRCode();
      print('Error loading QR code: $e');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _setPlaceholderQRCode() async {
    final placeholderText = "Tap Generate to create your QR code";
    final placeholderBytes = await _createPlaceholderQRCode(placeholderText);

    if (mounted) {
      setState(() {
        qrImageBytes = placeholderBytes;
        qrDataUri = null; // No data URI for placeholder
        isFirstGeneration = true;
      });
    }
  }

  Future<Uint8List> _createPlaceholderQRCode(String text) async {
    try {
      // Load the image from assets
      final ByteData data =
          await rootBundle.load('assets/images/default_qr.jpeg');
      return data.buffer.asUint8List();
    } catch (e) {
      debugPrint('Error loading placeholder image: $e');
      // Fallback to a simple colored placeholder if image loading fails
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      final paint = Paint()..color = Colors.grey[300]!;
      const size = 300.0;
      canvas.drawRRect(
        RRect.fromRectAndCorners(
          const Rect.fromLTWH(0, 0, size, size),
          topLeft: const Radius.circular(8),
          topRight: const Radius.circular(8),
          bottomLeft: const Radius.circular(8),
          bottomRight: const Radius.circular(8),
        ),
        paint,
      );
      final picture = recorder.endRecording();
      final img = await picture.toImage(size.toInt(), size.toInt());
      final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
      return byteData!.buffer.asUint8List();
    }
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
