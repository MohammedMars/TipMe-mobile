// lib/reciver/screens/mainProfile/faq_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tipme_app/core/dio/client/dio_client.dart';
import 'package:tipme_app/di/gitIt.dart';
import 'package:tipme_app/reciver/widgets/mainProfile_widgets/expandable_faq_card.dart';
import 'package:tipme_app/reciver/widgets/wallet_widgets/custom_top_bar.dart';
import 'package:tipme_app/services/appSettingsService.dart';
import 'package:tipme_app/utils/app_font.dart';
import 'package:tipme_app/utils/colors.dart';
import 'package:tipme_app/data/services/language_service.dart';
import 'package:tipme_app/viewModels/faqData.dart';

class FAQPage extends StatefulWidget {
  const FAQPage({Key? key}) : super(key: key);

  @override
  _FAQPageState createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  late final AppSettingsService _appSettingsService;
  late Future<List<FAQData>> _faqFuture;

  @override
  void initState() {
    super.initState();
    _appSettingsService =
        AppSettingsService(sl<DioClient>(instanceName: 'AppSettings'));
    _loadFAQs();
  }

  void _loadFAQs() {
    setState(() {
      _faqFuture = _appSettingsService.getFAQ(lang: 'en').then((response) {
        if (response.success && response.data != null) {
          return response.data!;
        } else {
          throw Exception('No FAQs found');
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final languageService = Provider.of<LanguageService>(context);

    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: Column(
        children: [
          CustomTopBar.withTitle(
            title: Text(
              languageService.getText('faq'),
              style: AppFonts.lgBold(context, color: AppColors.white),
            ),
            leading: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
            showNotification: false,
            showProfile: false,
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: FutureBuilder<List<FAQData>>(
                future: _faqFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary, // Optional: match your theme
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            languageService.getText('noFaqsFound'),
                            style: AppFonts.mdMedium(context), // Apply font
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _loadFAQs,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                            ),
                            child: Text(
                              languageService.getText('retry'),
                              style: AppFonts.smMedium(context,
                                  color: AppColors.white),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text(
                        languageService.getText('noFaqsAvailable'),
                        style: AppFonts.mdMedium(context), // Apply font
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: snapshot.data!.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final faq = snapshot.data![index];
                      return ExpandableFAQCard(
                        question: faq.question,
                        answer: faq.answer,
                        // Apply font styles to the ExpandableFAQCard
                        questionStyle: AppFonts.mdSemiBold(context),
                        answerStyle: AppFonts.smRegular(context),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
