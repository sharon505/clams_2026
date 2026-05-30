import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../constants/app_colors.dart';
import '../../../../constants/app_styles.dart';
import '../providers/employee_working_duration_viewModel.dart';
import '../providers/location_viewModel.dart';
import '../providers/puncing_viewModel.dart';


class WorkHoursCard extends StatelessWidget {
  const WorkHoursCard({super.key});

  String _formatDuration(Duration duration) {
    final h = duration.inHours;
    final m = duration.inMinutes.remainder(60);

    return '${h}h ${m}m';
  }

  @override
  Widget build(BuildContext context) {

    final workVm = context.watch<EmployeeWorkingDurationViewModel>();
    final punchVm = context.watch<PunchingProvider>();
    final locationVm = context.watch<LocationProvider>();


    final workedDuration = workVm.workedDuration;

    const targetHours = 9;
    final targetDuration = Duration(hours: targetHours);

    final remainingDuration = workedDuration >= targetDuration
        ? Duration.zero
        : targetDuration - workedDuration;

    final completedPercentage =
    (workVm.progress(maxHours: targetHours) * 100)
        .clamp(0, 100)
        .toInt();

    final statusText = workVm.statusText(maxHours: targetHours);
    String checkInTime = '--';

    if (punchVm.todayPunches.isNotEmpty) {
      final time = punchVm.todayPunches.first.time;

      final parts = time.split(':');

      if (parts.length >= 2) {
        final minutePart = parts[1].split(' ').first;

        final amPm = time.contains('AM')
            ? 'AM'
            : time.contains('PM')
            ? 'PM'
            : '';

        checkInTime =
            '${parts[0]}:$minutePart $amPm'.trim();
      }
    }

    Duration overtime = Duration.zero;

    if (workedDuration > targetDuration) {
      overtime = workedDuration - targetDuration;
    }

    Color badgeColor;
    Color badgeBgColor;
    IconData badgeIcon;

    switch (statusText.toLowerCase()) {
      case 'overtime':
        badgeColor = Colors.orange;
        badgeBgColor = Colors.orange.withOpacity(.1);
        badgeIcon = Icons.local_fire_department;
        break;

      case 'target achieved':
        badgeColor = AppColors.success;
        badgeBgColor = AppColors.success.withOpacity(.1);
        badgeIcon = Icons.check_circle;
        break;

      case 'in progress':
        badgeColor = AppColors.primaryColor;
        badgeBgColor = AppColors.primaryColor.withOpacity(.1);
        badgeIcon = Icons.hourglass_bottom;
        break;

      default:
        badgeColor = AppColors.warning;
        badgeBgColor = AppColors.warning.withOpacity(.1);
        badgeIcon = Icons.access_time;
    }

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Today Work Hours",
                      style: AppStyles.heading4,
                    ),

                    SizedBox(height: 4.h),

                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 14.sp,
                          color: AppColors.primaryColor,
                        ),

                        SizedBox(width: 4.w),

                        Flexible(
                          child: Text(
                            locationVm.isLoading
                                ? "Fetching location..."
                                : locationVm.locationName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppStyles.bodySmall.copyWith(
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(width: 8.w),

              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 6.h,
                ),
                decoration: BoxDecoration(
                  color: badgeBgColor,
                  borderRadius: BorderRadius.circular(30.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      badgeIcon,
                      size: 14.sp,
                      color: badgeColor,
                    ),

                    SizedBox(width: 5.w),

                    Text(
                      statusText,
                      style: AppStyles.bodySmall.copyWith(
                        color: badgeColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 18.h),

          /// WORKED / COMPLETED / REMAINING
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _statItem(
                icon: Icons.access_time_filled,
                title: "Worked",
                value: _formatDuration(workedDuration),
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
                    "Completed",
                    style: AppStyles.bodySmall,
                  ),
                ],
              ),

              _statItem(
                icon: Icons.timer_outlined,
                title: "Remaining",
                value: _formatDuration(remainingDuration),
              ),
            ],
          ),

          SizedBox(height: 18.h),

          /// PROGRESS BAR
          ClipRRect(
            borderRadius: BorderRadius.circular(20.r),
            child: LinearProgressIndicator(
              value: completedPercentage / 100,
              minHeight: 8.h,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation(
                AppColors.primaryColor,
              ),
            ),
          ),

          SizedBox(height: 20.h),

          /// BOTTOM CARDS
          Row(
            children: [
              Expanded(
                child: _bottomCard(
                  backgroundColor: const Color(0xffEFF8F0),
                  icon: Icons.fingerprint,
                  iconColor: AppColors.success,
                  title: "Check-In",
                  value: checkInTime,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _bottomCard(
                  backgroundColor: const Color(0xffEEF4FB),
                  icon: Icons.av_timer,
                  iconColor: AppColors.primaryColor,
                  title: "Overtime",
                  value: _formatDuration(overtime),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
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

  Widget _bottomCard({
    required Color backgroundColor,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12.w,
        vertical: 14.h,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 28.sp,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
            ),
          ),
        ],
      ),
    );
  }
}