import 'package:clams/constants/app_colors.dart';
import 'package:clams/constants/app_string.dart';
import 'package:clams/constants/app_styles.dart';
import 'package:flutter/material.dart';

import 'stat_item.dart';

class WorkHoursStatsSection extends StatelessWidget {
  final String worked;
  final String remaining;
  final int completedPercentage;

  const WorkHoursStatsSection({
    super.key,
    required this.worked,
    required this.remaining,
    required this.completedPercentage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        StatItem(
          icon: Icons.access_time_filled,
          title: AppStrings.worked,
          value: worked,
        ),
        Column(
          children: [
            Text(
              '$completedPercentage%',
              style: AppStyles.heading2.copyWith(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              AppStrings.completed,
              style: AppStyles.bodySmall,
            ),
          ],
        ),
        StatItem(
          icon: Icons.timer_outlined,
          title: AppStrings.remaining,
          value: remaining,
        ),
      ],
    );
  }
}