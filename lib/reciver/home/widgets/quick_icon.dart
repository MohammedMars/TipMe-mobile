import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tipme_app/utils/colors.dart';

class QuickIcon extends StatelessWidget {
  final IconData? icon;
  final String? assetPath;
  final String label;
  final bool colored;
  final VoidCallback? onTap;

  const QuickIcon({
    Key? key,
    this.icon,
    this.assetPath,
    required this.label,
    this.colored = true,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color color = AppColors.white;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.text.withOpacity(0.8), // أغمق شوي
          shape: BoxShape.circle,
        ),
        child: Center(child: _buildIcon(color)),
      ),
    );
  }

  Widget _buildIcon(Color color) {
    if (icon != null) {
      return Icon(icon, size: 22, color: colored ? color : null);
    }

    if (assetPath != null) {
      if (assetPath!.endsWith(".svg")) {
        return SvgPicture.asset(
          assetPath!,
          width: 22,
          height: 22,
          colorFilter:
              colored ? ColorFilter.mode(color, BlendMode.srcIn) : null,
        );
      }
      return Image.asset(
        assetPath!,
        width: 22,
        height: 22,
        fit: BoxFit.contain,
        color: colored ? color : null,
      );
    }

    return const SizedBox();
  }
}
