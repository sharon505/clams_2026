import 'package:clams/constants/app_colors.dart';
import 'package:clams/features/work_hours/helpers/work_hours_helper.dart';
import 'package:clams/features/work_hours/providers/employee_working_duration_viewModel.dart';
import 'package:clams/features/work_hours/providers/location_viewModel.dart';
import 'package:clams/features/work_hours/providers/puncing_viewModel.dart';
import 'package:clams/features/work_hours/widgets/work_hours_header.dart';
import 'package:clams/features/work_hours/widgets/work_hours_progress_bar.dart';
import 'package:clams/features/work_hours/widgets/work_hours_stats_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../widgets/work_hours_bottom_section.dart';

class WorkHoursCard extends StatelessWidget {
  const WorkHoursCard({super.key});

  String formatDuration(Duration duration) {
    final h = duration.inHours;
    final m = duration.inMinutes.remainder(60);
    return '${h}h ${m}m';
  }

  @override
  Widget build(BuildContext context) {

    final workVm = context.watch<EmployeeWorkingDurationViewModel>();
    final punchVm = context.watch<PunchingProvider>();
    final locationVm = context.watch<LocationProvider>();

    final data = WorkHoursHelper.getData(
      workVm: workVm,
      punchVm: punchVm,
    );

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
        spacing: 10.h,
        children: [
          WorkHoursHeader(
            location: locationVm.locationName,
            isLoading: locationVm.isLoading,
            statusText: data.statusText,
            badgeColor: data.badgeColor,
            badgeBgColor: data.badgeBgColor,
            badgeIcon: data.badgeIcon,
          ),

          WorkHoursStatsSection(
            worked: WorkHoursHelper.formatDuration(
              data.workedDuration,
            ),
            remaining: WorkHoursHelper.formatDuration(
              data.remainingDuration,
            ),
            completedPercentage: data.completedPercentage,
          ),

          WorkHoursProgressBar(
            completedPercentage: data.completedPercentage,
          ),

          WorkHoursBottomSection(
            checkInTime: data.checkInTime,
            overtime: WorkHoursHelper.formatDuration(
              data.overtime,
            ),
          ),
        ],
      ),
    );
  }
}