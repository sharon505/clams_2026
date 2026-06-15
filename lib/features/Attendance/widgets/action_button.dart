import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_padding.dart';
import '../../../constants/app_styles.dart';

class ActionButton extends StatelessWidget {
  final String title;
  final Color backgroundColor;
  final VoidCallback onPressed;
  final IconData? icon;

  const ActionButton({
    super.key,
    required this.title,
    required this.backgroundColor,
    required this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42.h,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: icon != null
            ? Icon(
          icon,
          size: 18.sp,
          color: AppColors.white,
        )
            : const SizedBox.shrink(),
        label: Text(
          title,
          style: AppStyles.buttonText.copyWith(
            fontSize: 14.sp,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: AppColors.white,
          elevation: 0,
          padding: AppPadding.buttonPadding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      ),
    );
  }
}