//lib\reciver\auth\screens\wallet\wallet.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:tipme_app/core/dio/client/dio_client.dart';
import 'package:tipme_app/di/gitIt.dart';
import 'package:tipme_app/reciver/screens/wallet/notification_screen.dart';
import 'package:tipme_app/reciver/widgets/custom_bottom_navigation.dart';
import 'package:tipme_app/reciver/widgets/wallet_widgets/available_balance_card.dart';
import 'package:tipme_app/reciver/widgets/wallet_widgets/bank_account_card.dart';
import 'package:tipme_app/reciver/widgets/wallet_widgets/custom_top_bar.dart';
import 'package:tipme_app/reciver/widgets/wallet_widgets/period_dropdown.dart';
import 'package:tipme_app/reciver/widgets/wallet_widgets/stat_card.dart';
import 'package:tipme_app/reciver/widgets/wallet_widgets/tips_chart_widget.dart';
import 'package:tipme_app/data/services/language_service.dart';
import 'package:tipme_app/services/tipReceiverStatisticsService.dart';
import 'package:tipme_app/utils/app_font.dart';
import 'package:tipme_app/utils/colors.dart';
import 'package:tipme_app/routs/app_routs.dart';
import 'package:tipme_app/services/tipReceiverService.dart';
import 'package:tipme_app/viewModels/chartData.dart';
import 'package:tipme_app/viewModels/tipReceiveerData.dart';
import 'package:tipme_app/viewModels/paymentInfoData.dart';
import 'package:tipme_app/viewModels/tipReceiverStatisticsData.dart';
import 'package:intl/intl.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final String _selectedStatsPeriod = 'Daily';
  String _selectedTipsPeriod = 'Last week';
  DateTimeRange? _selectedDateRange;
  final bool _showPendingVerification = false;
  final bool _showNotifications = true;
  int _currentBottomNavIndex = 1;

  // Services
  late TipReceiverService _tipReceiverService;
  late TipReceiverStatisticsService _statisticsService;

  // Data states
  TipReceiveerData? _tipReceiverData;
  PaymentInfoData? _paymentInfoData;
  TipReceiverStatisticsData? _statisticsData;
  bool _isLoading = true;
  bool _isLoadingChart = false;
  String? _errorMessage;

  // Chart data
  List<ChartData> _chartData = [];
  List<TipReceiverStatisticsData> _last7DaysStatistics = [];

  @override
  void initState() {
    super.initState();
    _initializeServices();
    _loadData();
  }

  void _initializeServices() {
    _tipReceiverService =
        TipReceiverService(sl<DioClient>(instanceName: 'TipReceiver'));
    _statisticsService =
        TipReceiverStatisticsService(sl<DioClient>(instanceName: 'Statistics'));
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Load all data in parallel
      await Future.wait([
        _loadTipReceiverData(),
        _loadPaymentInfo(),
        _loadStatistics(),
      ]);
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load data: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadTipReceiverData() async {
    final response = await _tipReceiverService.GetMe();
    if (response != null && response.success) {
      setState(() {
        _tipReceiverData = response.data;
      });
    }
  }

  Future<void> _loadPaymentInfo() async {
    final response = await _tipReceiverService.GetPaymentInfo();
    if (response.success) {
      setState(() {
        _paymentInfoData = response.data;
      });
    }
  }

  Future<void> _loadStatistics() async {
    try {
      final response = await _statisticsService.getTodayStatistics();

      if (response.success == true || response.data != null) {
        setState(() {
          _statisticsData = response.data;
        });
      }
      await _loadLast7DaysStatistics();
    } catch (e) {
      print('Error loading statistics: $e');
    }
  }

  Future<void> _loadLast7DaysStatistics() async {
    setState(() {
      _isLoadingChart = true;
    });

    try {
      final now = DateTime.now();
      final sevenDaysAgo = now.subtract(const Duration(days: 7));
      final response =
          await _statisticsService.getStatisticsBetween(sevenDaysAgo, now);
      if (response.success == true &&
          response.data != null &&
          response.data!.isNotEmpty) {
        setState(() {
          _last7DaysStatistics = response.data!;
          _updateChartData();
        });
      } else {
        print('No data received from API, creating empty chart data');
        _createEmptyChartData();
      }
    } catch (e) {
      print('Error loading last 7 days statistics: $e');
      _createEmptyChartData();
    } finally {
      setState(() {
        _isLoadingChart = false;
      });
    }
  }

  String _formatDateForApi(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  void _updateChartData() {
    final now = DateTime.now();
    final chartData = <ChartData>[];
    final dateToStatsMap = <String, TipReceiverStatisticsData>{};
    for (final stat in _last7DaysStatistics) {
      dateToStatsMap[stat.dateString ?? ''] = stat;
    }
    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      String onlyDate = DateFormat('yyyy-MM-dd').format(date);
      final stat = dateToStatsMap[onlyDate];
      final dayName = _getDayNameShortcut(date);
      final value = stat?.totalReceivedTips ?? 0.0;
      chartData.add(ChartData(day: dayName, value: value.toDouble()));
    }

    setState(() {
      _chartData = chartData;
    });
  }

  void _createEmptyChartData() {
    final now = DateTime.now();
    final chartData = <ChartData>[];

    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dayName = _getDayNameShortcut(date);

      chartData.add(ChartData(day: dayName, value: 0.0));
    }

    setState(() {
      _chartData = chartData;
    });
  }

  String _formatDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String _getDayNameShortcut(DateTime date) {
    return DateFormat.E().format(date); // Returns 'Mon', 'Tue', etc.
  }

  String get _formattedBalance {
    if (_statisticsData?.totalReceivedTips != null) {
      return 'SAR ${_statisticsData!.totalReceivedTips!.toStringAsFixed(2)}';
    }
    return 'SAR 0.00';
  }

  String get _formattedTotalReceived {
    if (_statisticsData != null) {
      return 'SAR ${_statisticsData!.totalReceivedTips.toStringAsFixed(2)}';
    }
    return 'SAR 0.00';
  }

  String get _formattedTotalRedeemed {
    if (_statisticsData != null) {
      return 'SAR ${_statisticsData!.totalRedeemed.toStringAsFixed(2)}';
    }
    return 'SAR 0.00';
  }

  String get _formattedTotalTips {
    if (_statisticsData != null) {
      return _statisticsData!.numberOfTotalTips.toString();
    }
    return '0';
  }

  String get _formattedAvgTip {
    if (_statisticsData?.avgTipValue != null) {
      return 'SAR ${_statisticsData!.avgTipValue!.toStringAsFixed(2)}';
    }
    return 'SAR 0.00';
  }

  String get _formattedMaxTip {
    if (_statisticsData?.maxTipValue != null) {
      return 'SAR ${_statisticsData!.maxTipValue!.toStringAsFixed(2)}';
    }
    return 'SAR 0.00';
  }

  String get _formattedMinTip {
    if (_statisticsData?.minTipValue != null) {
      return 'SAR ${_statisticsData!.minTipValue!.toStringAsFixed(2)}';
    }
    return 'SAR 0.00';
  }

  String get _formattedTotalChartAmount {
    if (_last7DaysStatistics.isNotEmpty) {
      final total = _last7DaysStatistics
          .map((stat) => stat.totalReceivedTips)
          .reduce((a, b) => a + b);
      return 'SAR ${total.toStringAsFixed(2)}';
    }
    return 'SAR 0.00';
  }

  @override
  Widget build(BuildContext context) {
    final languageService = Provider.of<LanguageService>(context);

    if (_isLoading) {
      return _buildLoadingScreen();
    }

    if (_errorMessage != null) {
      return _buildErrorScreen(languageService);
    }

    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                CustomTopBar.home(
                  profileImagePath: 'assets/images/bank.png',
                  onProfileTap: () {
                    Navigator.pushNamed(context, AppRoutes.profilePage);
                  },
                  onNotificationTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NotificationScreen(),
                      ),
                    );
                  },
                  showNotification: _showNotifications,
                ),
                const SizedBox(height: 122),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(24, 87, 24, 24),
                      child: Column(
                        children: [
                          _buildStatsSection(languageService),
                          const SizedBox(height: 32),
                          _buildTipsReceivedSection(languageService),
                          const SizedBox(height: 32),
                          _buildLinkedBankAccountSection(languageService),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Positioned(
              top: 120,
              left: 0,
              right: 0,
              child: AvailableBalanceCard(
                transferDate: 'Next Transfer Date: 20 July, 2025',
                backgroundImagePath: 'assets/images/available-balance.png',
                iconPath: 'assets/icons/logo-without-text.svg',
                helpTitleKey: 'myTransfers',
                helpParagraphKeys: ['transferScheduleDescription'],
                helpButtonTextKey: 'close',
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentBottomNavIndex,
        onTap: (index) {
          setState(() {
            _currentBottomNavIndex = index;
          });
          _handleBottomNavTap(index);
        },
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildErrorScreen(LanguageService languageService) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _errorMessage!,
              style: TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loadData,
              child: Text(languageService.getText('retry')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection(LanguageService languageService) {
    return Column(
      children: [
        _buildStatsHeader(languageService),
        const SizedBox(height: 24),
        _buildStatsGrid(languageService),
      ],
    );
  }

  Widget _buildStatsHeader(LanguageService languageService) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          languageService.getText('myStats'),
          style: AppFonts.mdBold(context, color: Colors.black),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                languageService.getText(_selectedStatsPeriod.toLowerCase()),
                style: AppFonts.smSemiBold(context, color: Colors.black87),
              ),
              const SizedBox(width: 4),
              SvgPicture.asset(
                'assets/images/caret-down.svg',
                width: 16,
                height: 16,
                colorFilter: const ColorFilter.mode(
                  AppColors.white,
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid(LanguageService languageService) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: StatCard(
                title: languageService.getText('totalReceived'),
                value: _formattedTotalReceived,
                backgroundColor: const Color(0xFF5AB267).withOpacity(0.1),
                valueColor: const Color(0xFF5AB267),
                iconPath: 'assets/icons/total-received.svg',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatCard(
                title: languageService.getText('totalRedeemed'),
                value: _formattedTotalRedeemed,
                backgroundColor: const Color(0xFFC909CC).withOpacity(0.1),
                valueColor: const Color(0xFFC909CC),
                iconPath: 'assets/icons/total-redeemed.svg',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: StatCard(
                title: languageService.getText('totalTips'),
                value: _formattedTotalTips,
                backgroundColor: const Color(0xFF6A88FF).withOpacity(0.1),
                valueColor: const Color(0xFF6A88FF),
                iconPath: 'assets/icons/total-tips.svg',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatCard(
                title: languageService.getText('avgTipValue'),
                value: _formattedAvgTip,
                backgroundColor: const Color(0xFFFE9022).withOpacity(0.1),
                valueColor: const Color(0xFFFE9022),
                iconPath: 'assets/icons/tip-value.svg',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: StatCard(
                title: languageService.getText('maxTipValue'),
                value: _formattedMaxTip,
                backgroundColor: const Color(0xFFDB0253).withOpacity(0.1),
                valueColor: const Color(0xFFDB0253),
                iconPath: 'assets/icons/max-tip-value.svg',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatCard(
                title: languageService.getText('minTipValue'),
                value: _formattedMinTip,
                backgroundColor: const Color(0xFF00BEC3).withOpacity(0.1),
                valueColor: const Color(0xFF00BEC3),
                iconPath: 'assets/icons/min-tip-value.svg',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTipsReceivedSection(LanguageService languageService) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              languageService.getText('tipsReceived'),
              style: AppFonts.mdBold(context, color: Colors.black),
            ),
            PeriodDropdown(
              selectedPeriod: _selectedTipsPeriod,
              onPeriodChanged: (period) {
                setState(() {
                  _selectedTipsPeriod = period;
                });
              },
              onDateRangeSelected: (dateRange) {
                setState(() {
                  _selectedDateRange = dateRange;
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
        _isLoadingChart
            ? Container(
                height: 200,
                child: Center(child: CircularProgressIndicator()),
              )
            : TipsChartWidget(
                totalAmount: _formattedTotalChartAmount,
                chartData: _chartData,
                selectedDateRange: _selectedDateRange,
              ),
      ],
    );
  }

  Widget _buildLinkedBankAccountSection(LanguageService languageService) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          languageService.getText('linkedBankAccount'),
          style: AppFonts.mdBold(context, color: Colors.black),
        ),
        const SizedBox(height: 16),
        Container(
          height: 1,
          color: const Color(0xFFE0E0E0),
        ),
        const SizedBox(height: 16),
        BankAccountCard(
          bankName: _paymentInfoData?.bankName ?? 'No bank linked',
          accountNumber: _paymentInfoData?.iban != null
              ? '${_paymentInfoData!.iban!.substring(0, 4)} **** **** ${_paymentInfoData!.iban!.substring(_paymentInfoData!.iban!.length - 4)}'
              : 'No account number',
          iconPath: 'assets/images/bank.png',
          showPendingVerification: _showPendingVerification,
          onTap: () {
            if (_paymentInfoData != null) {
              Navigator.pushNamed(
                context,
                AppRoutes.linkedBankAccount,
                arguments: {
                  'bankName': _paymentInfoData!.bankName,
                  'accountHolderName': _paymentInfoData!.accountHolderName,
                  'country': 'Country',
                  'iban': _paymentInfoData!.iban,
                  'bankIconPath': 'assets/images/bank.png',
                },
              );
            }
          },
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  void _handleBottomNavTap(int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, AppRoutes.logInQR);
        break;
      case 1:
        break;
      case 2:
        Navigator.pushNamed(context, AppRoutes.transactions);
        break;
    }
  }
}
