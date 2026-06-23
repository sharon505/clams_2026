import 'package:clams/constants/app_colors.dart';
import 'package:clams/constants/app_radius.dart';
import 'package:clams/constants/app_styles.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarRangeCard extends StatefulWidget {
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
  State<CalendarRangeCard> createState() => _CalendarRangeCardState();
}

class _CalendarRangeCardState
    extends State<CalendarRangeCard> {
  bool showCalendar = false;

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat("dd MMM yyyy");

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: AppRadius.medium,
      ),
      child: Column(
        children: [
          /// Switch Tile
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text(
              "Select Date Range",
            ),
            subtitle: Text(
              widget.fromDate == null
                  ? "No date selected"
                  : widget.toDate == null ||
                  DateUtils.isSameDay(
                    widget.fromDate,
                    widget.toDate,
                  )
                  ? formatter.format(widget.fromDate!)
                  : "${formatter.format(widget.fromDate!)} ➜ ${formatter.format(widget.toDate!)}",
            ),
            value: showCalendar,
            activeColor: AppColors.primaryColor,
            onChanged: (value) async  {
              await HapticFeedback.heavyImpact();

              setState(() {
                showCalendar = value;
              });
            },
          ),

          if (showCalendar) ...[

            Divider(),

            _CalendarCore(
              focusedDay: widget.focusedDay,
              firstAllowedDate:
              widget.firstAllowedDate,
              lastAllowedDate:
              widget.lastAllowedDate,
              fromDate: widget.fromDate,
              toDate: widget.toDate,
              headerTitleCentered:
              widget.headerTitleCentered,
              headerVisible:
              widget.headerVisible,
              calendarFormat:
              widget.calendarFormat,
              onSelectDay:
              widget.onSelectDay,
            ),
          ],
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


Widget buildDateTimeline({
  required DateTime? fromDate,
  required DateTime? toDate,
}) {
  final formatter = DateFormat("dd MMM yyyy");

  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppColors.primarySecondary.withOpacity(.15),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: AppColors.primarySecondary,
      ),
    ),
    child: Column(
      children: [
        /// START DATE
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 18,
                  height: 18,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  width: 2,
                  height: 60,
                  color: AppColors.primaryColor,
                ),
              ],
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Start Date",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    fromDate == null
                        ? "Select Start Date"
                        : formatter.format(fromDate),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        /// END DATE
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: fromDate != null &&
                    toDate != null
                    ? AppColors.success
                    : Colors.grey,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.flag,
                size: 10,
                color: Colors.white,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  const Text(
                    "End Date",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    toDate == null
                        ? "Select End Date"
                        : formatter.format(toDate),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );
}