//lib/reciver/auth/widgets/phone_input.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../utils/colors.dart';
import '../../utils/app_font.dart';
import '../../data/services/language_service.dart';

class CountryInfo {
  final String nameKey;
  final String code;
  final String flagPath;

  const CountryInfo({
    required this.nameKey,
    required this.code,
    required this.flagPath,
  });
}

class CustomPhoneInput extends StatefulWidget {
  final Function(String) onPhoneChanged;
  final Function(String)? onCountryChanged;
  final String phoneNumber;
  final TextEditingController? controller;

  const CustomPhoneInput({
    Key? key,
    required this.onPhoneChanged,
    this.onCountryChanged,
    this.phoneNumber = '',
    this.controller,
  }) : super(key: key);

  @override
  State<CustomPhoneInput> createState() => _CustomPhoneInputState();
}

class _CustomPhoneInputState extends State<CustomPhoneInput> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  CountryInfo _selectedCountry = const CountryInfo(
    nameKey: 'unitedArabEmirates',
    code: '+971',
    flagPath: 'assets/images/uae.png',
  );

  final List<CountryInfo> _countries = [
    const CountryInfo(
      nameKey: 'unitedArabEmirates',
      code: '+971',
      flagPath: 'assets/images/uae.png',
    ),
    const CountryInfo(
      nameKey: 'unitedStates',
      code: '+1',
      flagPath: 'assets/images/us.png',
    ),
    const CountryInfo(
      nameKey: 'saudiArabia',
      code: '+966',
      flagPath: 'assets/images/sa.png',
    ),
  ];

  bool _isDropdownOpen = false;
  late OverlayEntry _overlayEntry;
  final GlobalKey _buttonKey = GlobalKey();
  double _dropdownWidth = 0;
  double _maxDropdownWidth = 0;

  @override
  void initState() {
    super.initState();
    _initializeController();
    _setupFocusNode();
    _addControllerListener();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculateMaxDropdownWidth();
    });
  }

  @override
  void dispose() {
    _disposeResources();
    super.dispose();
  }

  void _initializeController() {
    _controller = widget.controller ?? TextEditingController();
  }

  void _setupFocusNode() {
    _focusNode = FocusNode();
  }

  void _addControllerListener() {
    _controller.addListener(() {
      widget.onPhoneChanged(_controller.text);
    });
  }

  void _disposeResources() {
    _focusNode.dispose();
    if (widget.controller == null) {
      _controller.dispose();
    }
    if (_isDropdownOpen) {
      _overlayEntry.remove();
    }
  }

  void _calculateMaxDropdownWidth() {
    final textStyle = AppFonts.mdMedium(context, color: AppColors.text);
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    double maxWidth = 0;

    for (var country in _countries) {
      textPainter.text = TextSpan(
        text: '${country.code}   ',
        style: textStyle,
      );
      textPainter.layout();
      final textWidth = textPainter.width;

      // flag width (26) + spacing (6) + text width + spacing (4) + arrow (16) + padding (16)
      final totalWidth = 26 + 6 + textWidth + 4 + 16 + 16;
      if (totalWidth > maxWidth) {
        maxWidth = totalWidth;
      }
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
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry);
    setState(() {
      _isDropdownOpen = true;
    });
  }

  void _closeDropdown() {
    _overlayEntry.remove();
    setState(() {
      _isDropdownOpen = false;
    });
  }

  void _onCountrySelected(CountryInfo country) {
    setState(() {
      _selectedCountry = country;
    });
    widget.onCountryChanged?.call(country.code);
    _closeDropdown();
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox =
        _buttonKey.currentContext!.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + renderBox.size.height + 4,
        width: _dropdownWidth,
        child: Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(13),
          child: _buildDropdownContainer(),
        ),
      ),
    );
  }

  Widget _buildDropdownContainer() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: AppColors.border_2,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: _countries.map(_buildCountryItem).toList(),
      ),
    );
  }

  Widget _buildCountryItem(CountryInfo country) {
    final bool isSelected = _selectedCountry.code == country.code;

    return InkWell(
      onTap: () => _onCountrySelected(country),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildFlagImage(country.flagPath),
            const SizedBox(width: 6),
            _buildCountryCode(country.code),
            const Spacer(),
            if (isSelected) _buildCheckIcon(),
          ],
        ),
      ),
    );
  }

  Widget _buildFlagImage(String flagPath) {
    return Container(
      width: 26,
      height: 20,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Image.asset(
          flagPath,
          width: 26,
          height: 20,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[300],
              child: const Icon(
                Icons.flag,
                size: 12,
                color: Colors.grey,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCountryCode(String code) {
    return Text(code, style: AppFonts.mdMedium(context, color: AppColors.text));
  }

  Widget _buildCheckIcon() {
    return const Icon(
      Icons.check,
      size: 16,
      color: AppColors.text,
    );
  }

  Widget _buildCountrySelector() {
    return SizedBox(
      width: _maxDropdownWidth,
      child: GestureDetector(
        key: _buttonKey,
        onTap: _toggleDropdown,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(13),
            border: Border.all(
              color: AppColors.border_2,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildFlagImage(_selectedCountry.flagPath),
              const SizedBox(width: 6),
              _buildCountryCode(_selectedCountry.code),
              const SizedBox(width: 4),
              _buildDropdownArrow(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownArrow() {
    return Icon(
      _isDropdownOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
      size: 14,
      color: AppColors.text,
    );
  }

  Widget _buildPhoneInput() {
    final languageService = Provider.of<LanguageService>(context);

    return Expanded(
      child: GestureDetector(
        onTap: _onPhoneInputTapped,
        child: Container(
          alignment: Alignment.centerLeft,
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.done,
            autofocus: false,
            inputFormatters: _getInputFormatters(),
            style: _getInputTextStyle(),
            decoration: _getInputDecoration(languageService),
            onTap: _onTextFieldTapped,
          ),
        ),
      ),
    );
  }

  void _onPhoneInputTapped() {
    _focusNode.requestFocus();
    if (_isDropdownOpen) {
      _closeDropdown();
    }
  }

  void _onTextFieldTapped() {
    if (_isDropdownOpen) {
      _closeDropdown();
    }
  }

  List<TextInputFormatter> _getInputFormatters() {
    return [
      FilteringTextInputFormatter.digitsOnly,
      LengthLimitingTextInputFormatter(9), // Changed from 8 to 9
      _PhoneNumberFormatter(),
    ];
  }

  TextStyle _getInputTextStyle() {
    return AppFonts.mdMedium(context, color: AppColors.black);
  }

  InputDecoration _getInputDecoration(LanguageService languageService) {
    return InputDecoration(
      border: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      hintText: languageService.getText('phoneHint'),
      hintStyle:
          AppFonts.mdMedium(context, color: AppColors.black.withOpacity(0.5)),
      contentPadding: EdgeInsets.zero,
      isDense: true,
    );
  }

  Widget _buildClearButton() {
    if (_controller.text.isEmpty) return const SizedBox.shrink();

    return GestureDetector(
      onTap: _onClearButtonTapped,
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

  void _onClearButtonTapped() {
    _controller.clear();
    widget.onPhoneChanged('');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7.5),
      decoration: BoxDecoration(
        color: AppColors.gray_bg_2,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border_2,
          width: 1,
        ),
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
}

class _PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
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
