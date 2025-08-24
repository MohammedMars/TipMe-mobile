import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tipme_app/utils/colors.dart';

class NavItem extends StatelessWidget {
  final IconData? icon;
  final String? assetPath;
  final String label;
  final bool active;
  final bool colored;

  const NavItem({
    Key? key,
    this.icon,
    this.assetPath,
    required this.label,
    this.active = false,
    this.colored = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color color = active ? AppColors.primary : AppColors.text;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildIcon(color),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: color,
            fontWeight: active ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildIcon(Color color) {
    if (icon != null) {
      return Icon(icon, color: colored ? color : null);
    }

    if (assetPath != null) {
      if (assetPath!.endsWith(".svg")) {
        return SvgPicture.asset(
          assetPath!,
          width: 24,
          height: 24,
          colorFilter: colored ? ColorFilter.mode(color, BlendMode.srcIn) : null,
        );
      }
      return Image.asset(
        assetPath!,
        width: 24,
        height: 24,
        fit: BoxFit.contain,
        color: colored ? color : null,
      );
    }

    return const SizedBox();
  }
}