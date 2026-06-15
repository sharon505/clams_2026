//attendance_ot_card

import 'package:clams/constants/app_colors.dart';
import 'package:clams/constants/app_padding.dart';
import 'package:clams/constants/app_styles.dart';
import 'package:clams/features/Attendance/widgets/action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AttendanceOTCard extends StatelessWidget {
  final bool visible;
  final DateTime? selectedDay;

  const AttendanceOTCard({
    super.key,
    required this.visible,
    required this.selectedDay,
  });

  @override
  Widget build(BuildContext context) {
    if (!visible) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 0,
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side: BorderSide(color: AppColors.primarySecondary),
      ),
      child: Padding(
        padding: AppPadding.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 22.r,
                  backgroundColor: AppColors.overtime.withOpacity(.12),
                  child: Icon(
                    Icons.timer_outlined,
                    color: AppColors.overtime,
                    size: 24.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Overtime', style: AppStyles.heading4),
                      SizedBox(height: 2.h),
                      Text(
                        'You worked on an off day.',
                        style: AppStyles.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 18.h),

            Container(
              width: double.infinity,
              padding: EdgeInsets.all(14.r),
              decoration: BoxDecoration(
                color: AppColors.primarySecondary,
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Eligible for Overtime',
                    style: AppStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'Your attendance qualifies for an overtime request. '
                    'Tap the button below to continue.',
                    style: AppStyles.bodySmall,
                  ),
                ],
              ),
            ),

            SizedBox(height: 20.h),

            SizedBox(
              width: double.infinity,
              child: ActionButton(
                title: 'Apply OT',
                backgroundColor: AppColors.overtime,
                icon: Icons.timer_outlined,
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    'ApplyOvertimeView',
                    arguments: {'date': selectedDay},
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
