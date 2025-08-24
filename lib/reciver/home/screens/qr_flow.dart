import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:tipme_app/core/dio/client/dio_client.dart';
import 'package:tipme_app/core/storage/storage_service.dart';
import 'package:tipme_app/di/gitIt.dart';
import 'package:tipme_app/reciver/screens/wallet/notification_screen.dart';
import 'package:tipme_app/reciver/widgets/custom_bottom_navigation.dart';
import 'package:tipme_app/reciver/widgets/wallet_widgets/custom_top_bar.dart';
import 'package:tipme_app/reciver/home/screens/customize_qr_screen.dart';
import 'package:tipme_app/reciver/home/widgets/qr_content.dart';
import 'package:tipme_app/reciver/home/widgets/quick_icon.dart';
import 'package:tipme_app/routs/app_routs.dart';
import 'package:tipme_app/data/services/language_service.dart';
import 'package:tipme_app/services/tipReceiverStatisticsService.dart';
import 'package:tipme_app/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:tipme_app/services/qrCodeService.dart';

class HomeScreen extends StatefulWidget {
  final Uint8List? qrBytes;
  final String? qrDataUri;
  final Uint8List? logoBytes;

  const HomeScreen({
    super.key,
    this.qrBytes,
    this.qrDataUri,
    this.logoBytes,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Constants for layout measurements
  static const double _bgWidth = 332;
  static const double _bgHeight = 296;
  static const double _overlayDrop = 250;
  static const double _cardWidth = 338;
  static const double _overlayCardHeight = 340;
  int _currentBottomNavIndex = 0; // Set to qr tab (index 0)
  final bool _showNotifications = true;
  late TipReceiverStatisticsService _statisticsService;
  Uint8List? qrBytes;
  Uint8List? logoBytes;
  Uint8List? savedLogoBytes;
  bool isLoading = true;
  String? errorMessage;
  QRCodeService? qrCodeService;
  String _currency = "SAR";
  double _balance = 0.0;

  @override
  void initState() {
    super.initState();
    _initializeService();
    _loadQRCodeFromBackend();
    _loadSavedLogo();
    _fetchBalance();
  }

  void _initializeService() {
    qrCodeService = QRCodeService(sl<DioClient>(instanceName: 'QrCode'));
  }

  Future<void> _loadQRCodeFromBackend() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await qrCodeService?.getQRCode();

      if (response != null && response.success) {
        final base64Data = response.data?.qrCodeBase64;
        if (base64Data != null && base64Data.isNotEmpty) {
          final bytes = _decodeBase64(base64Data);
          setState(() {
            qrBytes = bytes;
          });
        } else {
          // Handle case where no QR code exists yet
          setState(() {
            errorMessage = "No QR code found. Please generate one first.";
          });
        }
      } else {
        setState(() {
          errorMessage = response?.message ?? "Failed to load QR code";
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Error loading QR code: $e";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Uint8List _decodeBase64(String base64String) {
    // Remove data URI prefix if present
    final cleanBase64 =
        base64String.replaceFirst(RegExp(r'^data:image/[^;]+;base64,'), '');
    return base64.decode(cleanBase64);
  }

  @override
  Widget build(BuildContext context) {
    final languageService = Provider.of<LanguageService>(context);
    final Uint8List? logoToShow = savedLogoBytes ?? widget.logoBytes;

    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: SafeArea(
        child: Stack(
          children: [
            _buildBackgroundImage(),
            CustomTopBar.home(
              profileImagePath: 'assets/images/bank.png',
              onProfileTap: () {
                Navigator.pushNamed(context, AppRoutes.profilePage);
              },
              onNotificationTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationScreen(),
                  ),
                );
              },
              showNotification: _showNotifications,
            ),
            _buildMainContent(languageService, logoToShow),
            _buildBalanceCard(),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentBottomNavIndex,
        onTap: (index) {
          setState(() {
            _currentBottomNavIndex = index;
          });
          _handleBottomNavTap(index);
        },
      ),
    );
  }

  void _handleBottomNavTap(int index) {
    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.pushNamed(context, AppRoutes.walletScreen);
        break;
      case 2:
        Navigator.pushNamed(context, AppRoutes.transactions);
        break;
    }
  }

  Widget _buildBackgroundImage() {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        width: _bgWidth,
        height: _bgHeight,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/freepik--Graphics--inject-11.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent(
      LanguageService languageService, Uint8List? logoToShow) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.63,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 45),
            _buildShadow(),
            const SizedBox(height: 25),
            Expanded(
              child: Align(
                alignment: Alignment.topCenter,
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.topCenter,
                  children: [
                    _buildQrContainer(languageService, logoToShow),
                    _buildCustomizeButton(languageService),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShadow() {
    return Container(
      width: 265,
      height: 10,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(120),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 18,
            spreadRadius: 0,
            offset: const Offset(0, 3),
          )
        ],
      ),
    );
  }

  Widget _buildQrContainer(
      LanguageService languageService, Uint8List? logoToShow) {
    return Container(
      width: 338,
      height: 342,
      decoration: BoxDecoration(
        color: AppColors.gray_bg_2,
        border: Border.all(color: AppColors.border_3, width: 1),
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Column(
        children: [
          const SizedBox(height: 15),
          Text(
            languageService.getText("MyTipMeQR"),
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
          ),
          const SizedBox(height: 12),
          _buildQrWithLogo(logoToShow),
          const SizedBox(height: 10),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildQrWithLogo(Uint8List? logoToShow) {
    if (isLoading) {
      return Container(
        width: 160,
        height: 160,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (errorMessage != null) {
      return Container(
        width: 160,
        height: 160,
        child: Center(
          child: Text(
            errorMessage!,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    return Container(
      width: 160,
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColors.gray_bg_2,
      ),
      child: Center(
        child: QRContent(
          isGenerating: false,
          qrImageBytes: qrBytes,
          qrDataUri: null,
          errorMessage: null,
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        QuickIcon(
          assetPath: "assets/icons/icon-share.svg",
          label: "Share",
          onTap: _shareQr,
        ),
        const SizedBox(width: 16),
        QuickIcon(
          assetPath: "assets/icons/icon-download2.svg",
          label: "Save",
          onTap: () async {
            await _saveQrToGallery(qrBytes, context);
          },
        ),
      ],
    );
  }

  Future<void> _shareQr() async {
    // TODO: Implement share functionality
  }

  Future<void> _saveQrToGallery(
      Uint8List? qrBytes, BuildContext context) async {
    if (qrBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No QR code available to save')),
      );
      return;
    }

    try {
      // Request permissions depending on platform
      if (Platform.isAndroid) {
        // For Android 13+ use READ_MEDIA_IMAGES, older Androids use STORAGE
        if (await Permission.storage.request().isDenied ||
            await Permission.photos.request().isDenied) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Storage permission denied')),
          );
          return;
        }
      } else if (Platform.isIOS) {
        if (await Permission.photosAddOnly.request().isDenied) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Photos permission denied')),
          );
          return;
        }
      }

      // Save the image
      final result = await ImageGallerySaver.saveImage(
        qrBytes,
        quality: 100,
        name: "MyTipMeQR_${DateTime.now().millisecondsSinceEpoch}",
      );

      final isSuccess = result['isSuccess'] ?? false;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isSuccess ? 'QR Code saved to gallery!' : 'Failed to save QR Code.',
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving QR Code: $e'),
        ),
      );
    }
  }

  Future<bool> _requestPermission() async {
    if (Platform.isAndroid) {
      // Android 13+ uses READ_MEDIA_IMAGES
      if (await Permission.photos.isGranted) return true;

      var status = await Permission.photos.request();
      return status.isGranted;
    } else if (Platform.isIOS) {
      var status = await Permission.photos.request();
      return status.isGranted;
    }
    return false;
  }

  Widget _buildCustomizeButton(LanguageService languageService) {
    return Positioned(
      bottom: -30,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.grey.shade300, width: 1.5),
        ),
        padding: const EdgeInsets.all(4),
        child: SizedBox(
          width: 170,
          height: 48,
          child: ElevatedButton(
            onPressed: _openCustomize,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              elevation: 0,
            ),
            child: Text(
              languageService.getText("customizeQR"),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Positioned(
      top: _bgHeight - _overlayDrop,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          width: _cardWidth,
          height: _overlayCardHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: AppColors.info_910,
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 7),
              _buildWelcomeSection(),
              const SizedBox(height: 20),
              _buildBalanceSection(),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    final languageService = Provider.of<LanguageService>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          languageService.getText('Welcome'),
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.white,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          languageService.getText('goodToSeeYou'),
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildBalanceSection() {
    return Container(
      height: 96,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: const Color.fromARGB(255, 36, 28, 110),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.asset(
              'assets/images/Mask group.png',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                _buildLogoContainer(),
                const SizedBox(width: 14),
                _buildBalanceText(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoContainer() {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Image.asset(
          'assets/images/Group_39258.png',
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildBalanceText() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Available Balance",
          style: TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "${_balance.toStringAsFixed(2)} $_currency",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Future<void> _openCustomize() async {
    final user_id = await StorageService.get('user_id');
    // ignore: use_build_context_synchronously
    await Navigator.push<Map<String, dynamic>?>(
      context,
      MaterialPageRoute(
        builder: (_) => CustomizeQrScreen(
          qrBytes: qrBytes,
          currentLogo: logoBytes,
          qrDataUri: null, // We're using bytes from backend
          frontendUrl: "your-frontend-url", // Replace with actual frontend URL
          tipReceiverId: user_id ?? "",
        ),
      ),
    );

    // Always refresh the QR code from backend when returning
    await _loadQRCodeFromBackend();
    
    // Also refresh the logo in case it was updated
    await _loadSavedLogo();
  }

  Future<void> _saveLogo(Uint8List bytes) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('logoBase64', base64.encode(bytes));
    setState(() {
      savedLogoBytes = bytes;
    });
  }

  Future<void> _loadSavedLogo() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLogo = prefs.getString('logoBase64');
    if (savedLogo != null) {
      try {
        setState(() {
          logoBytes = base64.decode(savedLogo);
        });
      } catch (e) {
        print('Error loading saved logo: $e');
      }
    }
  }

  Future<void> _fetchBalance() async {
    try {
      _statisticsService = TipReceiverStatisticsService(
          sl<DioClient>(instanceName: 'Statistics'));
      final response = await _statisticsService.getBalance();
      setState(() {
        _balance = response.data["total"];
      });
    } catch (e) {
      setState(() {
        _balance = 0.0;
      });
    }
  }
}
