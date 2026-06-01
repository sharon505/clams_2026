import 'package:clams/constants/app_colors.dart';
import 'package:clams/constants/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const StatItem({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: 20.sp,
          color: AppColors.primaryColor,
        ),
        SizedBox(height: 6.h),
        Text(
          title,
          style: AppStyles.bodySmall,
        ),
        SizedBox(height: 2.h),
        Text(
          value,
          style: AppStyles.heading4.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}