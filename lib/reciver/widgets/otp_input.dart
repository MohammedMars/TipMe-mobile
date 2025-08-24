import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tipme_app/utils/app_font.dart';
import '../../utils/colors.dart';
import '../../data/services/language_service.dart';

class OtpInput extends StatefulWidget {
  final int length;
  final Function(String) onOtpChanged;
  final String otpCode;
  final VoidCallback? onTimerExpired;

  const OtpInput({
    Key? key,
    required this.length,
    required this.onOtpChanged,
    required this.otpCode,
    this.onTimerExpired,
  }) : super(key: key);

  @override
  State<OtpInput> createState() => OtpInputState();
}

class OtpInputState extends State<OtpInput> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  String _displayText = '';

  Timer? _timer;
  int _remainingSeconds = 120;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();

    if (widget.otpCode.isNotEmpty) {
      _displayText = widget.otpCode;
      _controller.text = widget.otpCode;
    }

    _controller.addListener(_onTextChanged);

    _focusNode.addListener(() {
      setState(() {});
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });

    // for debugging, print to see hidden text field value
    _controller.addListener(() {
      print('Hidden TextField value: "${_controller.text}"');
    });

    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        timer.cancel();
        if (widget.onTimerExpired != null) {
          widget.onTimerExpired!();
        }
      }
    });
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _onTextChanged() {
    final newText = _controller.text;

    final cleanText = newText.replaceAll(RegExp(r'[^0-9]'), '');

    // Handle paste action when a complete OTP is pasted
    if (cleanText.length == widget.length) {
      setState(() {
        _displayText = cleanText;
      });
      widget.onOtpChanged(cleanText);
      _controller.value = TextEditingValue(
        text: cleanText,
        selection: TextSelection.fromPosition(
          TextPosition(offset: cleanText.length),
        ),
      );
      return;
    }

    if (cleanText.length <= widget.length) {
      if (cleanText != _displayText) {
        setState(() {
          _displayText = cleanText;
        });
        widget.onOtpChanged(cleanText);
      }

      if (cleanText != newText) {
        _controller.value = TextEditingValue(
          text: cleanText,
          selection: TextSelection.fromPosition(
            TextPosition(offset: cleanText.length),
          ),
        );
      }
    } else {
      _controller.value = TextEditingValue(
        text: _displayText,
        selection: TextSelection.fromPosition(
          TextPosition(offset: _displayText.length),
        ),
      );
    }
  }

  @override
  void didUpdateWidget(OtpInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.otpCode != widget.otpCode) {
      _displayText = widget.otpCode;
      _controller.text = widget.otpCode;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onBoxTapped() {
    if (!_focusNode.hasFocus) {
      _focusNode.requestFocus();
    }

    Future.delayed(const Duration(milliseconds: 50), () {
      if (mounted) {
        _controller.selection = TextSelection.fromPosition(
          TextPosition(offset: _displayText.length),
        );
      }
    });
  }

  // Make this method public so it can be called from parent widget
  void restartTimer() {
    _timer?.cancel();
    setState(() {
      _remainingSeconds = 120;
    });
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    final languageService = Provider.of<LanguageService>(context);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              languageService.getText('enterOtp'),
              style: AppFonts.mdBold(context, color: AppColors.black),
            ),
            Text(
              _formatTime(_remainingSeconds),
              style: AppFonts.mdMedium(context,
                  color: _remainingSeconds <= 30
                      ? AppColors.danger_500
                      : AppColors.info_500),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Stack(
          children: [
            GestureDetector(
              onTap: _onBoxTapped,
              child: Container(
                child: _buildResponsiveOtpBoxes(),
              ),
            ),
            Positioned(
              left: -9999,
              child: SizedBox(
                width: 1,
                height: 1,
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(widget.length),
                  ],
                  style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 1,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  showCursor: false,
                  enableInteractiveSelection: false,
                  autocorrect: false,
                  enableSuggestions: false,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildResponsiveOtpBoxes() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;

        const spacing = 8.0;

        final totalSpacing = spacing * (widget.length - 1);

        final boxWidth = (availableWidth - totalSpacing) / widget.length;

        final finalBoxWidth = boxWidth.clamp(40.0, 47.0);

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            widget.length,
            (index) => Container(
              margin: EdgeInsets.only(
                right: index < widget.length - 1 ? spacing : 0,
              ),
              child: _buildOtpBox(index, finalBoxWidth),
            ),
          ),
        );
      },
    );
  }

  Widget _buildOtpBox(int index, double width) {
    final hasValue = index < _displayText.length;
    final isActive = index == _displayText.length && _focusNode.hasFocus;
    final value = hasValue ? _displayText[index] : '';

    return Container(
      width: width,
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.gray_bg_2,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isActive ? AppColors.info_500 : AppColors.border_2,
          width: isActive ? 2 : 1,
        ),
      ),
      child: Center(
        child: Text(
          value,
          style: AppFonts.mdMedium(context,
              color: hasValue ? AppColors.black : AppColors.text),
        ),
      ),
    );
  }
}
