// lib/reciver/auth/widgets/phone_input.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tipme_app/core/dio/client/dio_client.dart';
import 'package:tipme_app/di/gitIt.dart';
import 'package:tipme_app/services/cacheService.dart';
import '../../utils/colors.dart';
import '../../utils/app_font.dart';
import '../../data/services/language_service.dart';

class CountryInfo {
  final String nameKey;
  final String code;
  final String countryCode;

  const CountryInfo({
    required this.nameKey,
    required this.code,
    required this.countryCode,
  });

  String get flagPath => 'icons/flags/png/$countryCode.png';
}

class CustomPhoneInput extends StatefulWidget {
  final Function(String) onPhoneChanged;
  final Function(String)? onCountryChanged;
  final String phoneNumber;
  final TextEditingController? controller;
  final bool isVerified;
  const CustomPhoneInput({
    Key? key,
    required this.onPhoneChanged,
    this.onCountryChanged,
    this.phoneNumber = '',
    this.controller,
    this.isVerified = false,
  }) : super(key: key);

  @override
  State<CustomPhoneInput> createState() => _CustomPhoneInputState();
}

class _CustomPhoneInputState extends State<CustomPhoneInput> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  final _cacheService =
      CacheService(sl<DioClient>(instanceName: 'CacheService'));

  CountryInfo? _selectedCountry;
  List<CountryInfo> _countries = [];

  bool _isDropdownOpen = false;
  OverlayEntry? _overlayEntry;
  final GlobalKey _buttonKey = GlobalKey();
  final LayerLink _layerLink = LayerLink();
  double _dropdownWidth = 0;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = FocusNode();

    _controller.addListener(() {
      widget.onPhoneChanged(_controller.text);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCountries();
    });
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
      if (_countries.isNotEmpty) _selectedCountry = _countries.first;
    });
    _calculateDropdownWidth();
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
        maxHeight: 200, // Limit dropdown height
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
        color: Colors.grey[200], // Fallback color
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Image.asset(
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
            color: Colors.white,
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: AppColors.border_2, width: 1),
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
          hintText: languageService.getText('phoneHint'),
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

  Widget _buildClearButton() {
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7.5),
      decoration: BoxDecoration(
        color: AppColors.gray_bg_2,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border_2, width: 1),
      ),
      child: Row(
        children: [
          _buildCountrySelector(),
          const SizedBox(width: 10),
          _buildPhoneInput(),
          _buildClearButton(),
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
