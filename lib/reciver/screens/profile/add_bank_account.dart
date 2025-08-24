//lib/auth/screens/profile/add_bank_account.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tipme_app/providersChangeNotifier/profileSetupProvider.dart';
import 'package:tipme_app/reciver/screens/profile/bank_account_details.dart';
import '../../widgets/onboarding_layout.dart';
import '../../widgets/selectable_item_card.dart';
import '../../widgets/progress_next_button.dart';
import '../../widgets/search_bar_widget.dart';
import '../../../data/services/language_service.dart';
import '../../../utils/colors.dart';

class AddBankAccountPage extends StatefulWidget {
  const AddBankAccountPage({Key? key}) : super(key: key);

  @override
  State<AddBankAccountPage> createState() => _AddBankAccountPageState();
}

class _AddBankAccountPageState extends State<AddBankAccountPage> {
  String? _selectedCountry;
  String? _selectedBank;
  bool _showBanks = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

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
    setState(() {
      _selectedBank = bankName;
    });
  }

  void _onNext() {
    final languageService =
        Provider.of<LanguageService>(context, listen: false);
    final countries = _getCountries(languageService);

    if (_showBanks && _selectedBank != null) {
      final country = countries.firstWhere(
        (c) => c['name'] == _selectedCountry,
      );
      final bank = (country['banks'] as List).firstWhere(
        (b) => b['name'] == _selectedBank,
      );
      final provider = Provider.of<ProfileSetupProvider>(context, listen: false);
      provider.update(
        bankName: _selectedBank!,
        // TODO: here 
        // bankCountryId: _selectedCountry!,
      );
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => BankAccountDetailsPage(
            bankName: _selectedBank!,
            bankIconPath: bank['icon'],
          ),
        ),
      );
    } else if (!_showBanks && _selectedCountry != null) {
      _onCountrySelected(_selectedCountry!);
    }
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
      backgroundColor: AppColors.white.withOpacity(0.10),
      textColor: AppColors.white,
      hintTextColor: AppColors.white,
      iconColor: AppColors.white.withOpacity(0.7),
      prefixIconPath: 'assets/icons/search.svg',
      showFilterIcon: false,
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
      child: OnboardingLayout(
        step: 4,
        totalSteps: 5,
        title: languageService.getText('addNewBankAccount'),
        headerComponent: _buildHeaderComponent(),
        content: _buildContent(),
        nextButton: ProgressNextButton(
          onPressed:
              (_showBanks ? _selectedBank != null : _selectedCountry != null)
                  ? _onNext
                  : null,
          isEnabled:
              _showBanks ? _selectedBank != null : _selectedCountry != null,
          currentStep: 4,
          totalSteps: 5,
        ),
        topPadding: 16.0,
        bottomPadding: 24.0,
      ),
    );
  }

  Widget _buildContent() {
    final items = _getFilteredItems();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ListView.separated(
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
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
