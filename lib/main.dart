// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // SystemUiOverlayStyle
import 'package:tipme_app/core/dio/client/dio_client_pool.dart';
import 'package:tipme_app/di/gitIt.dart';
import 'package:tipme_app/providersChangeNotifier/profileSetupProvider.dart';
import 'package:tipme_app/utils/colors.dart';
import 'routs/app_routs.dart';
import 'package:provider/provider.dart';
import 'data/services/language_service.dart';

void main() async {
  registerSingilton();
  DioClientPool.instance.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LanguageService()),
        ChangeNotifierProvider(create: (context) => ProfileSetupProvider()), // 👈 added
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark, // Android
        statusBarBrightness: Brightness.light, // iOS
      ),
      child: MaterialApp(
        title: 'Your App Name',
        debugShowCheckedModeBanner: false,
        supportedLocales: const [
          Locale('en'),
          Locale('ar'),
        ],
        initialRoute: AppRoutes.splashScreen,
        onGenerateRoute: AppRoutes.generateRoute,
        onUnknownRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => Scaffold(
              appBar: AppBar(title: const Text('Page Not Found')),
              body: const Center(
                child: Text('The requested page was not found.'),
              ),
            ),
          );
        },
        theme: ThemeData(
          primaryColor: AppColors.secondary,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
      ),
    );
  }
}
