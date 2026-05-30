import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_padding.dart';
import '../../../constants/app_string.dart';
import '../controllers/login_controller.dart';
import '../providers/auth_provider.dart';
import '../widgets/login_button.dart';
import '../widgets/login_footer.dart';
import '../widgets/login_form.dart';
import '../widgets/login_header.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginController controller = LoginController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/login/backgroundImage.png',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: AppPadding.screenPadding,
            child: Form(
              key: controller.formKey,
              child: Column(
                spacing: 10.h,
                children: [
                  /// HEADER
                  const LoginHeader().animate().fadeIn(
                    duration: 700.ms,
                    curve: Curves.easeOutCubic,
                  ).slideY(
                    begin: -0.2,
                    end: 0,
                    duration: 700.ms,
                    curve: Curves.easeOutCubic,
                  ),
                  /// FORM
                  LoginForm(
                    employeeController:
                    controller.employeeController,
                    passwordController:
                    controller.passwordController,
                  ).animate().fadeIn(
                    delay: 250.ms,
                    duration: 700.ms).slideY(
                    begin: .15,
                    end: 0,
                    delay: 250.ms,
                    duration: 700.ms,
                    curve: Curves.easeOutCubic,
                  ),
                  /// BUTTON
                  LoginButton(
                    isLoading: auth.isLoading,
                    onTap: () => controller.login(context),
                  ).animate().fadeIn(
                    delay: 500.ms,
                    duration: 600.ms).scale(
                    begin: const Offset(.9, .9),
                    end: const Offset(1, 1),
                    delay: 500.ms,
                    duration: 600.ms,
                    curve: Curves.easeOutBack,
                  ),
                  /// POWERED BY
                  Text(
                    AppStrings.poweredBy,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ).animate().fadeIn(
                    delay: 700.ms,
                    duration: 500.ms,
                  ),
                  /// FOOTER
                  const LoginFooter().animate().fadeIn(
                    delay: 900.ms,
                    duration: 700.ms,
                  ).slideY(
                    begin: .2,
                    end: 0,
                    delay: 900.ms,
                    duration: 700.ms,
                    curve: Curves.easeOutCubic,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ).animate().fadeIn(
      duration: 800.ms,
      curve: Curves.easeOut,
    );
  }
}