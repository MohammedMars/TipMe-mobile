// lib/reciver/screens/mainProfile/report_problem_page.dart
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:tipme_app/core/dio/client/dio_client.dart';
import 'package:tipme_app/core/storage/storage_service.dart';
import 'package:tipme_app/dtos/CreateSupportIssueDto.dart';
import 'package:tipme_app/enums/support_issue_type.dart';
import 'package:tipme_app/reciver/widgets/mainProfile_widgets/bottom_sheet.dart';
import 'package:tipme_app/reciver/widgets/mainProfile_widgets/custom_list_card.dart';
import 'package:tipme_app/reciver/widgets/wallet_widgets/custom_top_bar.dart';
import 'package:tipme_app/reciver/widgets/custom_button.dart';
import 'package:tipme_app/services/supportIssueService.dart';
import 'package:tipme_app/utils/app_font.dart';
import 'package:tipme_app/utils/colors.dart';
import 'package:tipme_app/data/services/language_service.dart';

class ReportProblemPage extends StatefulWidget {
  const ReportProblemPage({Key? key}) : super(key: key);

  @override
  State<ReportProblemPage> createState() => _ReportProblemPageState();
}

class _ReportProblemPageState extends State<ReportProblemPage> {
  SupportIssueType selectedProblem = SupportIssueType.BankAccount;
  final TextEditingController _problemController = TextEditingController();
  late final SupportIssueService _supportIssueService;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _supportIssueService =
        SupportIssueService(GetIt.instance<DioClient>(instanceName: 'SupportIssue'));
  }

  @override
  void dispose() {
    _problemController.dispose();
    super.dispose();
  }

  void _submitTicket() async {
    // Validate input
    if (_problemController.text.trim().isEmpty) {
      // Show error message if description is empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please describe the problem'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final userId = await StorageService.get('user_id');
      if (userId == null) {
        throw Exception('User not logged in');
      }

      final dto = CreateSupportIssueDto(
        tipReceiverId: userId,
        issueType: selectedProblem,
        description: _problemController.text,
      );

      final response = await _supportIssueService.createSupportIssue(dto);

      if (response != null && response.success) {
        SuccessBottomSheet.show(
          context,
          titleKey: 'Submit Successfully',
          descriptionKey:
              'Thank you for reporting the issue! Our team will review it and get back to you soon.',
          primaryButtonTextKey: 'Report New Issue',
          secondaryButtonTextKey: 'Close',
          icon: Icons.check,
          iconColor: AppColors.success,
          iconBackgroundColor: AppColors.white,
          primaryButtonColor: AppColors.primary,
          primaryButtonTextColor: AppColors.white,
          secondaryButtonBorderColor: AppColors.secondary,
          secondaryButtonTextColor: AppColors.secondary,
          onPrimaryButtonPressed: () {
            Navigator.pop(context);
            setState(() {
              selectedProblem = SupportIssueType.BankAccount;
              _problemController.clear();
            });
          },
          onSecondaryButtonPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
        );
      } else {
        throw Exception('Failed to create support issue');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageService = Provider.of<LanguageService>(context);

    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: SafeArea(
        child: Column(
          children: [
            CustomTopBar.withTitle(
              title: Text(
                'Report a Problem',
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
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomListCard(
                                title: 'Payment',
                                subtitle:
                                    'Issues with charges, refunds, or payments.',
                                iconPath: 'assets/icons/cach.svg',
                                iconColor: AppColors.secondary_500,
                                iconBackgroundColor:
                                    AppColors.secondary_500.withOpacity(0.1),
                                borderType: CardBorderType.all,
                                borderRadius: 16.0,
                                borderColor: selectedProblem == SupportIssueType.Payment
                                    ? AppColors.primary
                                    : AppColors.border_2,
                                backgroundColor: selectedProblem == SupportIssueType.Payment
                                    ? AppColors.primary.withOpacity(0.1)
                                    : Colors.transparent,
                                trailingType: TrailingType.radio,
                                isSelected: selectedProblem == SupportIssueType.Payment,
                                onTap: () {
                                  setState(() {
                                    selectedProblem = SupportIssueType.Payment;
                                  });
                                },
                                padding: const EdgeInsets.all(16),
                              ),
                              const SizedBox(height: 16),
                              CustomListCard(
                                title: 'Bank Account',
                                subtitle:
                                    'Problems related to your bank accounts.',
                                iconPath: 'assets/icons/calender-time.svg',
                                iconColor: AppColors.secondary_500,
                                iconBackgroundColor:
                                    AppColors.secondary_500.withOpacity(0.1),
                                borderType: CardBorderType.all,
                                borderRadius: 16.0,
                                borderColor: selectedProblem == SupportIssueType.BankAccount
                                    ? AppColors.primary
                                    : AppColors.border_2,
                                backgroundColor:
                                    selectedProblem == SupportIssueType.BankAccount
                                        ? AppColors.primary.withOpacity(0.1)
                                        : Colors.transparent,
                                trailingType: TrailingType.radio,
                                isSelected: selectedProblem == SupportIssueType.BankAccount,
                                onTap: () {
                                  setState(() {
                                    selectedProblem = SupportIssueType.BankAccount;
                                  });
                                },
                                padding: const EdgeInsets.all(16),
                              ),
                              const SizedBox(height: 16),
                              CustomListCard(
                                title: 'My Account',
                                subtitle:
                                    'Login, profile, or account-related concerns.',
                                iconPath: 'assets/icons/user.svg',
                                iconColor: AppColors.secondary_500,
                                iconBackgroundColor:
                                    AppColors.secondary_500.withOpacity(0.1),
                                borderType: CardBorderType.all,
                                borderRadius: 16.0,
                                borderColor: selectedProblem == SupportIssueType.Account
                                    ? AppColors.primary
                                    : AppColors.border_2,
                                backgroundColor: selectedProblem == SupportIssueType.Account
                                    ? AppColors.primary.withOpacity(0.1)
                                    : Colors.transparent,
                                trailingType: TrailingType.radio,
                                isSelected: selectedProblem == SupportIssueType.Account,
                                onTap: () {
                                  setState(() {
                                    selectedProblem = SupportIssueType.Account;
                                  });
                                },
                                padding: const EdgeInsets.all(16),
                              ),
                              const SizedBox(height: 16),
                              CustomListCard(
                                title: 'QR Code',
                                subtitle: 'Problems related to your QR Code.',
                                iconPath: 'assets/icons/steering-wheel.svg',
                                iconColor: AppColors.secondary_500,
                                iconBackgroundColor:
                                    AppColors.secondary_500.withOpacity(0.1),
                                borderType: CardBorderType.all,
                                borderRadius: 16.0,
                                borderColor: selectedProblem == SupportIssueType.QRCode
                                    ? AppColors.primary
                                    : AppColors.border_2,
                                backgroundColor: selectedProblem == SupportIssueType.QRCode
                                    ? AppColors.primary.withOpacity(0.1)
                                    : Colors.transparent,
                                trailingType: TrailingType.radio,
                                isSelected: selectedProblem == SupportIssueType.QRCode,
                                onTap: () {
                                  setState(() {
                                    selectedProblem = SupportIssueType.QRCode;
                                  });
                                },
                                padding: const EdgeInsets.all(16),
                              ),
                              const SizedBox(height: 16),
                              CustomListCard(
                                title: 'Report a Bug',
                                subtitle:
                                    'Found a technical issue or glitch? Tell us here.',
                                iconPath: 'assets/icons/bug.svg',
                                iconColor: AppColors.secondary_500,
                                iconBackgroundColor:
                                    AppColors.secondary_500.withOpacity(0.1),
                                borderType: CardBorderType.all,
                                borderRadius: 16.0,
                                borderColor: selectedProblem == SupportIssueType.Bug
                                    ? AppColors.primary
                                    : AppColors.border_2,
                                backgroundColor: selectedProblem == SupportIssueType.Bug
                                    ? AppColors.primary.withOpacity(0.1)
                                    : Colors.transparent,
                                trailingType: TrailingType.radio,
                                isSelected: selectedProblem == SupportIssueType.Bug,
                                onTap: () {
                                  setState(() {
                                    selectedProblem = SupportIssueType.Bug;
                                  });
                                },
                                padding: const EdgeInsets.all(16),
                              ),
                              const SizedBox(height: 32),
                              Text(
                                'Please Explain the Problem',
                                style: AppFonts.mdBold(context,
                                    color: AppColors.black),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.gray_bg_2,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: AppColors.border_2,
                                    width: 1,
                                  ),
                                ),
                                child: TextField(
                                  controller: _problemController,
                                  maxLines: 6,
                                  decoration: InputDecoration(
                                    hintText: 'Enter',
                                    hintStyle: AppFonts.mdRegular(
                                      context,
                                      color: const Color(0xFFADB5BD),
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.all(16),
                                  ),
                                  style: AppFonts.mdMedium(context,
                                      color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      CustomButton(
                        text: 'Submit Ticket',
                        onPressed: _submitTicket,
                        showArrow: true,
                        isLoading: _isLoading,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
