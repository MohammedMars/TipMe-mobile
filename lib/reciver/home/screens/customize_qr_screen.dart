import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'package:tipme_app/core/dio/client/dio_client.dart';
import 'package:tipme_app/di/gitIt.dart';
import 'package:tipme_app/reciver/home/widgets/qr_utils.dart';
import 'package:tipme_app/reciver/widgets/custom_button.dart';
import 'package:tipme_app/reciver/widgets/wallet_widgets/custom_top_bar.dart';
import 'package:tipme_app/reciver/home/widgets/qr_content.dart';
import 'package:tipme_app/data/services/language_service.dart';
import 'package:tipme_app/utils/app_font.dart';
import 'package:tipme_app/utils/colors.dart';
import 'package:tipme_app/services/qrCodeService.dart'; // Add your QR service
import 'package:tipme_app/dtos/generateQRCodeDto.dart'; // Add your DTO

class CustomizeQrScreen extends StatefulWidget {
  final Uint8List? qrBytes;
  final Uint8List? currentLogo;
  final String? qrDataUri;
  final String frontendUrl; // Add frontend URL
  final String tipReceiverId; // Add tip receiver ID

  const CustomizeQrScreen({
    Key? key,
    required this.qrBytes,
    required this.currentLogo,
    required this.qrDataUri,
    required this.frontendUrl,
    required this.tipReceiverId,
  }) : super(key: key);

  @override
  State<CustomizeQrScreen> createState() => _CustomizeQrScreenState();
}

class _CustomizeQrScreenState extends State<CustomizeQrScreen> {
  static const int maxBytes = 5 * 1024 * 1024; // 5MB
  Uint8List? qrBytes;
  Uint8List? draftLogo;
  bool picking = false;
  bool isGenerating = false; // Add loading state for QR generation
  QRCodeService? qrCodeService; // Add QR service

  @override
  void initState() {
    super.initState();
    qrBytes = widget.qrBytes;
    draftLogo = widget.currentLogo;
    // Initialize your QR service (adjust based on your DI setup)
    qrCodeService = QRCodeService(sl<DioClient>(instanceName: 'QrCode'));
    _loadExistingQRCode();
  }

  @override
  Widget build(BuildContext context) {
    final languageService = Provider.of<LanguageService>(context);
    final hasLogo = draftLogo != null;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomTopBar.withTitle(
        title: Text(
          languageService.getText('customizeQRCode'),
          style: AppFonts.lgBold(context, color: AppColors.black),
        ),
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_back,
              color: AppColors.black,
              size: 20,
            ),
          ),
        ),
        showNotification: false,
        showProfile: false,
      ),
      body: _buildBody(languageService, hasLogo),
      bottomNavigationBar: _buildBottomButton(languageService),
    );
  }

  Widget _buildBody(LanguageService languageService, bool hasLogo) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildQrPreview(),
            const SizedBox(height: 16),
            _buildUploadButton(languageService, hasLogo),
          ],
        ),
      ),
    );
  }

  Widget _buildQrPreview() {
    final languageService = Provider.of<LanguageService>(context);

    return Container(
      width: 212,
      height: 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              // QR code display - now with embedded logo
              QRContent(
                isGenerating: isGenerating,
                qrImageBytes: qrBytes,
                qrDataUri: widget.qrDataUri,
                errorMessage: null,
              ),
              if (isGenerating)
                const CircularProgressIndicator(), // Show loading when generating
              // Logo preview (visual only)
              _buildLogoPreview(),
            ],
          ),
          const SizedBox(height: 18),
          _buildInstructionText(languageService),
        ],
      ),
    );
  }

  Widget _buildLogoPreview() {
    return Container(
      width: 72,
      height: 72,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Center(
        child: Container(
          width: 68,
          height: 68,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primary, width: 1),
          ),
          child: Center(
            child: SizedBox(
              width: 60,
              height: 60,
              child: ClipOval(
                child: draftLogo != null
                    ? Image.memory(
                        draftLogo!,
                        fit: BoxFit.contain,
                      )
                    : const Center(
                        child: Text(
                          "Your\nLogo",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.black54,
                          ),
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInstructionText(LanguageService languageService) {
    return Column(
      children: [
        Text(
          languageService.getText('UploadYourLogo'),
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          languageService.getText("onlyPNG_JPG"),
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.text,
            fontSize: 12,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 4)
      ],
    );
  }

  Widget _buildUploadButton(LanguageService languageService, bool hasLogo) {
    return SizedBox(
      width: 150,
      child: OutlinedButton(
        onPressed: picking ? null : _pickLogo,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          hasLogo
              ? languageService.getText("changeLogo")
              : languageService.getText("uploadLogo"),
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomButton(LanguageService languageService) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
      child: CustomButton(
        text: languageService.getText("updateQR"),
        isEnabled: draftLogo != null && !isGenerating,
        onPressed: draftLogo != null ? _generateQRWithLogo : null,
      ),
    );
  }

  Future<void> _generateQRWithLogo() async {
    if (draftLogo == null) return;

    setState(() => isGenerating = true);

    try {
      // Create DTO with logo bytes
      final generateDto = GenerateQRCodeDto(logo: draftLogo!);

      // Call your backend service to generate QR with embedded logo
      final response = await qrCodeService!.generateQRCode(generateDto);

      if (response != null && response.success) {
        // Decode the base64 response to get the new QR code bytes
        final base64Data = response.data?.qrCodeBase64;
        if (base64Data != null && base64Data.isNotEmpty) {
          // You'll need to implement base64 decoding similar to your other screen
          final bytes = _decodeBase64(base64Data);

          setState(() {
            qrBytes = bytes;
          });

          _showSnackbar("QR code updated with logo successfully!");
        } else {
          throw 'Failed to generate QR code with logo';
        }
      } else {
        throw response?.message ?? 'Failed to generate QR code';
      }
    } catch (e) {
      _showSnackbar("Error generating QR code: $e");
    } finally {
      setState(() => isGenerating = false);
    }
  }

  Uint8List _decodeBase64(String base64String) {
    // Remove data URI prefix if present
    final cleanBase64 =
        base64String.replaceFirst(RegExp(r'^data:image/[^;]+;base64,'), '');
    return base64.decode(cleanBase64);
  }

  Future<void> _pickLogo() async {
    setState(() => picking = true);
    try {
      final res = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: true,
      );

      if (res == null || res.files.isEmpty) return;

      final file = res.files.first;
      final bytes = file.bytes;

      if (bytes == null) {
        _showSnackbar("Failed to read file.");
        return;
      }

      if (!_isValidImageType(file.name)) {
        _showSnackbar("Unsupported file type. Use PNG or JPG.");
        return;
      }

      if (bytes.length > maxBytes) {
        _showSnackbar("File too large. Max 5 MB.");
        return;
      }

      setState(() => draftLogo = bytes);
    } catch (e) {
      _showSnackbar("Error selecting image: $e");
    } finally {
      setState(() => picking = false);
    }
  }

  bool _isValidImageType(String? filename) {
    if (filename == null) return false;
    final name = filename.toLowerCase();
    return name.endsWith(".png") ||
        name.endsWith(".jpg") ||
        name.endsWith(".jpeg");
  }

  void _showSnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  Future<void> _loadExistingQRCode() async {
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
            qrBytes = bytes;
          });
        }
      }
    } catch (e) {
      print('Error loading QR code: $e');
    }
  }
}
