//lib/reciver/auth/widgets/tips_chart_widget.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tipme_app/data/services/language_service.dart';
import 'package:tipme_app/utils/app_font.dart';
import 'package:tipme_app/utils/colors.dart';
import 'package:tipme_app/viewModels/chartData.dart';

class TipsChartWidget extends StatelessWidget {
  final String totalAmount;
  final List<ChartData> chartData;
  final DateTimeRange? selectedDateRange;

  const TipsChartWidget({
    Key? key,
    required this.totalAmount,
    required this.chartData,
    this.selectedDateRange,
  }) : super(key: key);

  List<String> _getDynamicDayLabels(LanguageService languageService) {
    if (selectedDateRange != null) {
      List<String> dayLabels = [];
      DateTime current = selectedDateRange!.start;
      final end = selectedDateRange!.end;

      while (current.isBefore(end) || current.isAtSameMomentAs(end)) {
        final dayKeys = ['sun', 'mon', 'tue', 'wed', 'thu', 'fri', 'sat'];
        dayLabels.add(languageService.getText(dayKeys[current.weekday % 7]));
        current = current.add(const Duration(days: 1));

        if (dayLabels.length >= 7) break;
      }

      return dayLabels;
    }

    final dayMapping = {
      'Sun': 'sun',
      'Mon': 'mon',
      'Tue': 'tue',
      'Wed': 'wed',
      'Thu': 'thu',
      'Fri': 'fri',
      'Sat': 'sat',
    };

    return chartData.map((data) {
      final dayKey = dayMapping[data.day] ?? 'sun';
      return languageService.getText(dayKey);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final languageService = Provider.of<LanguageService>(context);
    final maxValue =
        chartData.map((e) => e.value).reduce((a, b) => a > b ? a : b);
    final dayLabels = _getDynamicDayLabels(languageService);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border_2),
        boxShadow: [
          BoxShadow(
            color: const Color(0x00000008).withOpacity(0.031),
            offset: const Offset(0, 10),
            blurRadius: 15,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            totalAmount,
            style: AppFonts.h4(context, color: AppColors.secondary),
          ),
          Column(
            children: [
              SizedBox(
                height: 160,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: chartData
                      .map((data) => _buildBar(data, maxValue))
                      .toList(),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: dayLabels
                    .map((day) => Text(
                          day,
                          style:
                              AppFonts.xsMedium(context, color: AppColors.text),
                        ))
                    .toList(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBar(ChartData data, double maxValue) {
    final barHeight = (data.value / maxValue) * 120;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (data.value > 0) ...[
          Text(
            data.value.toInt().toString(),
            style: AppFonts.smMedium(null, color: AppColors.text),
          ),
          const SizedBox(height: 4),
        ],
        Container(
          width: 24,
          height: barHeight > 0 ? barHeight : 8,
          decoration: BoxDecoration(
            color: AppColors.secondary,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }
}

