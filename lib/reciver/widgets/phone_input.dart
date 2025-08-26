// lib/shared/widgets/phone_input.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tipme_app/core/dio/client/dio_client.dart';
import 'package:tipme_app/core/storage/storage_service.dart';
import 'package:tipme_app/data/services/language_service.dart';
import 'package:tipme_app/di/gitIt.dart';
import 'package:tipme_app/dtos/changeMobileNumberDto.dart';
import 'package:tipme_app/reciver/widgets/mainProfile_widgets/otp_card.dart';
import 'package:tipme_app/services/cacheService.dart';
import 'package:tipme_app/services/authTipReceiverService.dart';
import 'package:tipme_app/utils/app_font.dart';
import 'package:tipme_app/utils/colors.dart';

class CountryInfo {
  final String nameKey;
  final String code;
  final String countryCode;
  final String? customFlagPath;

  const CountryInfo({
    required this.nameKey,
    required this.code,
    required this.countryCode,
    this.customFlagPath,
  });

  String get flagPath => customFlagPath ?? 'icons/flags/png/$countryCode.png';
}

enum PhoneInputMode {
  auth, // (sign_in_up)
  account, //(account_info_page)
}

class CustomPhoneInput extends StatefulWidget {
  final Function(String) onPhoneChanged;
  final Function(String)? onCountryChanged;
  final VoidCallback? onVerified;
  final String phoneNumber;
  final TextEditingController? controller;
  final bool isVerified;
  final PhoneInputMode mode;
  final String selectedCountryCode;

  const CustomPhoneInput({
    Key? key,
    required this.onPhoneChanged,
    this.onCountryChanged,
    this.onVerified,
    this.phoneNumber = '',
    this.controller,
    this.isVerified = false,
    this.mode = PhoneInputMode.auth,
    this.selectedCountryCode = '+971',
  }) : super(key: key);

  @override
  State<CustomPhoneInput> createState() => _CustomPhoneInputState();
}

