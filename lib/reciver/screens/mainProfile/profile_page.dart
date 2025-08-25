// lib/auth/screens/profile/profile_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tipme_app/core/dio/client/dio_client.dart';
import 'package:tipme_app/core/dio/service/api-service_path.dart';
import 'package:tipme_app/core/storage/storage_service.dart';
import 'package:tipme_app/di/gitIt.dart';
import 'package:tipme_app/reciver/widgets/mainProfile_widgets/custom_list_card.dart';
import 'package:tipme_app/routs/app_routs.dart';
import 'package:tipme_app/services/tipReceiverService.dart';
import 'package:tipme_app/services/cacheService.dart';
import 'package:tipme_app/utils/app_font.dart';
import 'package:tipme_app/utils/colors.dart';
import 'package:tipme_app/viewModels/tipReceiveerData.dart';

class ProfilePage extends StatefulWidget {
  final String? backgroundSvgPath;

  const ProfilePage({
    Key? key,
    this.backgroundSvgPath,
  }) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TipReceiveerData? _userData;
  bool _isLoading = true;
  String? _errorMessage;
  TipReceiverService? _tipReceiverService;
  CacheService? _cacheService;
  String? _cityName;
  String? _countryName;

  @override
  void initState() {
    super.initState();
    _initializeService();
    _loadUserData();
  }

  void _initializeService() {
    _tipReceiverService = sl<TipReceiverService>();
    _cacheService = CacheService(sl<DioClient>(instanceName: 'CacheService'));
  }

  Future<void> _loadUserData() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final response = await _tipReceiverService?.GetMe();
      
      if (response != null && response.success) {
        setState(() {
          _userData = response.data;
        });
        
        // Load city and country names from cache service
        await _loadLocationNames(_userData?.countryId, _userData?.cityId);
        
        setState(() {
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = response?.message ?? 'Failed to load user data';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading user data: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadLocationNames(String? countryId, String? cityId) async {
    try {
      if (countryId != null && _cacheService != null) {
        final countries = await _cacheService!.getCountries();
        final country = countries.firstWhere(
          (c) => c.id == countryId,
          orElse: () => throw Exception("Country not found"),
        );
        _countryName = country.name;

        if (cityId != null) {
          final cities = await _cacheService!.getCities(countryId);
          final city = cities.firstWhere(
            (c) => c.id == cityId,
            orElse: () => throw Exception("City not found"),
          );
          _cityName = city.name;
        }
      }
    } catch (e) {
      print('Error loading location names: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 280,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.secondary,
              ),
              child: Stack(
                children: [
                  if (widget.backgroundSvgPath != null)
                    Positioned.fill(
                      child: SvgPicture.asset(
                        widget.backgroundSvgPath!,
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Colors.white.withOpacity(0.1),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  Positioned(
                    top: 16,
                    left: 16,
                    child: GestureDetector(
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
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 40,
                    left: 0,
                    right: 0,
                    child: _buildUserInfo(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  children: [
                    CustomListCard(
                      title: 'Account Info',
                      subtitle: 'Update your account details',
                      iconPath: 'assets/icons/file-text.svg',
                      iconColor: AppColors.white,
                      iconBackgroundColor: AppColors.primary,
                      backgroundColor: AppColors.white,
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.accountInfo);
                      },
                      borderType: CardBorderType.bottom,
                      borderRadius: 0.0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 16.0,
                      ),
                      trailingType: TrailingType.arrow,
                    ),
                    CustomListCard(
                      title: 'Login & Security',
                      subtitle: 'Keep your account safe and secure',
                      iconPath: 'assets/icons/shield-lock.svg',
                      iconColor: AppColors.white,
                      iconBackgroundColor: AppColors.primary,
                      backgroundColor: AppColors.white,
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.loginSecurity);
                      },
                      borderType: CardBorderType.bottom,
                      borderRadius: 0.0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 16.0,
                      ),
                      trailingType: TrailingType.arrow,
                    ),
                    CustomListCard(
                      title: 'Notification Preferences',
                      subtitle: 'Customize your notification settings',
                      iconPath: 'assets/icons/bell-ringing.svg',
                      iconColor: AppColors.white,
                      iconBackgroundColor: AppColors.primary,
                      backgroundColor: AppColors.white,
                      onTap: () {
                        Navigator.pushNamed(
                            context, AppRoutes.notificationPreferences);
                      },
                      borderType: CardBorderType.bottom,
                      borderRadius: 0.0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 16.0,
                      ),
                      trailingType: TrailingType.arrow,
                    ),
                    CustomListCard(
                      title: 'Help & Support',
                      subtitle: 'Get assistance or report issues',
                      iconPath: 'assets/icons/headphones.svg',
                      iconColor: AppColors.white,
                      iconBackgroundColor: AppColors.primary,
                      backgroundColor: AppColors.white,
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.helpSupport);
                      },
                      borderType: CardBorderType.none,
                      borderRadius: 0.0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 16.0,
                      ),
                      trailingType: TrailingType.arrow,
                    ),
                    const SizedBox(height: 32),
                    GestureDetector(
                      onTap: () {
                        _showSignOutDialog(context);
                      },
                      child: Text(
                        'Sign Out',
                        style: AppFonts.mdSemiBold(
                          context,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    if (_isLoading) {
      return const Column(
        children: [
          CircularProgressIndicator(color: Colors.white),
          SizedBox(height: 16),
          Text(
            'Loading...',
            style: TextStyle(color: Colors.white),
          ),
        ],
      );
    }

    if (_errorMessage != null) {
      return Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey,
            ),
            child: const Icon(
              Icons.person,
              size: 40,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Error loading profile',
            style: AppFonts.xlBold(
              context,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _errorMessage!,
            style: AppFonts.smMedium(
              context,
              color: Colors.white.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: ClipOval(
            child: _userData?.imagePath != null && _userData!.imagePath!.isNotEmpty
                ? Image.network(
                    "${ApiServicePath.fileServiceUrl}/${_userData!.imagePath}",
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.person,
                          size: 40,
                          color: Colors.grey,
                        ),
                      );
                    },
                  )
                : Container(
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.grey,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          '${_userData?.firstName ?? ''} ${_userData?.surName ?? ''}'.trim(),
          style: AppFonts.xlBold(
            context,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        if (_cityName != null || _countryName != null)
          Text(
            '${_cityName ?? ''}, ${_countryName ?? ''}'.replaceAll(RegExp(r'^, |, $'), ''),
            style: AppFonts.smMedium(
              context,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        const SizedBox(height: 4),
        if (_userData?.mobileNumber != null)
          Text(
            _userData!.mobileNumber!,
            style: AppFonts.smMedium(
              context,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
      ],
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Sign Out',
            style: AppFonts.lgBold(context),
          ),
          content: Text(
            'Are you sure you want to sign out?',
            style: AppFonts.mdRegular(context),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: AppFonts.mdMedium(context, color: AppColors.text),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  await StorageService.clear();
                  final cacheService = getIt<CacheService>();
                  cacheService.clearAllCache();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    AppRoutes.signInUp,
                    (route) => false,
                  );
                } catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to sign out. Please try again.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Text(
                'Sign Out',
                style: AppFonts.mdMedium(context, color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
