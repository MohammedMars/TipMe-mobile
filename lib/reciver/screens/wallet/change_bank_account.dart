//lib/auth/screens/profile/change_bank_account_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tipme_app/reciver/screens/wallet/change_bank_account_details.dart';
import 'package:tipme_app/reciver/widgets/wallet_widgets/custom_top_bar.dart';
import 'package:tipme_app/utils/app_font.dart';
import '../../widgets/selectable_item_card.dart';
import '../../widgets/search_bar_widget.dart';
import '../../../data/services/language_service.dart';
import '../../../utils/colors.dart';

class ChangeBankAccountPage extends StatefulWidget {
  final String currentBankName;
  final String? currentBankIconPath;

  const ChangeBankAccountPage({
    Key? key,
    required this.currentBankName,
    this.currentBankIconPath,
  }) : super(key: key);

  @override
  State<ChangeBankAccountPage> createState() => _ChangeBankAccountPageState();
}

class _ChangeBankAccountPageState extends State<ChangeBankAccountPage> {
  String? _selectedCountry;
  String? _selectedBank;
  bool _showBanks = false;
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _preselectCurrentBank();
  }

  void _preselectCurrentBank() {
    final languageService =
        Provider.of<LanguageService>(context, listen: false);
    final countries = _getCountries(languageService);

    // to find the country that contains the current bank
    for (final country in countries) {
      final banks = List<Map<String, dynamic>>.from(country['banks']);
      final bankExists =
          banks.any((bank) => bank['name'] == widget.currentBankName);

      if (bankExists) {
        setState(() {
          _selectedCountry = country['name'];
          _selectedBank = widget.currentBankName;
          _showBanks = true;
        });
        break;
      }
    }
  }

  List<Map<String, dynamic>> _getCountries(LanguageService languageService) {
    return [
      {
        'name': languageService.getText('unitedArabEmiratesBank'),
        'nameKey': 'unitedArabEmiratesBank',
        'icon': 'assets/images/uae.png',
        'banks': [
          {
            'name': languageService.getText('firstAbuDhabiBank'),
            'nameKey': 'firstAbuDhabiBank',
            'icon': 'assets/images/bank.png'
          },
          {
            'name': languageService.getText('abuDhabiCommercialBank'),
            'nameKey': 'abuDhabiCommercialBank',
            'icon': 'assets/images/bank.png'
          },
          {
            'name': languageService.getText('dubaiIslamicBank'),
            'nameKey': 'dubaiIslamicBank',
            'icon': 'assets/images/bank.png'
          },
          {
            'name': languageService.getText('mashreqBank'),
            'nameKey': 'mashreqBank',
            'icon': 'assets/images/bank.png'
          },
          {
            'name': languageService.getText('standardCharteredUAE'),
            'nameKey': 'standardCharteredUAE',
            'icon': 'assets/images/bank.png'
          },
          {
            'name': languageService.getText('emiratesNBD'),
            'nameKey': 'emiratesNBD',
            'icon': 'assets/images/bank.png'
          },
        ],
      },
      {
        'name': languageService.getText('saudiArabiaBank'),
        'nameKey': 'saudiArabiaBank',
        'icon': 'assets/images/sa.png',
        'banks': [
          {
            'name': languageService.getText('saudiNationalBank'),
            'nameKey': 'saudiNationalBank',
            'icon': 'assets/images/bank.png'
          },
          {
            'name': languageService.getText('alRajhiBank'),
            'nameKey': 'alRajhiBank',
            'icon': 'assets/images/bank.png'
          },
          {
            'name': languageService.getText('riyadBank'),
            'nameKey': 'riyadBank',
            'icon': 'assets/images/bank.png'
          },
        ],
      },
    ];
  }

  void _onCountrySelected(String countryName) {
    setState(() {
      _selectedCountry = countryName;
      _selectedBank = null;
      _showBanks = true;
      _searchController.clear();
      _searchQuery = '';
    });
  }

  void _onBankSelected(String bankName) {
    final languageService =
        Provider.of<LanguageService>(context, listen: false);
    final countries = _getCountries(languageService);

    final country = countries.firstWhere(
      (c) => c['name'] == _selectedCountry,
    );
    final bank = (country['banks'] as List).firstWhere(
      (b) => b['name'] == bankName,
    );

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChangeBankAccountDetailsPage(
          bankName: bankName,
          bankIconPath: bank['icon'],
        ),
      ),
    );
  }

  bool _onBackPressed() {
    if (_showBanks) {
      setState(() {
        _showBanks = false;
        _selectedBank = null;
        _searchController.clear();
        _searchQuery = '';
      });
      return false;
    } else {
      return true;
    }
  }

  Widget _buildHeaderComponent() {
    return SearchBarWidget(
      hintTextKey: 'searchYourBankName',
      controller: _searchController,
      onChanged: (value) {
        setState(() {
          _searchQuery = value.toLowerCase();
        });
      },
    );
  }

  List<Map<String, dynamic>> _getFilteredItems() {
    final languageService =
        Provider.of<LanguageService>(context, listen: false);
    final countries = _getCountries(languageService);

    if (_showBanks) {
      final country = countries.firstWhere(
        (c) => c['name'] == _selectedCountry,
      );
      final banks = List<Map<String, dynamic>>.from(country['banks']);

      if (_searchQuery.isEmpty) {
        return banks;
      }

      return banks
          .where(
            (bank) => bank['name'].toLowerCase().contains(_searchQuery),
          )
          .toList();
    } else {
      if (_searchQuery.isEmpty) {
        return countries;
      }

      return countries
          .where(
            (country) => country['name'].toLowerCase().contains(_searchQuery),
          )
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageService = Provider.of<LanguageService>(context);

    return WillPopScope(
      onWillPop: () async {
        return _onBackPressed();
      },
      child: Scaffold(
        backgroundColor: AppColors.secondary,
        body: SafeArea(
          child: Column(
            children: [
              CustomTopBar.withTitle(
                title: Text(
                  languageService.getText('changeBankAccount'),
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
                      color: AppColors.white,
                      size: 20,
                    ),
                  ),
                ),
                showNotification: false,
                showProfile: false,
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _buildHeaderComponent(),
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
                    padding: const EdgeInsets.all(24),
                    child: _buildContent(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    final items = _getFilteredItems();

    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (context, index) => const SizedBox(height: 0),
      itemBuilder: (context, index) {
        final item = items[index];
        final isSelected = _showBanks
            ? _selectedBank == item['name']
            : _selectedCountry == item['name'];

        return SelectableItemCard(
          title: item['name'],
          iconPath: item['icon'],
          isSelected: isSelected,
          showBottomBorder: _showBanks && index < items.length - 1,
          cardStyle: _showBanks ? CardStyle.bank : CardStyle.country,
          onTap: () {
            if (_showBanks) {
              _onBankSelected(item['name']);
            } else {
              _onCountrySelected(item['name']);
            }
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
