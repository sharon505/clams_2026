import 'package:clams/constants/app_colors.dart';
import 'package:clams/constants/app_string.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/model_user.dart';
import '../providers/auth_provider.dart';

class LoginController {
  final employeeController = TextEditingController(
    text: '100092'
    // text: '100002'
  );

  final passwordController = TextEditingController(
    text: '100092#123'
    // text: '123456'
  );

  final formKey = GlobalKey<FormState>();

  Future<void> login(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    final provider = context.read<AuthProvider>();

    await provider.loginUser(
      UserModel(
        usercode: employeeController.text.trim(),
        password: passwordController.text.trim(),
      ),
    );

    if (!context.mounted) return;

    if (provider.loginData != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(AppStrings.loginSuccess),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacementNamed(context,'dashboardScreen');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.loginErrorMessage ?? AppStrings.loginFailed),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void dispose() {
    employeeController.dispose();
    passwordController.dispose();
  }
}