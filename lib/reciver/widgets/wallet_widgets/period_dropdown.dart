//lib/reciver/auth/widgets/period_dropdown.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tipme_app/data/services/language_service.dart';
import 'package:tipme_app/utils/app_font.dart';
import 'package:tipme_app/utils/colors.dart';

class PeriodDropdown extends StatefulWidget {
  final String selectedPeriod;
  final Function(String) onPeriodChanged;
  final Function(DateTimeRange?)? onDateRangeSelected;

  const PeriodDropdown({
    Key? key,
    required this.selectedPeriod,
    required this.onPeriodChanged,
    this.onDateRangeSelected,
  }) : super(key: key);

  @override
  State<PeriodDropdown> createState() => _PeriodDropdownState();
}

class _PeriodDropdownState extends State<PeriodDropdown> {
  bool _isDropdownOpen = false;
  final GlobalKey _dropdownKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  final List<String> _periods = ['Last week', 'Specific date'];

  void _toggleDropdown() {
    if (_isDropdownOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    final languageService =
        Provider.of<LanguageService>(context, listen: false);
    final RenderBox renderBox =
        _dropdownKey.currentContext!.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final position = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: _closeDropdown,
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            Positioned(
              left: position.dx,
              top: position.dy + size.height + 4,
              width: size.width,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border_2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: _periods.asMap().entries.map((entry) {
                      int index = entry.key;
                      String period = entry.value;

                      String localizedPeriod;
                      if (period == 'Last week') {
                        localizedPeriod = languageService.getText('lastWeek');
                      } else if (period == 'Specific date') {
                        localizedPeriod =
                            languageService.getText('specificDate');
                      } else {
                        localizedPeriod = period;
                      }

                      return SizedBox(
                        width: double.infinity,
                        child: InkWell(
                          onTap: () => _selectPeriod(period),
                          borderRadius: index == 0
                              ? const BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  topRight: Radius.circular(8),
                                )
                              : index == _periods.length - 1
                                  ? const BorderRadius.only(
                                      bottomLeft: Radius.circular(8),
                                      bottomRight: Radius.circular(8),
                                    )
                                  : null,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              border: index < _periods.length - 1
                                  ? const Border(
                                      bottom: BorderSide(
                                        color: AppColors.border_2,
                                      ),
                                    )
                                  : null,
                            ),
                            child: Text(
                              localizedPeriod,
                              style: AppFonts.smMedium(
                                context,
                                color: period == widget.selectedPeriod
                                    ? AppColors.primary
                                    : Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    setState(() {
      _isDropdownOpen = true;
    });
  }

  void _closeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() {
      _isDropdownOpen = false;
    });
  }

  void _selectPeriod(String period) async {
    _closeDropdown();

    if (period == 'Specific date') {
      final DateTimeRange? picked = await showDateRangePicker(
        context: context,
        firstDate: DateTime.now().subtract(const Duration(days: 365)),
        lastDate: DateTime.now(),
        initialDateRange: DateTimeRange(
          start: DateTime.now().subtract(const Duration(days: 7)),
          end: DateTime.now(),
        ),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: Theme.of(context).colorScheme.copyWith(
                    primary: AppColors.primary,
                  ),
            ),
            child: child!,
          );
        },
      );

      if (picked != null) {
        final adjustedEnd = picked.start.add(const Duration(days: 6));
        final finalEnd =
            picked.end.isBefore(adjustedEnd) ? adjustedEnd : picked.end;

        final adjustedRange = DateTimeRange(
          start: picked.start,
          end: finalEnd,
        );

        widget.onDateRangeSelected?.call(adjustedRange);
        widget.onPeriodChanged(period);
      }
    } else {
      widget.onDateRangeSelected?.call(null);
      widget.onPeriodChanged(period);
    }
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final languageService = Provider.of<LanguageService>(context);

    String displayText;
    if (widget.selectedPeriod == 'Last week') {
      displayText = languageService.getText('lastWeek');
    } else if (widget.selectedPeriod == 'Specific date') {
      displayText = languageService.getText('specificDate');
    } else {
      displayText = widget.selectedPeriod;
    }

    return GestureDetector(
      key: _dropdownKey,
      onTap: _toggleDropdown,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              displayText,
              style: AppFonts.smMedium(context, color: Colors.black87),
            ),
            const SizedBox(width: 8),
            Icon(
              _isDropdownOpen
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down,
              size: 16,
              color: Colors.black87,
            ),
          ],
        ),
      ),
    );
  }
}
