import 'package:clams/constants/app_colors.dart';
import 'package:clams/constants/app_string.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/model_user.dart';
import '../providers/auth_provider.dart';

class LoginController {
  final employeeController = TextEditingController(
    // text: '100092'
    // text: '100002'
    ///patronamics
    // text: '2100047'
    ///patronamics ummesh
    // text: '2100060'
    ///rxlens
    // text: '2300061'
    ///harish
    // text: '100077'
    ///minuPinto
    // text:'100066'
    ///saranya
    // text:'100056'
    ///Ganga
    // text:'100058'
    ///sam
    // text:'100092'
    ///ullasSir
    // text:'100002'
    ///joffi
    // text: "100073"
    ///Rinto
    // text: "100006"
    ///Kiran
    // text: "100059"
    // ///cij
    // text: '2431'

    ///ccu test employee
    text: '2710'

    //   text:'100095'
    //   text:'397'
  );

  final passwordController = TextEditingController(
    // text: '100092#123'
    // text: '123456'
    ///patronamics
    // text: '2100047#123'
    ///patronamics ummesh
    // text: '2100060#123'
    ///rxlens
    // text: '2300061#123'
    ///harish
    // text: '100077#123'
    ///MinuPinto
    // text:'100066#123'
    ///saranya
    // text:'S@12345'
    ///Ganga
    // text:'100058#123'
    ///sam
    // text:'100092#123'
    ///ullasSir
    // text:'123456'
    ///joffi
    // text: "12345"
    ///Rinto
    // text: "rintojinu"
    ///Kiran
    // text: "Kiranv110893@"
    ///cij
    //   text: 'Varun@123'

    ///ccu test employee
    text: '2710#1234567'

    // text: '2431'
    //   text:'100095#123'
    ///ccu
    //   text:'naj4545'
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