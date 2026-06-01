import 'package:clams/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WorkHoursProgressBar extends StatelessWidget {
  final int completedPercentage;

  const WorkHoursProgressBar({
    super.key,
    required this.completedPercentage,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.r),

      child: LinearProgressIndicator(
        value: completedPercentage / 100,
        minHeight: 8.h,
        backgroundColor: Colors.grey.shade200,
        valueColor: const AlwaysStoppedAnimation(
          AppColors.primaryColor,
        ),
      ),
    );
  }
}