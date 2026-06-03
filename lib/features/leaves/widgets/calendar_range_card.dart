import 'package:clams/constants/app_colors.dart';
import 'package:clams/constants/app_padding.dart';
import 'package:clams/constants/app_radius.dart';
import 'package:clams/constants/app_styles.dart';
import 'package:clams/constants/app_textfield.dart';
import 'package:flutter/material.dart';
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
    this.dateFormat = 'EEE, dd MMM yyyy',
    this.showDivider = true,
    this.headerTitleCentered = false,
    this.headerVisible = true,
    this.calendarFormat = CalendarFormat.month,
  });

  final DateTime focusedDay;
  final DateTime firstAllowedDate;
  final DateTime lastAllowedDate;
  final DateTime? fromDate;
  final DateTime? toDate;
  final void Function(DateTime selectedDay, DateTime focusedDay) onSelectDay;
  final String dateFormat;
  final bool showDivider;
  final bool headerTitleCentered;
  final bool headerVisible;
  final CalendarFormat calendarFormat;

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat(dateFormat);


    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: AppRadius.medium,
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// FROM FIELD
          CustomInputCard.textField(
            readOnly: true,
            icon: Icons.calendar_month,
            label: 'From',
            hintText: fmt.format(fromDate ?? focusedDay),
            controller: TextEditingController(),
            keyboardType: TextInputType.multiline,
          ),

          /// TO FIELD (ALWAYS VISIBLE)
          CustomInputCard.textField(
            readOnly: true,
            icon: Icons.calendar_month,
            label: 'To',
            hintText: fmt.format(toDate ?? fromDate ?? focusedDay),
            controller: TextEditingController(),
            keyboardType: TextInputType.multiline,
          ),

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
  final void Function(DateTime selectedDay, DateTime focusedDay) onSelectDay;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPadding.horizontalOnly,
      child: TableCalendar(
        firstDay: firstAllowedDate,
        lastDay: lastAllowedDate,
        focusedDay: focusedDay,
        availableGestures: AvailableGestures.horizontalSwipe,
        calendarFormat: calendarFormat,

        /// RANGE HIGHLIGHT
        rangeStartDay: fromDate,
        rangeEndDay: toDate,

        onDaySelected: onSelectDay,

        enabledDayPredicate: (day) => !day.isBefore(firstAllowedDate),

        calendarStyle: CalendarStyle(
          // REMOVE today circle
          todayDecoration: const BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.circle,
          ),

          todayTextStyle: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.normal,
          ),

          // Range start
          rangeStartDecoration: const BoxDecoration(
            color: AppColors.primaryColor,
            shape: BoxShape.circle,
          ),

          // Range end
          rangeEndDecoration: const BoxDecoration(
            color: AppColors.primaryColor,
            shape: BoxShape.circle,
          ),

          // Middle highlight
          rangeHighlightColor: AppColors.primaryColor.withOpacity(.25),

          // Remove selected circle
          selectedDecoration: const BoxDecoration(
            color: Colors.transparent,
          ),

          selectedTextStyle: const TextStyle(
            color: Colors.black,
          ),

          cellMargin: AppPadding.allSmall,
        ),

        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: false,
          leftChevronVisible: false,
          rightChevronVisible: false,
          headerPadding: AppPadding.allSmall.copyWith(top: 0),
          titleTextStyle: AppStyles.heading2,
          titleTextFormatter: (date, locale) =>
          headerVisible ? DateFormat('MMMM yyyy').format(date) : '',
        ),
      ),
    );
  }
}
