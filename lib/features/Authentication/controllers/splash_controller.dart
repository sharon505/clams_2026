import 'package:flutter/material.dart';

class SplashController {
  static Future<void> navigateToLogin(
      BuildContext context,
      ) async {
    await Future.delayed(const Duration(seconds: 2));

    if (!context.mounted) return;

    Navigator.pushReplacementNamed(
      context,
      'loginPage',
    );
  }
}