class _CustomPhoneInputState extends State<CustomPhoneInput> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  final _cacheService =
      CacheService(sl<DioClient>(instanceName: 'CacheService'));
  final _authService = sl<AuthTipReceiverService>();

  CountryInfo? _selectedCountry;
  List<CountryInfo> _countries = [];

  bool _isDropdownOpen = false;
  OverlayEntry? _overlayEntry;
  final GlobalKey _buttonKey = GlobalKey();
  final LayerLink _layerLink = LayerLink();
  double _dropdownWidth = 0;
  double _maxDropdownWidth = 0;

  bool _hasBeenEdited = false;
  bool _isVerifying = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = FocusNode();

    // Only set initial text if no controller is provided
    if (widget.controller == null) {
      _controller.text = widget.phoneNumber;
    }

    _controller.addListener(() {
      widget.onPhoneChanged(_controller.text);
      if (widget.mode == PhoneInputMode.account) {
        _checkForEdits();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCountries();
    });

    if (widget.mode == PhoneInputMode.account) {
      _hasBeenEdited = widget.phoneNumber.isNotEmpty;
    }
  }

  @override
  void didUpdateWidget(CustomPhoneInput oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.mode == PhoneInputMode.account &&
        oldWidget.selectedCountryCode != widget.selectedCountryCode &&
        _countries.isNotEmpty) {
      _updateSelectedCountryFromCode(widget.selectedCountryCode);
    }
  }

  void _checkForEdits() {
    if (_controller.text != widget.phoneNumber) {
      setState(() {
        _hasBeenEdited = true;
      });
    }
  }

  Future<void> _loadCountries() async {
    var countries = await _cacheService.getCountries();
    setState(() {
      _countries = countries
          .map((country) => CountryInfo(
                nameKey: country.name,
                code: "+${country.phoneCode}",
                countryCode: country.code,
              ))
          .toList();

      // Only set the selected country based on selectedCountryCode in account mode
      // and when phoneNumber is not empty (indicating existing user data)
      if (widget.mode == PhoneInputMode.account &&
          widget.phoneNumber.isNotEmpty) {
        _updateSelectedCountryFromCode(widget.selectedCountryCode);
      } else {
        // For auth mode or when no phone number exists, find the country matching selectedCountryCode or use first
        if (_countries.isNotEmpty) {
          final matchingCountry = _countries.firstWhere(
            (country) => country.code == widget.selectedCountryCode,
            orElse: () => _countries.first,
          );
          _selectedCountry = matchingCountry;
          widget.onCountryChanged?.call(_selectedCountry!.code);
        }
      }
    });

    _calculateDropdownWidth();
  }

  void _updateSelectedCountryFromCode(String countryCode) {
    if (_countries.isNotEmpty) {
      // Find the country that matches the provided country code
      final matchingCountry = _countries.firstWhere(
        (country) => country.code == countryCode,
        orElse: () =>
            _countries.first, // fallback to first country if not found
      );

      setState(() {
        _selectedCountry = matchingCountry;
      });

      // Notify parent about the country change if it's different
      if (_selectedCountry?.code != countryCode) {
        widget.onCountryChanged?.call(_selectedCountry!.code);
      }
    }
  }

  void _calculateDropdownWidth() {
    if (_countries.isEmpty) return;

    final textStyle = AppFonts.mdMedium(context, color: AppColors.text);
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    double maxWidth = 0;

    for (var country in _countries) {
      textPainter.text = TextSpan(text: '${country.code}   ', style: textStyle);
      textPainter.layout();
      final totalWidth = 26 + 6 + textPainter.width + 4 + 16 + 16;
      if (totalWidth > maxWidth) maxWidth = totalWidth;
    }

    setState(() {
      _maxDropdownWidth = maxWidth;
      _dropdownWidth = maxWidth;
    });
  }

  void _toggleDropdown() {
    if (_isDropdownOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    if (_overlayEntry != null) return;

    final renderBox =
        _buttonKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: _dropdownWidth,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, renderBox.size.height + 4),
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(13),
            child: _buildDropdownContainer(),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _isDropdownOpen = true);
  }

  void _closeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() => _isDropdownOpen = false);
  }

  void _onCountrySelected(CountryInfo country) {
    setState(() => _selectedCountry = country);
    widget.onCountryChanged?.call(country.code);
    _closeDropdown();
  }

  Widget _buildDropdownContainer() {
    return Container(
      width: _dropdownWidth,
      constraints: BoxConstraints(
        maxHeight: 200,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: AppColors.border_2, width: 1),
      ),
      child: _countries.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              children: _countries.map(_buildCountryItem).toList(),
            ),
    );
  }

  Widget _buildCountryItem(CountryInfo country) {
    final bool isSelected = _selectedCountry?.code == country.code;

    return InkWell(
      onTap: () => _onCountrySelected(country),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildFlagImage(country),
            const SizedBox(width: 6),
            _buildCountryCode(country.code),
            const Spacer(),
            if (isSelected) _buildCheckIcon(),
          ],
        ),
      ),
    );
  }

  Widget _buildFlagImage(CountryInfo country) {
    return Container(
      width: 26,
      height: 20,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Colors.grey[200],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: country.customFlagPath != null
            ? Image.asset(
                country.customFlagPath!,
                width: 26,
                height: 20,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.flag, size: 12, color: Colors.grey),
                ),
              )
            : Image.asset(
                country.flagPath,
                package: 'country_icons',
                width: 26,
                height: 20,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.flag, size: 12, color: Colors.grey),
                ),
              ),
      ),
    );
  }

  Widget _buildCountryCode(String code) {
    return Text(code, style: AppFonts.mdMedium(context, color: AppColors.text));
  }

  Widget _buildCheckIcon() {
    return const Icon(Icons.check, size: 16, color: AppColors.text);
  }

  Widget _buildCountrySelector() {
    if (_selectedCountry == null) {
      return SizedBox(
        width: 100,
        height: 40,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }

    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        key: _buttonKey,
        onTap: _toggleDropdown,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: widget.mode == PhoneInputMode.auth
                ? Colors.white
                : AppColors.gray_bg_2,
            borderRadius: BorderRadius.circular(13),
            border: Border.all(
              color: AppColors.border_2,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildFlagImage(_selectedCountry!),
              const SizedBox(width: 6),
              _buildCountryCode(_selectedCountry!.code),
              const SizedBox(width: 4),
              Icon(
                _isDropdownOpen
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                size: 14,
                color: AppColors.text,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneInput() {
    final languageService = Provider.of<LanguageService>(context);
    return Expanded(
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        keyboardType: TextInputType.phone,
        textInputAction: TextInputAction.done,
        autofocus: false,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(9),
          _PhoneNumberFormatter(),
        ],
        style: AppFonts.mdMedium(context, color: AppColors.black),
        decoration: InputDecoration(
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          hintText: widget.mode == PhoneInputMode.auth
              ? languageService.getText('phoneHint')
              : '12 123 1234',
          hintStyle: AppFonts.mdMedium(
            context,
            color: AppColors.black.withOpacity(0.5),
          ),
          contentPadding: EdgeInsets.zero,
          isDense: true,
        ),
      ),
    );
  }

  Widget _buildRightSection() {
    if (widget.mode == PhoneInputMode.auth) {
      return _buildAuthClearButton();
    } else {
      return _buildAccountRightSection();
    }
  }

  Widget _buildAuthClearButton() {
    if (_controller.text.isEmpty) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () {
        _controller.clear();
        widget.onPhoneChanged('');
      },
      child: Container(
        width: 20,
        height: 20,
        decoration:
            const BoxDecoration(color: AppColors.text, shape: BoxShape.circle),
        child: const Icon(Icons.close, size: 10, color: Colors.white),
      ),
    );
  }

  Widget _buildAccountRightSection() {
    if (_controller.text.isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildClearButton(),
        const SizedBox(width: 8),
        widget.isVerified ? _buildVerifiedStatus() : _buildVerifyButton(),
      ],
    );
  }

  Widget _buildClearButton() {
    return GestureDetector(
      onTap: () {
        _controller.clear();
        setState(() {
          _hasBeenEdited = true;
        });
        widget.onPhoneChanged('');
      },
      child: Container(
        width: 20,
        height: 20,
        decoration: const BoxDecoration(
          color: AppColors.text,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.close,
          size: 10,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildVerifyButton() {
    return GestureDetector(
      onTap: _onVerifyPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          'Verify',
          style: AppFonts.smSemiBold(context, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildVerifiedStatus() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.success_500.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.success_500, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            'assets/icons/circle-check.svg',
            width: 15,
            height: 15,
            colorFilter: const ColorFilter.mode(
              AppColors.success_500,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 1.5),
          Text(
            'Verified',
            style: AppFonts.smSemiBold(context, color: Colors.green),
          ),
        ],
      ),
    );
  }

  void _onVerifyPressed() async {
    if (_isVerifying) return;

    final fullPhoneNumber = '${_selectedCountry!.code}${_controller.text.replaceAll(' ', '')}';
    
    if (_controller.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a phone number")),
      );
      return;
    }

    setState(() {
      _isVerifying = true;
    });

    try {
      // Get user ID from storage or service
      final userId = await StorageService.get('user_id');
      if (userId == null) {
        throw Exception('User ID not found');
      }

      print('Requesting OTP for mobile number change: $fullPhoneNumber');
      
      // Step 1: Request OTP for mobile number change
      final requestDto = ChangeMobileNumberDto(mobileNumber: fullPhoneNumber);
      final response = await _authService.requestChangeMobileNumber(userId, requestDto);

      print('Request OTP response: ${response.success}, message: ${response.message}');

      if (response.success) {
        // Step 2: Show OTP popup and pass userId for verification
        if (mounted) {
          showOtpPopup(
            context, 
            fullPhoneNumber, 
            () {
              // This callback will be called when OTP is verified successfully
              widget.onVerified?.call();
            },
            userId: userId, // Pass userId to OTP popup
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.message ?? 'Failed to send OTP')),
          );
        }
      }
    } catch (e) {
      print('Error in _onVerifyPressed: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isVerifying = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7.5),
      decoration: BoxDecoration(
        color: widget.mode == PhoneInputMode.auth
            ? AppColors.gray_bg_2
            : AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border_2, width: 1),
      ),
      child: Row(
        children: [
          _buildCountrySelector(),
          const SizedBox(width: 10),
          _buildPhoneInput(),
          _buildRightSection(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    if (widget.controller == null) _controller.dispose();
    _closeDropdown();
    super.dispose();
  }
}

class _PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;

    if (text.length <= 2) {
      return newValue;
    } else if (text.length <= 5) {
      final formatted = '${text.substring(0, 2)} ${text.substring(2)}';
      return _createFormattedValue(formatted);
    } else if (text.length <= 9) {
      final formatted =
          '${text.substring(0, 2)} ${text.substring(2, 5)} ${text.substring(5)}';
      return _createFormattedValue(formatted);
    } else {
      final formatted =
          '${text.substring(0, 2)} ${text.substring(2, 5)} ${text.substring(5, 9)}';
      return _createFormattedValue(formatted);
    }
  }

  TextEditingValue _createFormattedValue(String formatted) {
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
