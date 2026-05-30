import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_string.dart';
import '../../../constants/app_styles.dart';
import '../providers/auth_provider.dart';

class LoginForm extends StatelessWidget {
  final TextEditingController employeeController;
  final TextEditingController passwordController;

  const LoginForm({
    super.key,
    required this.employeeController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Column(
      spacing: 10.h,
      children: [
        TextFormField(
          controller: employeeController,
          keyboardType: TextInputType.number,
          style: AppStyles.bodyLarge,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return AppStrings.enterEmployeeCode;
            }
            return null;
          },
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              vertical: 18.h,
              horizontal: 16.w,
            ),
            hintText: AppStrings.employeeCode,
            hintStyle: AppStyles.hintText,
            prefixIcon: Padding(
              padding: EdgeInsets.all(14.r),
              child: SvgPicture.asset(
                'assets/icons/login/employee.svg',
                width: 20.w,
                height: 20.h,
                colorFilter: const ColorFilter.mode(
                  AppColors.primaryColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
            filled: true,
            fillColor: Colors.white.withValues(alpha: .70),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18.r),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18.r),
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: .40),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18.r),
              borderSide: BorderSide(
                color: AppColors.primaryColor,
                width: 1.5.w,
              ),
            ),
          ),
        ),
        TextFormField(
          controller: passwordController,
          obscureText: auth.isObscure,
          style: AppStyles.bodyLarge,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              // return 'Please enter Password';
              return AppStrings.enterPassword;
            }
            return null;
          },
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              vertical: 18.h,
              horizontal: 16.w,
            ),
            hintText: AppStrings.password,
            hintStyle: AppStyles.hintText,
            prefixIcon: Padding(
              padding: EdgeInsets.all(14.r),
              child: SvgPicture.asset(
                'assets/icons/login/secureData.svg',
                width: 20.w,
                height: 20.h,
                colorFilter: const ColorFilter.mode(
                  AppColors.primaryColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
            suffixIcon: IconButton(
              onPressed: auth.toggleVisibility,
              icon: Icon(
                auth.isObscure
                    ? Icons.visibility_off_rounded
                    : Icons.visibility_rounded,
                size: 22.sp,
                color: AppColors.primaryColor,
              ),
            ),
            filled: true,
            fillColor: Colors.white.withValues(alpha: .70),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18.r),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18.r),
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: .40),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18.r),
              borderSide: BorderSide(
                color: AppColors.primaryColor,
                width: 1.5.w,
              ),
            ),
          ),
        ),
      ],
    );
  }
}