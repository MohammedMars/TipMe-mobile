// lib/main.dart (updated)
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:tipme_app/data/services/language_service.dart';
import 'package:tipme_app/di/gitIt.dart';
import 'package:tipme_app/models/notification_item.dart';
import 'package:tipme_app/routs/app_routs.dart';
import 'package:tipme_app/services/signalRService.dart';
import 'package:tipme_app/services/notificationPopupService.dart';
import 'package:tipme_app/utils/colors.dart';
import 'package:tipme_app/core/dio/client/dio_client_pool.dart';
import 'package:tipme_app/providersChangeNotifier/profileSetupProvider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(NotificationItemAdapter());

  // Initialize DioClient pool and service locator
  DioClientPool.instance.init();
  await setupServiceLocator();

  // Initialize SignalR and notification services
  _initializeNotificationServices();

  try {} catch (e) {
    print('Failed to connect to notification hub: $e');
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LanguageService()),
        ChangeNotifierProvider(create: (context) => ProfileSetupProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

void _initializeNotificationServices() {
  // Listen to SignalR notifications and show popups
  SignalRService.instance.notificationStream.listen((notification) {
    // Determine notification type and show appropriate popup
    if (notification.title?.toLowerCase().contains('tip') == true) {
      NotificationPopupService.instance.showTipReceivedPopup(notification);
    } else {
      NotificationPopupService.instance.showNotificationPopup(notification);
    }
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Start SignalR connection when app starts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SignalRService.instance.startConnection();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    SignalRService.instance.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        // Reconnect when app comes to foreground
        if (!SignalRService.instance.isConnected) {
          SignalRService.instance.startConnection();
        }
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        // Keep connection alive but could implement logic here if needed
        break;
      case AppLifecycleState.detached:
        // Stop connection when app is terminated
        SignalRService.instance.stopConnection();
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return OverlaySupport.global(
      child: MaterialApp(
        title: 'TipMe',
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
