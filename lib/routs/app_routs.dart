import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:tipme_app/reciver/screens/mainProfile/faq_page.dart';
import 'package:tipme_app/reciver/screens/mainProfile/help_support_page.dart';
import 'package:tipme_app/reciver/screens/mainProfile/login_security_page.dart';
import 'package:tipme_app/reciver/screens/mainProfile/notification_preferences_page.dart';
import 'package:tipme_app/reciver/screens/mainProfile/privacy_policy.dart';
import 'package:tipme_app/reciver/screens/mainProfile/profile_page.dart';
import 'package:tipme_app/reciver/screens/mainProfile/report_problem_page.dart';
import 'package:tipme_app/reciver/screens/mainProfile/terms_conditions_page.dart';
import 'package:tipme_app/reciver/screens/mainProfile/account_info_page.dart';
import 'package:tipme_app/reciver/screens/wallet/wallet.dart';
import 'package:tipme_app/reciver/screens/wallet/linked_bank_account_page.dart';
import 'package:tipme_app/reciver/screens/wallet/notification_screen.dart';
import 'package:tipme_app/reciver/screens/wallet/transactions_screen.dart';
import 'package:tipme_app/reciver/home/screens/qr_flow.dart';
import 'package:tipme_app/reciver/home/screens/qr_generator_screen.dart';
import 'package:tipme_app/reciver/onboarding_screens/splash_screen.dart';
import 'package:tipme_app/reciver/onboarding_screens/steps.dart';
import 'package:tipme_app/reciver/onboarding_screens/welcome_screen.dart';
import '../reciver/screens/signinup/sign_in_up.dart';
import '../reciver/screens/signinup/verify_phone_number.dart';
import '../reciver/screens/signinup/welcome.dart';
import '../reciver/screens/profile/choose_gender.dart';
import '../reciver/screens/profile/document_upload.dart';
import '../reciver/screens/profile/profile_setup.dart';
import '../reciver/screens/profile/add_bank_account.dart';
import '../reciver/screens/profile/agree_to_terms.dart';
import '../reciver/screens/profile/verification_pending.dart';

class AppRoutes {
  static const String signInUp = '/sign-in-up';
  static const String verifyPhone = '/verify-phone-number';
  static const String welcome = '/welcome';
  static const String chooseGender = '/choose-gender';
  static const String documentUpload = '/document-upload';
  static const String profileSetup = '/profile-setup';
  static const String onboardingWelcome = '/onboarding_welcome';
  static const String splashScreen = '/';
  static const String stepsScreen = '/steps_screen';
  static const String addBankAccount = '/add-bank-account';
  static const String agreeToTerms = '/agree-to-terms';
  static const String verificationPending = '/verification-pending';
  static const String linkedBankAccount = '/linked-bank-account';
  static const String walletScreen = '/wallet';
  static const String notifications = '/notifications';
  static const String transactions = '/transactions';
  static const String loginSecurity = '/login-security';
  static const String notificationPreferences = '/notification-preferences';
  static const String helpSupport = '/help-support';
  static const String reportProblem = '/report-problem';
  static const String faq = '/faq';
  static const String termsConditions = '/terms-conditions';
  static const String privacyPolicy = '/privacy-policy';
  static const String accountInfo = '/account-info';
  static const String profilePage = '/profile-page';
  static const String logInQR = '/QR_generate';
  static const String logInQRHome = '/QR_Home';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case signInUp:
        return MaterialPageRoute(
          builder: (_) => const SignInUpPage(),
          settings: settings,
        );

      case verifyPhone:
        final args = settings.arguments as Map<String, dynamic>?;
        final phoneNumber = args?['phoneNumber'] as String? ?? '';
        final isLogin = args?['isLogin'] as bool? ?? false;
        return MaterialPageRoute(
          builder: (_) => VerifyPhonePage(phoneNumber: phoneNumber, isLogin: isLogin),
          settings: settings,
        );

      case welcome:
        return MaterialPageRoute(
          builder: (_) => const WelcomePage(),
          settings: settings,
        );

      case chooseGender:
        return MaterialPageRoute(
          builder: (_) => const ChooseGenderPage(),
          settings: settings,
        );

      case documentUpload:
        return MaterialPageRoute(
          builder: (_) => const DocumentUploadPage(),
          settings: settings,
        );

      case profileSetup:
        return MaterialPageRoute(
          builder: (_) => const ProfileSetupPage(),
          settings: settings,
        );

      case addBankAccount:
        return MaterialPageRoute(
          builder: (_) => const AddBankAccountPage(),
          settings: settings,
        );

      case agreeToTerms:
        return MaterialPageRoute(
          builder: (_) => const AgreeToTermsPage(),
          settings: settings,
        );

      case verificationPending:
        return MaterialPageRoute(
          builder: (_) => const VerificationPendingPage(),
          settings: settings,
        );

      case linkedBankAccount:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => LinkedBankAccountPage(
            bankName: args['bankName'] ?? '',
            accountHolderName: args['accountHolderName'] ?? '',
            country: args['country'] ?? '',
            iban: args['iban'] ?? '',
            bankIconPath: args['bankIconPath'],
          ),
          settings: settings,
        );

      case onboardingWelcome:
        return MaterialPageRoute(
          builder: (_) => const WelcomeScreen(),
          settings: settings,
        );

      case splashScreen:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
          settings: settings,
        );

      case stepsScreen:
        return MaterialPageRoute(
          builder: (_) => const StepsScreen(),
          settings: settings,
        );

      case walletScreen:
        return MaterialPageRoute(
          builder: (_) => const WalletScreen(),
          settings: settings,
        );

      case notifications:
        return MaterialPageRoute(
          builder: (_) => const NotificationScreen(),
        );

      case transactions:
        return MaterialPageRoute(
          builder: (_) => const TransactionsScreen(),
          settings: settings,
        );

      case loginSecurity:
        return MaterialPageRoute(
          builder: (_) => const LoginSecurityPage(),
          settings: settings,
        );

      case notificationPreferences:
        return MaterialPageRoute(
          builder: (_) => const NotificationPreferencesPage(),
          settings: settings,
        );

      case helpSupport:
        return MaterialPageRoute(
          builder: (_) => const HelpSupportPage(),
          settings: settings,
        );

      case reportProblem:
        return MaterialPageRoute(
          builder: (_) => const ReportProblemPage(),
          settings: settings,
        );

      case faq:
        return MaterialPageRoute(
          builder: (_) => const FAQPage(),
          settings: settings,
        );

      case termsConditions:
        return MaterialPageRoute(
          builder: (_) => const TermsConditionsPage(),
          settings: settings,
        );

      case privacyPolicy:
        return MaterialPageRoute(
          builder: (_) => const PrivacyPolicyPage(),
          settings: settings,
        );

      case accountInfo:
        return MaterialPageRoute(
          builder: (_) => const AccountInfoPage(),
          settings: settings,
        );

      case profilePage:
        return MaterialPageRoute(
          builder: (_) => const ProfilePage(),
          settings: settings,
        );

      case logInQR:
        return MaterialPageRoute(
          builder: (_) => const QRGeneratorScreen(),
          settings: settings
        );

      case logInQRHome:
        final args = settings.arguments as Map<String, dynamic>?;
        final qrBytes = args?['qrBytes'] as Uint8List?;
        final qrDataUri = args?['qrDataUri'] as String?;
        final logoBytes = args?['logoBytes'] as Uint8List?;

        return MaterialPageRoute(
          builder: (_) => HomeScreen(
            qrBytes: qrBytes,
            qrDataUri: qrDataUri,
            logoBytes: logoBytes,
          ),
          settings: settings,
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
