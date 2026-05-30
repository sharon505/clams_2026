import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_string.dart';
import '../../../constants/app_styles.dart';

class LoginButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onTap;

  const LoginButton({
    super.key,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 15,
          sigmaY: 15,
        ),
        child: SizedBox(
          width: double.infinity,
          height: 56.h,
          child: ElevatedButton(
            onPressed: isLoading ? null : onTap,
            style: ElevatedButton.styleFrom(
              elevation: 0,
              shadowColor: Colors.transparent,
              backgroundColor:
              AppColors.primaryColor.withValues(alpha: 0.7),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.r),
                side: BorderSide(
                  color: Colors.white.withValues(alpha: 0.30),
                  width: 1.w,
                ),
              ),
            ),
            child: isLoading ? LoadingAnimationWidget.staggeredDotsWave(
              color: Colors.white,
              size: 24.sp,
            ) : Text(
              AppStrings.login,
              style: AppStyles.buttonText,
            ),
          ),
        ),
      ),
    );
  }
}