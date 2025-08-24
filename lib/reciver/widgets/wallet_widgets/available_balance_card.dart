// lib/reciver/auth/widgets/wallet_widgets/available_balance_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tipme_app/core/dio/client/dio_client.dart';
import 'package:tipme_app/di/gitIt.dart';
import 'package:tipme_app/reciver/widgets/iban_help_bottom_sheet.dart';
import 'package:tipme_app/services/tipReceiverService.dart';
import 'package:tipme_app/services/tipReceiverStatisticsService.dart';
import 'package:tipme_app/utils/app_font.dart';
import 'package:tipme_app/utils/colors.dart';

class AvailableBalanceCard extends StatefulWidget {
  final String transferDate;
  final String? backgroundImagePath;
  final String? iconPath;
  final String? helpTitleKey;
  final List<String>? helpParagraphKeys;
  final String? helpButtonTextKey;

  const AvailableBalanceCard(
      {Key? key,
      required this.transferDate,
      this.backgroundImagePath,
      this.iconPath,
      this.helpTitleKey,
      this.helpParagraphKeys,
      this.helpButtonTextKey})
      : super(key: key);

  @override
  State<AvailableBalanceCard> createState() => _AvailableBalanceCardState();
}

class _AvailableBalanceCardState extends State<AvailableBalanceCard> {
  String? balance;
  bool loading = true;
  late TipReceiverStatisticsService _statisticsService;
  var _currency = "SAR";
  @override
  void initState() {
    super.initState();
    _fetchBalance();
  }

  Future<void> _fetchBalance() async {
    try {
      _statisticsService = TipReceiverStatisticsService(
          sl<DioClient>(instanceName: 'Statistics')); // inject properly
      final response = await _statisticsService.getBalance();
      setState(() {
        balance = "${response.data["total"].toStringAsFixed(2)} $_currency";
        loading = false;
      });
    } catch (e) {
      setState(() {
        balance = "0.00";
        loading = false;
      });
    }
  }

  void _showHelpSheet(BuildContext context) {
    if (widget.helpTitleKey != null &&
        widget.helpParagraphKeys != null &&
        widget.helpButtonTextKey != null) {
      HelpBottomSheet.show(
        context,
        titleKey: widget.helpTitleKey!,
        paragraphKeys: widget.helpParagraphKeys!,
        buttonTextKey: widget.helpButtonTextKey!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: widget.backgroundImagePath != null
            ? DecorationImage(
                image: AssetImage(widget.backgroundImagePath!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: widget.iconPath != null
                      ? SvgPicture.asset(widget.iconPath!,
                          width: 30, height: 32)
                      : Container(width: 24, height: 24),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Available Balance',
                    style: AppFonts.mdMedium(context, color: AppColors.white),
                  ),
                  const SizedBox(height: 8),
                  loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          balance ?? "0.00",
                          style: AppFonts.h3(context, color: AppColors.white),
                        ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                widget.transferDate,
                style: AppFonts.smMedium(context, color: AppColors.white),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () => _showHelpSheet(context),
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/icons/info-circle.svg',
                      width: 10,
                      height: 10,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
