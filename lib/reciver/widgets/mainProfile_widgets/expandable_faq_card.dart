// lib/reciver/auth/widgets/faq_widgets/expandable_faq_card.dart
import 'package:flutter/material.dart';
import 'package:tipme_app/utils/app_font.dart';
import 'package:tipme_app/utils/colors.dart';

class ExpandableFAQCard extends StatefulWidget {
  final String question;
  final String answer;
  final TextStyle? questionStyle;
  final TextStyle? answerStyle;

  const ExpandableFAQCard({
    Key? key,
    required this.question,
    required this.answer,
    this.questionStyle,
    this.answerStyle,
  }) : super(key: key);

  @override
  State<ExpandableFAQCard> createState() => _ExpandableFAQCardState();
}

class _ExpandableFAQCardState extends State<ExpandableFAQCard>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Use provided styles or fall back to default AppFonts styles
    final questionStyle = widget.questionStyle ??
        AppFonts.mdBold(context, color: AppColors.black);

    final answerStyle =
        widget.answerStyle ?? AppFonts.smMedium(context, color: AppColors.text);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE9ECEF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: _toggleExpansion,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.question,
                      style: questionStyle, // Use the resolved style
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedRotation(
                    duration: const Duration(milliseconds: 300),
                    turns: _isExpanded ? 0 : 0,
                    child: Icon(
                      _isExpanded ? Icons.remove : Icons.add,
                      color: AppColors.black,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizeTransition(
            sizeFactor: _expandAnimation,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: 16,
              ),
              child: Text(
                widget.answer,
                style: answerStyle, // Use the resolved style
              ),
            ),
          ),
        ],
      ),
    );
  }
}
