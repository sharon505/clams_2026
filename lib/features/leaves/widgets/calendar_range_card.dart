import 'package:clams/constants/app_colors.dart';
import 'package:clams/constants/app_padding.dart';
import 'package:clams/constants/app_radius.dart';
import 'package:clams/constants/app_styles.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';


class CalendarRangeCard extends StatelessWidget {
  const CalendarRangeCard({
    super.key,
    required this.focusedDay,
    required this.firstAllowedDate,
    required this.lastAllowedDate,
    required this.onSelectDay,
    this.fromDate,
    this.toDate,
    this.headerTitleCentered = false,
    this.headerVisible = true,
    this.calendarFormat = CalendarFormat.month,
  });

  final DateTime focusedDay;
  final DateTime firstAllowedDate;
  final DateTime lastAllowedDate;
  final DateTime? fromDate;
  final DateTime? toDate;

  final void Function(
      DateTime selectedDay,
      DateTime focusedDay,
      ) onSelectDay;

  final bool headerTitleCentered;
  final bool headerVisible;
  final CalendarFormat calendarFormat;

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat("dd MMM yyyy");

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: AppRadius.medium,
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          //================ DATE RANGE CARD =================

          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 14.h,
            ),
            decoration: BoxDecoration(
              color: AppColors.primarySecondary.withOpacity(.18),
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(
                color: AppColors.primarySecondary,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 42.w,
                  height: 42.h,
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.calendar_month,
                    color: AppColors.primaryColor,
                  ),
                ),

                SizedBox(width: 12.w),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Selected Date Range",
                        style: AppStyles.bodySmall.copyWith(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      SizedBox(height: 4.h),

                      Text(
                        "${fromDate == null ? "Select Date" : formatter.format(fromDate!)}"
                            "   →   "
                            "${toDate == null ? "Select Date" : formatter.format(toDate!)}",
                        style: AppStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 16.h),

          //================ CALENDAR =================

          _CalendarCore(
            focusedDay: focusedDay,
            firstAllowedDate: firstAllowedDate,
            lastAllowedDate: lastAllowedDate,
            fromDate: fromDate,
            toDate: toDate,
            headerTitleCentered: headerTitleCentered,
            headerVisible: headerVisible,
            calendarFormat: calendarFormat,
            onSelectDay: onSelectDay,
          ),
        ],
      ),
    );
  }
}


///selected
class _CalendarCore extends StatelessWidget {
  const _CalendarCore({
    required this.focusedDay,
    required this.firstAllowedDate,
    required this.lastAllowedDate,
    required this.onSelectDay,
    this.fromDate,
    this.toDate,
    required this.headerTitleCentered,
    required this.headerVisible,
    required this.calendarFormat,
  });

  final DateTime focusedDay;
  final DateTime firstAllowedDate;
  final DateTime lastAllowedDate;
  final DateTime? fromDate;
  final DateTime? toDate;
  final bool headerTitleCentered;
  final bool headerVisible;
  final CalendarFormat calendarFormat;

  final void Function(
      DateTime selectedDay,
      DateTime focusedDay,
      ) onSelectDay;

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: firstAllowedDate,
      lastDay: lastAllowedDate,
      focusedDay: focusedDay,

      calendarFormat: calendarFormat,
      availableGestures: AvailableGestures.horizontalSwipe,

      selectedDayPredicate: (_) => false,

      rangeStartDay: fromDate,
      rangeEndDay: toDate,

      onDaySelected: onSelectDay,

      enabledDayPredicate: (day) => !day.isBefore(firstAllowedDate),

      daysOfWeekHeight: 32,
      rowHeight: 48,

      headerStyle: HeaderStyle(
        titleCentered: true,
        formatButtonVisible: false,

        leftChevronIcon: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColors.primarySecondary.withOpacity(.35),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.chevron_left_rounded,
            size: 20,
            color: AppColors.primaryColor,
          ),
        ),

        rightChevronIcon: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColors.primarySecondary.withOpacity(.35),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.chevron_right_rounded,
            size: 20,
            color: AppColors.primaryColor,
          ),
        ),

        titleTextStyle: AppStyles.heading2.copyWith(
          fontWeight: FontWeight.w700,
        ),

        headerPadding: EdgeInsets.symmetric(
          vertical: 12.h,
        ),
      ),

      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: AppStyles.bodySmall.copyWith(
          color: Colors.grey.shade700,
          fontWeight: FontWeight.w600,
        ),
        weekendStyle: AppStyles.bodySmall.copyWith(
          color: Colors.redAccent,
          fontWeight: FontWeight.w600,
        ),
      ),

      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,

        cellMargin: EdgeInsets.all(4.w),

        defaultDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
        ),

        weekendDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
        ),

        todayDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: AppColors.primaryColor,
            width: 1.6,
          ),
        ),

        todayTextStyle: AppStyles.bodyMedium.copyWith(
          color: AppColors.primaryColor,
          fontWeight: FontWeight.bold,
        ),

        /// Disable default selected state
        selectedDecoration: const BoxDecoration(
          color: Colors.transparent,
        ),

        selectedTextStyle: AppStyles.bodyMedium,

        /// Range Start
        rangeStartDecoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(10.r),
        ),

        rangeStartTextStyle: AppStyles.bodyMedium.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),

        /// Range End
        rangeEndDecoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(10.r),
        ),

        rangeEndTextStyle: AppStyles.bodyMedium.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),

        /// Between Start & End
        withinRangeDecoration: BoxDecoration(
          color: AppColors.primaryColor.withOpacity(.12),
          borderRadius: BorderRadius.circular(8.r),
        ),

        withinRangeTextStyle: AppStyles.bodyMedium.copyWith(
          color: AppColors.primaryColor,
          fontWeight: FontWeight.w600,
        ),

        defaultTextStyle: AppStyles.bodyMedium,

        weekendTextStyle: AppStyles.bodyMedium.copyWith(
          color: Colors.redAccent,
        ),

        outsideTextStyle: AppStyles.bodySmall.copyWith(
          color: Colors.grey.shade400,
        ),

        disabledTextStyle: AppStyles.bodySmall.copyWith(
          color: Colors.grey.shade300,
        ),
      ),
    );
  }
}
