// attendance_day_cell
import 'package:clams/constants/app_colors.dart';
import 'package:clams/constants/app_styles.dart';
import 'package:clams/features/Attendance/controllers/attendance_calendar_controller.dart';
import 'package:clams/features/Attendance/models/model_punch_log.dart';
import 'package:clams/features/Attendance/providers/punch_log_viewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AttendanceDayCell extends StatelessWidget {
  final DateTime day;
  final PunchLogViewModel vm;
  final bool isToday;
  final bool isSelected;
  final bool isLate;

  const AttendanceDayCell({
    super.key,
    required this.day,
    required this.vm,
    required this.isLate,
    this.isToday = false,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final dateKey = DateTime(day.year, day.month, day.day);
    final logs = vm.groupedByDate[dateKey] ?? <PunchLogItem>[];

    final hasPunch = logs.any((e) => e.isValidPunch);
    final duration = vm.workedDurationFor(day);

    const int targetMinutes = 8 * 60 + 30;

    final bool isEarlyOut =
        hasPunch &&
        duration.inMinutes > 0 &&
        duration.inMinutes < targetMinutes;

    final leave = AttendanceCalendarController.leaveLabel(logs);

    Color bgColor = AppColors.transparent;
    Color textColor = AppColors.textColor;
    Color? borderColor;

    if (isSelected) {
      bgColor = AppColors.primaryColor;
      textColor = AppColors.white;
    } else if (leave != null) {
      bgColor = AttendanceCalendarController.leaveColor(leave);
      textColor = AppColors.white;
    } else if (isEarlyOut) {
      bgColor = AppColors.warning;
      textColor = AppColors.white;
    } else if (hasPunch) {
      bgColor = isLate ? AppColors.warning : AppColors.success;
      textColor = AppColors.white;
    }

    if (isToday) {
      borderColor = AppColors.primaryColor;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      margin: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12.r),
        border: borderColor != null
            ? Border.all(color: borderColor, width: 2.w)
            : null,
        boxShadow: isToday
            ? [
                BoxShadow(
                  color: AppColors.primaryColor.withOpacity(.12),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ]
            : [],
      ),
      alignment: Alignment.center,
      child: Text(
        '${day.day}',
        style: AppStyles.bodyMedium.copyWith(
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),
    );
  }
}
