import 'package:clams/constants/app_colors.dart';
import 'package:clams/features/work_hours/models/work_hours_data.dart';
import 'package:clams/features/work_hours/providers/employee_working_duration_viewModel.dart';
import 'package:clams/features/work_hours/providers/puncing_viewModel.dart';
import 'package:flutter/material.dart';

class WorkHoursHelper {
  static WorkHoursData getData({
    required EmployeeWorkingDurationViewModel workVm,
    required PunchingProvider punchVm,
  }) {
    final workedDuration = workVm.workedDuration;

    final targetDuration = workVm.targetDuration;

    final remainingDuration = workVm.remainingDuration;

    final completedPercentage = (workVm.progress * 100).clamp(0, 100).toInt();

    final statusText = workVm.statusText;

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
        checkInTime = '${parts[0]}:$minutePart $amPm'.trim();
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

    return WorkHoursData(
      workedDuration: workedDuration,
      remainingDuration: remainingDuration,
      overtime: overtime,
      completedPercentage:
      completedPercentage,
      statusText: statusText,
      checkInTime: checkInTime,
      badgeColor: badgeColor,
      badgeBgColor: badgeBgColor,
      badgeIcon: badgeIcon,
    );
  }

  static String formatDuration(Duration duration) {
    final h = duration.inHours;
    final m = duration.inMinutes.remainder(60);
    // final s = duration.inSeconds.remainder(60);
    return '${h}h ${m}m';
  }
}