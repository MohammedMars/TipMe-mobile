import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tipme_app/reciver/screens/mainProfile/help_support_page.dart';
import 'package:tipme_app/reciver/widgets/mainProfile_widgets/custom_list_card.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tipme_app/utils/app_font.dart';
import 'package:tipme_app/utils/colors.dart';

class ContactSupportBottomSheet extends StatelessWidget {
  const ContactSupportBottomSheet({Key? key}) : super(key: key);

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const ContactSupportBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          _ContactCard(
            title: 'WhatsApp Us',
            subtitle: 'Reach us anytime for support.',
            backgroundColor: const Color(0xFF25D366),
            iconPath: 'assets/icons/brand-whatsapp.svg',
            onTap: () => _launchWhatsApp(),
          ),
          const SizedBox(height: 16),
          _ContactCard(
            title: '12 345 6789',
            subtitle: 'For quick help, give us a call.',
            backgroundColor: const Color(0xFF007AFF),
            iconPath: 'assets/icons/phone-call.svg',
            onTap: () => _makePhoneCall('1234567891'),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  static Future<void> _launchWhatsApp() async {
    const phoneNumber = '+1234567891';
    const message = 'Hello, I need support with TipMe app.';
    final uri = Uri.parse(
        'https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  static Future<void> _makePhoneCall(String phoneNumber) async {
    final uri = Uri.parse('tel:$phoneNumber');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}

class _ContactCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color backgroundColor;
  final String iconPath;
  final VoidCallback onTap;

  const _ContactCard({
    required this.title,
    required this.subtitle,
    required this.backgroundColor,
    required this.iconPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    iconPath,
                    width: 24,
                    height: 24,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subtitle,
                      style: AppFonts.smMedium(
                        context,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      title,
                      style: AppFonts.h3(
                        context,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              // Arrow icon
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension HelpSupportPageExtension on HelpSupportPage {
  static Widget buildUpdatedContactSupportCard(BuildContext context) {
    return CustomListCard(
      title: 'Contact Support',
      subtitle: 'Reach out for help or questions.',
      iconPath: 'assets/icons/headphones.svg',
      iconColor: AppColors.secondary_500,
      onTap: () {
        ContactSupportBottomSheet.show(context);
      },
      borderType: CardBorderType.bottom,
      borderRadius: 0.0,
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 16.0,
      ),
      trailingType: TrailingType.arrow,
    );
  }
}
