//lib\reciver\widgets\mainProfile_widgets\contact_support_bottom.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:tipme_app/core/dio/client/dio_client.dart';
import 'package:tipme_app/di/gitIt.dart';
import 'package:tipme_app/reciver/screens/mainProfile/help_support_page.dart';
import 'package:tipme_app/reciver/widgets/mainProfile_widgets/custom_list_card.dart';
import 'package:tipme_app/services/appSettingsService.dart';
import 'package:tipme_app/viewModels/apiResponse.dart';
import 'package:tipme_app/viewModels/contactSupportData.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tipme_app/utils/app_font.dart';
import 'package:tipme_app/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:tipme_app/data/services/language_service.dart';

class ContactSupportBottomSheet extends StatefulWidget {
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
  State<ContactSupportBottomSheet> createState() =>
      _ContactSupportBottomSheetState();
}

class _ContactSupportBottomSheetState extends State<ContactSupportBottomSheet> {
  late final AppSettingsService _appSettingsService;
  Future<ApiResponse<ContactSupportData>?>? _contactSupportFuture;

  @override
  void initState() {
    super.initState();
    _appSettingsService =
        AppSettingsService(sl<DioClient>(instanceName: 'AppSettings'));
    _contactSupportFuture = _appSettingsService.getContactSupport();
  }

  @override
  Widget build(BuildContext context) {
    final languageService = Provider.of<LanguageService>(context);

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
          FutureBuilder<ApiResponse<ContactSupportData>?>(
            future: _contactSupportFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (snapshot.hasError ||
                  !snapshot.hasData ||
                  !snapshot.data!.success) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40.0),
                  child: Center(
                      child: Text(
                          languageService.getText('couldNotLoadContactInfo'))),
                );
              }

              final contactData = snapshot.data!.data!;

              return Column(
                children: [
                  _ContactCard(
                    title: languageService.getText('whatsAppUs'),
                    subtitle: languageService.getText('reachUsAnytime'),
                    backgroundColor: const Color(0xFF25D366),
                    iconPath: 'assets/icons/brand-whatsapp.svg',
                    onTap: () => _launchWhatsApp(contactData.whatsAppNumber),
                  ),
                  const SizedBox(height: 16),
                  _ContactCard(
                    title: contactData.phoneNumber,
                    subtitle: languageService.getText('forQuickHelpCall'),
                    backgroundColor: const Color(0xFF007AFF),
                    iconPath: 'assets/icons/phone-call.svg',
                    onTap: () => _makePhoneCall(contactData.phoneNumber),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  static Future<void> _launchWhatsApp(String phoneNumber) async {
    final languageService = GetIt.instance<LanguageService>();
    final message = languageService.getText('whatsAppSupportMessage');
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
    final languageService = Provider.of<LanguageService>(context);

    return CustomListCard(
      title: languageService.getText('contactSupport'),
      subtitle: languageService.getText('reachOutForHelp'),
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
