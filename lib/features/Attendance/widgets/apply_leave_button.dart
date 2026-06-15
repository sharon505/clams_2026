import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_padding.dart';
import '../../../constants/app_styles.dart';

class ApplyLeaveButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ApplyLeaveButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42.h,
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(
          Icons.event_busy_outlined,
          size: 18.sp,
          color: AppColors.white,
        ),
        label: Text(
          'Apply Leave',
          style: AppStyles.buttonText.copyWith(
            fontSize: 14.sp,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
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