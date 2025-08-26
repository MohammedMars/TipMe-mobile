//lib/reciver/screens/wallet/transactions_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tipme_app/core/dio/service/api-service_path.dart';
import 'package:tipme_app/core/storage/storage_service.dart';
import 'package:tipme_app/reciver/screens/wallet/notification_screen.dart';
import 'package:tipme_app/reciver/widgets/custom_bottom_navigation.dart';
import 'package:tipme_app/reciver/widgets/wallet_widgets/custom_switch_widget.dart';
import 'package:tipme_app/reciver/widgets/wallet_widgets/custom_top_bar.dart';
import 'package:tipme_app/reciver/widgets/wallet_widgets/transaction_card.dart';
import 'package:tipme_app/reciver/widgets/search_bar_widget.dart';
import 'package:tipme_app/data/services/language_service.dart';
import 'package:tipme_app/routs/app_routs.dart';
import 'package:tipme_app/utils/app_font.dart';
import 'package:tipme_app/utils/colors.dart';
import 'package:tipme_app/di/gitIt.dart';
import 'package:tipme_app/services/tipTransactionService.dart';
import 'package:tipme_app/services/tipReceiverService.dart';
import 'package:tipme_app/viewModels/transactionItem.dart';
import 'package:tipme_app/services/excelExportService.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({Key? key}) : super(key: key);

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  bool _isReceivedSelected = true;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Services
  late TipTransactionService _transactionService;
  late TipReceiverService _receiverService;

  // State
  List<TransactionItem> _allTransactions = [];
  bool _isLoading = true;
  String? _errorMessage;
  int _currentPage = 1;
  final int _pageSize = 10;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  var _currency;
  String? _profileImage;

  @override
  void initState() {
    super.initState();
    _transactionService = sl<TipTransactionService>();
    _receiverService = sl<TipReceiverService>();
    _loadTransactions();
    _initializeScreen();
    _loadProfileImage();
  }

  Future<void> _initializeScreen() async {
    _currency = await StorageService.get('Currency') ?? "";
  }

  Future<void> _loadProfileImage() async {
    final response = await _receiverService.GetMe();
    if (response != null && response.success && response.data != null) {
      setState(() {
        _profileImage = response.data!.imagePath != null &&
                response.data!.imagePath!.isNotEmpty
            ? "${ApiServicePath.fileServiceUrl}/${response.data!.imagePath}"
            : null;
      });
    }
  }

  Future<void> _loadTransactions({bool loadMore = false}) async {
    setState(() {
      if (loadMore) {
        _isLoadingMore = true;
      } else {
        _isLoading = true;
        _errorMessage = null;
      }
    });

    try {
      final response = await _transactionService.getTipTransactions(
        pageNumber: loadMore ? _currentPage + 1 : 1,
        pageSize: _pageSize,
      );

      if (response.success && response.data != null) {
        final items = (response.data!['items'] as List)
            .map((item) => TransactionItem.fromJson(item))
            .toList();
        setState(() {
          if (loadMore) {
            _allTransactions.addAll(items);
            _currentPage++;
          } else {
            _allTransactions = items;
            _currentPage = 1;
          }
          _hasMore = items.length == _pageSize;
        });
      } else {
        setState(() {
          _errorMessage = response.message;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
        _isLoadingMore = false;
      });
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  List<TransactionItem> get _filteredTransactions {
    List<TransactionItem> typeFiltered;
    if (!_isReceivedSelected) {
      typeFiltered = _allTransactions.where((t) => t.status == 2).toList();
    } else {
      typeFiltered = _allTransactions.where((t) => t.status != 2).toList();
    }
    if (_searchQuery.isEmpty) {
      return typeFiltered;
    }

    return typeFiltered
        .where((t) =>
            t.time.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            t.amount.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
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
                languageService.getText('transactions'),
                style: AppFonts.lgBold(context, color: AppColors.white),
              ),
              leading: GestureDetector(
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.profilePage),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: CircleAvatar(
                    backgroundImage: _profileImage != null
                        ? NetworkImage(_profileImage!)
                        : const AssetImage('assets/images/bank.png')
                            as ImageProvider,
                  ),
                ),
              ),
              trailing: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationScreen(),
                    ),
                  );
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/icons/bell.svg',
                      width: 20,
                      height: 20,
                      colorFilter: const ColorFilter.mode(
                        AppColors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: CustomSwitchWidget(
                leftText: languageService.getText('received'),
                rightText: languageService.getText('redeemed'),
                isLeftSelected: _isReceivedSelected,
                onToggle: (isLeft) {
                  setState(() {
                    _isReceivedSelected = isLeft;
                  });
                },
              ),
            ),
            const SizedBox(height: 32),
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
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            child: SearchBarWidget(
                              hintText: languageService.getText('search'),
                              controller: _searchController,
                              backgroundColor: AppColors.border_2,
                              textColor: AppColors.black,
                              hintTextColor: AppColors.text,
                              iconColor: AppColors.text,
                              prefixIconPath: 'assets/icons/search.svg',
                              showFilterIcon: false,
                              onChanged: _onSearchChanged,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppColors.border_2,
                                width: 1,
                              ),
                            ),
                            child: Center(
                              child: GestureDetector(
                                onTap: () async {
                                  await ExcelExportService
                                      .exportTransactionsToExcel(
                                    _filteredTransactions,
                                    _currency,
                                  );
                                },
                                child: SvgPicture.asset(
                                  'assets/icons/download.svg',
                                  width: 20,
                                  height: 20,
                                  colorFilter: const ColorFilter.mode(
                                    AppColors.black,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  languageService.getText('transaction'),
                                  style: AppFonts.smBold(context,
                                      color: AppColors.black),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  languageService.getText('amount'),
                                  style: AppFonts.smBold(context,
                                      color: AppColors.black),
                                  textAlign: TextAlign.end,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  languageService.getText('balance'),
                                  style: AppFonts.smBold(context,
                                      color: AppColors.black),
                                  textAlign: TextAlign.end,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: _isLoading && !_isLoadingMore
                          ? const Center(child: CircularProgressIndicator())
                          : _errorMessage != null
                              ? Center(child: Text(_errorMessage!))
                              : _filteredTransactions.isEmpty
                                  ? Center(
                                      child: Text(languageService
                                          .getText('noTransactionsFound')))
                                  : NotificationListener<ScrollNotification>(
                                      onNotification:
                                          (ScrollNotification scrollInfo) {
                                        if (!_isLoadingMore &&
                                            _hasMore &&
                                            scrollInfo.metrics.pixels ==
                                                scrollInfo
                                                    .metrics.maxScrollExtent) {
                                          _loadTransactions(loadMore: true);
                                        }
                                        return true;
                                      },
                                      child: ListView.builder(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                        itemCount:
                                            _filteredTransactions.length +
                                                (_isLoadingMore ? 1 : 0),
                                        itemBuilder: (context, index) {
                                          if (index <
                                              _filteredTransactions.length) {
                                            final transaction =
                                                _filteredTransactions[index];
                                            return TransactionCard(
                                              time: transaction.time,
                                              status: transaction.status,
                                              amount: transaction.amount,
                                              currency: _currency,
                                              balance: transaction.balance,
                                              isPositive:
                                                  transaction.isPositive,
                                              isPending: transaction.isPending,
                                            );
                                          } else {
                                            return const Padding(
                                              padding: EdgeInsets.all(16.0),
                                              child: Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 2, // Set to transactions tab (index 2)
        onTap: (index) {
          if (index == 2) return; // Already on transactions screen

          switch (index) {
            case 0:
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.logInQR, // Navigate to QR code screen
                (route) => false,
              );
              break;
            case 1:
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.walletScreen, // Navigate to wallet screen
                (route) => false,
              );
              break;
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
