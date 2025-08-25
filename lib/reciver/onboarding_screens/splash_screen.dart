import 'package:flutter/material.dart';
import 'package:tipme_app/core/dio/client/dio_client.dart';
import 'package:tipme_app/core/storage/storage_service.dart';
import 'package:tipme_app/di/gitIt.dart';
import 'package:tipme_app/routs/app_routs.dart';
import 'package:tipme_app/services/tipReceiverService.dart';
import 'dart:async';

import 'package:tipme_app/utils/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward();

    Timer(const Duration(seconds: 3), () {
      StorageService.hasKey('user_token').then((hasToken) async {
        if (hasToken) {
          final service = sl<TipReceiverService>();
          var response = await service.GetMe();
          if (response!.data!.isCompleted == true) {
            Navigator.of(context)
                .pushReplacementNamed(AppRoutes.verificationPending);
          } else {
            Navigator.of(context).pushReplacementNamed(AppRoutes.welcome);
          }
          // TODO:: Get User Id from StorageService then check if the user is completed or not
        } else {
          Navigator.of(context)
              .pushReplacementNamed(AppRoutes.onboardingWelcome);
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Opacity(
              opacity: 0.3, // 30%
              child: Image.asset(
                'assets/images/freepik--Graphics--inject-11.png',
                width: 332.81,
                height: 296.6,
                fit: BoxFit.contain,
              ),
            ),
            FadeTransition(
              opacity: _animation,
              child: ScaleTransition(
                scale: _animation,
                child: Image.asset(
                  'assets/images/Isolation_Mode.png',
                  width: 96.49,
                  height: 93,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
