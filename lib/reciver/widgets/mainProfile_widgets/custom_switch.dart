// lib/reciver/auth/widgets/custom_switch.dart
import 'package:flutter/material.dart';
import 'package:tipme_app/utils/colors.dart';

class CustomSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Color? activeColor;
  final Color? activeTrackColor;
  final Color? inactiveThumbColor;
  final Color? inactiveTrackColor;

  const CustomSwitch({
    Key? key,
    required this.value,
    this.onChanged,
    this.activeColor,
    this.activeTrackColor,
    this.inactiveThumbColor,
    this.inactiveTrackColor,
  }) : super(key: key);

  @override
  State<CustomSwitch> createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    if (widget.value) {
      _animationController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(CustomSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      if (widget.value) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (widget.onChanged != null) {
      widget.onChanged!(!widget.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = widget.onChanged != null;
    final Color trackColor = widget.value
        ? (widget.activeTrackColor ?? AppColors.primary)
        : (widget.inactiveTrackColor ??
            (isEnabled ? Colors.grey[300]! : AppColors.gray_bg_2!));

    final Color thumbColor = widget.value
        ? (widget.activeColor ?? AppColors.white)
        : (widget.inactiveThumbColor ?? Colors.white);

    return GestureDetector(
      onTap: isEnabled ? _handleTap : null,
      child: SizedBox(
        width: 54,
        height: 30,
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: trackColor,
              ),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Align(
                  alignment: Alignment.lerp(
                    Alignment.centerLeft,
                    Alignment.centerRight,
                    _animation.value,
                  )!,
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: thumbColor,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
