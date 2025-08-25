// lib/reciver/screens/mainProfile/account_info_page.dart
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tipme_app/core/dio/client/dio_client.dart';
import 'package:tipme_app/core/dio/service/api-service_path.dart';
import 'package:tipme_app/di/gitIt.dart';
import 'package:tipme_app/reciver/widgets/mainProfile_widgets/account_phone_input.dart';
import 'package:tipme_app/reciver/widgets/mainProfile_widgets/action_button.dart';
import 'package:tipme_app/reciver/widgets/mainProfile_widgets/bottom_sheet.dart';
import 'package:tipme_app/data/services/language_service.dart';
import 'package:tipme_app/reciver/widgets/phone_input.dart';
import 'package:tipme_app/services/authTipReceiverService.dart';
import 'package:tipme_app/services/tipReceiverService.dart';
import 'package:tipme_app/utils/app_font.dart';
import 'package:tipme_app/utils/colors.dart';
import '../../widgets/custom_input_field.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/wallet_widgets/custom_top_bar.dart';

class AccountInfoPage extends StatefulWidget {
  const AccountInfoPage({Key? key}) : super(key: key);

  @override
  State<AccountInfoPage> createState() => _AccountInfoPageState();
}

class _AccountInfoPageState extends State<AccountInfoPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final tipReceiverService = sl<TipReceiverService>();
  final authTipReceiverService =
      AuthTipReceiverService(sl<DioClient>(instanceName: 'AuthTipReceiver'));

  bool _isLoading = true;
  bool _isUpdating = false;
  String? _selectedCountryCode = '+966';
  bool _hasProfileImage = false;
  String? _userId;
  String? _imagePath;
  File? _imageFile;
  Uint8List? _imageBytes;
  String? _imageUrl;
  bool _isImageChanged = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await tipReceiverService.GetMe();
      if (response != null && response.success) {
        final userData = response.data;
        _userId = userData?.id;
        _firstNameController.text = userData?.firstName ?? '';
        _surnameController.text = userData?.surName ?? '';
        _imageUrl =
            userData?.imagePath != null && userData!.imagePath!.isNotEmpty
                ? "${ApiServicePath.fileServiceUrl}/${userData.imagePath}"
                : null;
        _hasProfileImage = _imageUrl != null;

        // Handle phone number and country code
        final fullNumber = userData?.mobileNumber ?? '';
        if (fullNumber.isNotEmpty) {
          if (fullNumber.startsWith('+') && fullNumber.length > 3) {
            _selectedCountryCode = fullNumber.substring(0, 4);
            _phoneController.text = fullNumber.substring(4);
          } else {
            _phoneController.text = fullNumber;
          }
        }

        _imagePath = userData?.imagePath;
      }
    } catch (e) {
      print('Error loading user data: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load user data')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _updateProfile() async {
    if (_userId == null) return;

    setState(() {
      _isUpdating = true;
    });

    try {
      final fullPhoneNumber = '${_selectedCountryCode}${_phoneController.text}';
      final formData = FormData.fromMap({
        'firstName': _firstNameController.text,
        'surName': _surnameController.text,
        'mobileNumber': fullPhoneNumber,
        if (_imageFile != null && !kIsWeb)
          'image': await MultipartFile.fromFile(_imageFile!.path),
        if (_imageBytes != null && kIsWeb)
          'image':
              MultipartFile.fromBytes(_imageBytes!, filename: "profile.png"),
      });
      await authTipReceiverService.editProfile(_userId!, formData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
        await _loadUserData();
      }
    } catch (e) {
      print('Error updating profile: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update profile')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUpdating = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _surnameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _onChangeProfile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        withData: true, // مهم للويب
      );

      if (result != null && result.files.isNotEmpty) {
        PlatformFile file = result.files.first;

        if (file.size > 5 * 1024 * 1024) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Image size should be less than 5MB'),
                backgroundColor: Colors.red,
              ),
            );
          }
          return;
        }

        setState(() {
          if (kIsWeb) {
            _imageBytes = file.bytes;
            _imageFile = null;
          } else {
            _imageFile = File(file.path!);
            _imageBytes = null;
          }
          _hasProfileImage = true;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error selecting image: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _onDeleteProfile() {
    SuccessBottomSheet.show(
      context,
      titleKey: 'Delete Profile Picture!',
      descriptionKey: 'Are you sure you want to delete this profile picture?',
      primaryButtonTextKey: 'Yes, Delete',
      secondaryButtonTextKey: 'No, Cancel',
      icon: Icons.delete_outline,
      iconColor: AppColors.danger_500,
      iconBackgroundColor: AppColors.white,
      primaryButtonColor: AppColors.danger_500,
      primaryButtonTextColor: AppColors.white,
      secondaryButtonBorderColor: AppColors.border_2,
      secondaryButtonTextColor: AppColors.text,
      onPrimaryButtonPressed: () {
        Navigator.pop(context);
        setState(() {
          _hasProfileImage = false;
          _imageFile = null;
          _imageBytes = null;
          _imageUrl = null;
        });
      },
      onSecondaryButtonPressed: () {
        Navigator.pop(context);
      },
    );
  }

  void _onPhoneChanged(String phone) {
    setState(() {
      _phoneController.text = phone;
    });
  }

  void _onCountryChanged(String countryCode) {
    setState(() {
      _selectedCountryCode = countryCode;
    });
  }

  void _onUpdatePressed() {
    _updateProfile();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final languageService = Provider.of<LanguageService>(context);

    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: SafeArea(
        child: Column(
          children: [
            CustomTopBar.withTitle(
              title: Text(
                'Account Info',
                style: AppFonts.lgBold(context, color: AppColors.white),
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
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              showNotification: false,
              showProfile: false,
            ),
            const SizedBox(height: 24),
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
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 32, 16, 32),
                  child: Column(
                    children: [
                      _buildProfileSection(),
                      const SizedBox(height: 32),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'First Name',
                                  style: AppFonts.mdSemiBold(context,
                                      color: AppColors.black),
                                ),
                                const SizedBox(height: 8),
                                CustomTextField(
                                  hintText: 'First Name',
                                  controller: _firstNameController,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Surname',
                                  style: AppFonts.mdSemiBold(context,
                                      color: AppColors.black),
                                ),
                                const SizedBox(height: 8),
                                CustomTextField(
                                  hintText: 'Surname',
                                  controller: _surnameController,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Phone Number',
                            style: AppFonts.smMedium(context,
                                color: AppColors.text),
                          ),
                          const SizedBox(height: 8),
                          AccountPhoneInput(
                            phoneNumber: _phoneController.text,
                            selectedCountryCode: _selectedCountryCode ?? "",
                            onPhoneChanged: _onPhoneChanged,
                            onCountryChanged: _onCountryChanged,
                          ),
                          // CustomPhoneInput(
                          //   controller: _phoneController,
                          //   onPhoneChanged: _onPhoneChanged,
                          //   onCountryChanged: _onCountryChanged,
                          //   phoneNumber: _phoneController.text,
                          //   isVerified: true,
                          // ),
                        ],
                      ),
                      const Spacer(),
                      CustomButton(
                        text: 'Update',
                        onPressed: _onUpdatePressed,
                        showArrow: true,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Column(
      children: [
        Center(
          child: Stack(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey[200],
                child: _hasProfileImage
                    ? (_imageBytes != null
                        ? ClipOval(
                            child: Image.memory(
                              _imageBytes!,
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          )
                        : _imageFile != null
                            ? ClipOval(
                                child: Image.file(
                                  _imageFile!,
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : _imageUrl != null
                                ? ClipOval(
                                    child: Image.network(
                                      _imageUrl!,
                                      width: 120,
                                      height: 120,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) => Icon(
                                        Icons.person,
                                        size: 60,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  )
                                : Icon(
                                    Icons.person,
                                    size: 60,
                                    color: Colors.grey[600],
                                  ))
                    : Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.grey[600],
                      ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.camera_alt,
                        color: Colors.white, size: 20),
                    onPressed: _onChangeProfile,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ActionButton(
              text: 'Change',
              backgroundColor: AppColors.secondary_500.withOpacity(0.1),
              textColor: AppColors.secondary_500,
              svgIcon: 'assets/icons/pencil.svg',
              onPressed: _onChangeProfile,
            ),
            if (_hasProfileImage) ...[
              const SizedBox(width: 12),
              ActionButton(
                text: 'Delete',
                backgroundColor: AppColors.danger_500.withOpacity(0.1),
                textColor: AppColors.danger_500,
                svgIcon: 'assets/icons/trash.svg',
                onPressed: _onDeleteProfile,
              ),
            ],
          ],
        ),
      ],
    );
  }
}
