import 'package:clams/constants/app_colors.dart';
import 'package:clams/constants/app_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'info_card.dart';

class WorkHoursBottomSection extends StatelessWidget {
  final String checkInTime;
  final String overtime;

  const WorkHoursBottomSection({
    super.key,
    required this.checkInTime,
    required this.overtime,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: InfoCard(
            backgroundColor: const Color(0xffEFF8F0),
            icon: Icons.fingerprint,
            iconColor: AppColors.success,
            title: AppStrings.checkIn,
            value: checkInTime,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: InfoCard(
            backgroundColor: const Color(0xffEEF4FB),
            icon: Icons.av_timer,
            iconColor: AppColors.primaryColor,
            title: AppStrings.overtime,
            value: overtime,
          ),
        ),
      ],
    );
  }
}