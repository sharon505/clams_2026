import 'package:clams/constants/app_colors.dart';
import 'package:clams/constants/app_padding.dart';
import 'package:clams/constants/app_styles.dart';
import 'package:clams/features/Attendance/controllers/attendance_calendar_controller.dart';

import 'package:clams/features/Attendance/models/model_punch_log.dart';
import 'package:clams/features/Attendance/providers/punch_log_viewModel.dart';
import 'package:clams/features/Attendance/widgets/attendance_day_cell.dart';
import 'package:clams/features/Attendance/widgets/attendance_month_details_card.dart';
import 'package:clams/features/Authentication/providers/auth_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../widgets/attendance_status_card.dart';
import '../widgets/attendance_ot_card.dart';
import '../widgets/attendance_action_card.dart';

class AttendanceCalendar extends StatefulWidget {
  const AttendanceCalendar({super.key});

  @override
  State<AttendanceCalendar> createState() => _AttendanceCalendarState();
}

class _AttendanceCalendarState extends State<AttendanceCalendar> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final DateTime _today = DateTime.now();

  /// fallback (if auth.officeInTime is null)
  static const int lateHour = 9;
  static const int lateMinute = 35;

  @override
  void initState() {
    super.initState();

    _selectedDay = _today;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PunchLogViewModel>().fetchForMonth(
        context: context,
        month: _today,
      );
    });
  }



  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PunchLogViewModel>();


    final DateTime safeToday = DateTime(
      _today.year,
      _today.month,
      _today.day,
    );

    return Scaffold(
      backgroundColor: AppColors.primaryBg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,

        title: Text(
          'Attendance',
          style: AppStyles.heading3,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppPadding.cardPadding,
          child: Column(
            children: [
              /// ---------------- CALENDAR ----------------
              Card(
                color: AppColors.white,
                elevation: 3,
                shadowColor: Colors.black12,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.r),
                  side: BorderSide(
                    color: AppColors.primarySecondary,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      TableCalendar(
                        firstDay: DateTime.utc(2020, 1, 1),
                        lastDay: safeToday,
                        focusedDay: _focusedDay,

                        calendarFormat: CalendarFormat.month,

                        availableGestures:
                        AvailableGestures.horizontalSwipe,

                        headerStyle: HeaderStyle(
                          formatButtonVisible: false,
                          titleCentered: true,

                          headerPadding: EdgeInsets.only(
                            bottom: 10.h,
                          ),

                          titleTextStyle: AppStyles.heading2.copyWith(
                            color: AppColors.primaryColor,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                          ),

                          leftChevronIcon: Icon(
                            Icons.chevron_left_rounded,
                            color: AppColors.black,
                            size: 22.sp,
                          ),

                          rightChevronIcon: Icon(
                            Icons.chevron_right_rounded,
                            color: AppColors.black,
                            size: 22.sp,
                          ),

                          leftChevronMargin: EdgeInsets.only(left: 4.w),
                          rightChevronMargin: EdgeInsets.only(right: 4.w),
                        ),

                        daysOfWeekStyle: DaysOfWeekStyle(
                          weekdayStyle: AppStyles.bodySmall.copyWith(
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w700,
                          ),

                          weekendStyle: AppStyles.bodySmall.copyWith(
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        calendarStyle: CalendarStyle(
                          outsideDaysVisible: false,

                          isTodayHighlighted: false,

                          defaultDecoration: const BoxDecoration(
                            color: Colors.transparent,
                          ),

                          weekendDecoration: const BoxDecoration(
                            color: Colors.transparent,
                          ),

                          todayDecoration: const BoxDecoration(
                            color: Colors.transparent,
                          ),

                          selectedDecoration: const BoxDecoration(
                            color: Colors.transparent,
                          ),
                        ),

                        selectedDayPredicate: (day) =>
                            isSameDay(_selectedDay, day),

                        enabledDayPredicate: (day) {
                          final d = DateTime(
                            day.year,
                            day.month,
                            day.day,
                          );

                          if (d.isAfter(safeToday)) {
                            return false;
                          }

                          return day.month == _focusedDay.month;
                        },

                        onDaySelected: (selected, focused) {
                          setState(() {
                            _selectedDay = selected;
                            _focusedDay = focused;
                          });
                        },

                        onPageChanged: (focused) {
                          final firstDay = DateTime(
                            focused.year,
                            focused.month,
                            1,
                          );

                          setState(() {
                            _focusedDay = focused;
                            _selectedDay = firstDay;
                          });

                          context.read<PunchLogViewModel>().fetchForMonth(
                            context: context,
                            month: focused,
                          );
                        },

                        // onPageChanged: (focused) {
                        //   setState(() {
                        //     _focusedDay = focused;
                        //     _selectedDay = null;
                        //   });
                        //
                        //   context
                        //       .read<PunchLogViewModel>()
                        //       .fetchForMonth(
                        //     context: context,
                        //     month: focused,
                        //   );
                        // },

                        calendarBuilders: CalendarBuilders(
                          defaultBuilder: (context, day, _) =>
                              AttendanceDayCell(
                                day: day,
                                vm: vm,
                                isLate: _isLateDay(
                                  vm.groupedByDate[
                                  DateTime(
                                    day.year,
                                    day.month,
                                    day.day,
                                  )] ??
                                      [],
                                  DateTime(
                                    day.year,
                                    day.month,
                                    day.day,
                                  ),
                                ),
                              ),

                          todayBuilder: (context, day, _) =>
                              AttendanceDayCell(
                                day: day,
                                vm: vm,
                                isToday: true,
                                isLate: _isLateDay(
                                  vm.groupedByDate[
                                  DateTime(
                                    day.year,
                                    day.month,
                                    day.day,
                                  )] ??
                                      [],
                                  DateTime(
                                    day.year,
                                    day.month,
                                    day.day,
                                  ),
                                ),
                              ),

                          selectedBuilder: (context, day, _) =>
                              AttendanceDayCell(
                                day: day,
                                vm: vm,
                                isSelected: true,
                                isLate: _isLateDay(
                                  vm.groupedByDate[
                                  DateTime(
                                    day.year,
                                    day.month,
                                    day.day,
                                  )] ??
                                      [],
                                  DateTime(
                                    day.year,
                                    day.month,
                                    day.day,
                                  ),
                                ),
                              ),
                        ),
                      ),

                      Divider(),

                      SizedBox(height: 7.h),

                      Wrap(
                        spacing: 16.w,
                        runSpacing: 10.h,
                        children: [
                          _legend(AppColors.success, 'Present'),
                          _legend(AppColors.casualLeave, 'Casual Leave'),
                          _legend(AppColors.sickLeave, 'Sick Leave'),
                          _legend(Colors.white, 'Absent', border: true),
                          _legend(AppColors.saturdayOff, 'Saturday Off'),
                        ],
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8.r),
                          onTap: () => _showAttendanceLegend(context),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.w,
                              vertical: 4.h,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.info_outline_rounded,
                                  size: 16.sp,
                                  color: AppColors.primaryColor,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  'More',
                                  style: AppStyles.bodyMedium.copyWith(
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),


              if (vm.isLoading)
                const LinearProgressIndicator(),

              if (!vm.isLoading && _selectedDay != null)
                _selectedDaySummary(vm),

              SizedBox(width: 16.h),
            ],
          ),
        ),
      ),
    );
  }

  void _showAttendanceLegend(BuildContext context) {
    final items = [
      (AppColors.success, 'Present', false),
      (Colors.white, 'Absent', true),
      (AppColors.earnedLeave, 'Earned Leave', false),
      (AppColors.casualLeave, 'Casual Leave', false),
      (AppColors.sickLeave, 'Sick Leave', false),
      (AppColors.officialDuty, 'Official Duty', false),
      (AppColors.lossOfPay, 'Loss Of Pay', false),
      (AppColors.compensatoryOff, 'Compensatory Off', false),
      (AppColors.offDay, 'Off Day', false),
      (AppColors.ownMarriage, 'Own Marriage', false),
      (AppColors.maternityLeave, 'Maternity Leave', false),
      (AppColors.paternityLeave, 'Paternity Leave', false),
      (AppColors.bereavementLeave, 'Bereavement Leave', false),
      (AppColors.childMarriage, "Child's Marriage", false),
      (AppColors.sterilizationLeave, 'Sterilization Leave', false),
      (AppColors.saturdayOff, 'Saturday Off', false),
      (AppColors.sundayOff, 'Sunday Off', false),
      (AppColors.overtime, 'Overtime', false),
    ];

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.r),
        ),
        title: Text(
          'Attendance Indicators',
          style: AppStyles.heading4,
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: items.length,
            separatorBuilder: (_, __) => Divider(
              height: 14.h,
            ),
            itemBuilder: (_, index) {
              final item = items[index];

              return Row(
                children: [
                  Container(
                    width: 16.w,
                    height: 16.w,
                    decoration: BoxDecoration(
                      color: item.$1,
                      shape: BoxShape.circle,
                      border: item.$3
                          ? Border.all(color: Colors.black54)
                          : null,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      item.$2,
                      style: AppStyles.bodyMedium,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: AppStyles.bodyMedium.copyWith(
                color: AppColors.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _legend(
      Color color,
      String text, {
        bool border = false,
      }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: border ? Colors.white : color,
            shape: BoxShape.circle,
            border: Border.all(
              color: border ? Colors.black : color,
            ),
          ),
        ),
        SizedBox(width: 6),
        Text(
          text,
          style: AppStyles.bodySmall,
        ),
      ],
    );
  }

  Widget _selectedDaySummary(PunchLogViewModel vm) {

    final dateKey = DateTime(
      _selectedDay!.year,
      _selectedDay!.month,
      _selectedDay!.day,
    );

    final logs = vm.groupedByDate[dateKey] ?? [];
    final details = <AttendanceMonthDetail>[];

    for (final log in logs) {
      if (log.isLeave) {
        details.add(
          AttendanceMonthDetail(
            title: log.punchType ?? 'Leave',
            date: DateFormat('dd/MM/yyyy').format(log.workDate!),
            color: AttendanceCalendarController.leaveColor(
              log.punchType ?? '',
            ),
          ),
        );
      }

      if (log.isMovement) {
        details.add(
          AttendanceMonthDetail(
            title: 'Movement',
            subtitle: 'Movement Request',
            date: DateFormat('dd/MM/yyyy').format(log.workDate!),
            color: AppColors.warning,
          ),
        );
      }

      if (log.isOfficialDuty) {
        details.add(
          AttendanceMonthDetail(
            title: 'Official Duty',
            date: DateFormat('dd/MM/yyyy').format(log.workDate!),
            color: AppColors.officialDuty,
          ),
        );
      }

      if (log.isHalfDay) {
        details.add(
          AttendanceMonthDetail(
            title: 'Half Day Leave',
            date: DateFormat('dd/MM/yyyy').format(log.workDate!),
            color: AppColors.warning,
          ),
        );
      }
    }
    final hasPunch = logs.any((e) => e.isValidPunch);
    final leave = AttendanceCalendarController.leaveLabel(logs);

    // ✅ NEW: if status is already updated, hide all action buttons
    final String? updatedStatus =
    AttendanceCalendarController.updatedStatusLabel(logs);
    final bool hasUpdatedStatus = updatedStatus != null;
    final bool canShowActions = !hasUpdatedStatus;

    // ✅ NEW: treat SUN as weekend (NOT leave)
    final bool isSunLabel = (leave ?? '').toUpperCase() == 'SUN';
    final bool isSundayByWeekday = dateKey.weekday == DateTime.sunday;
    final bool isWeekendSunday = isSundayByWeekday || isSunLabel;

    final String leaveText = (leave ?? '').toLowerCase();

    final bool isHoliday =
        isWeekendSunday ||
            leaveText.contains('holiday') ||
            leaveText.contains('off day') ||
            leaveText.contains('saturday');


    // ✅ Sunday label shouldn't block punch details
    final bool isLeaveDay = leave != null && !isSunLabel;

    // ✅ Sunday without punch should NOT become Absent
    final bool isAbsent = !hasPunch && !isLeaveDay && !isWeekendSunday;

    final duration = vm.workedDurationFor(_selectedDay!);
    final punchTimes =
    AttendanceCalendarController.getPunchInOut(logs);

    // ---------------- LATE MINUTES (BASED ONLY ON IN) ----------------
    int lateMinutes = 0;
    if (hasPunch) {
      final auth = context.read<AuthProvider>();
      final officeIn = auth.officeInTime;
      final firstPunch = punchTimes['in'];

      if (officeIn != null && firstPunch != null) {
        final officeInDT = DateTime(
          dateKey.year,
          dateKey.month,
          dateKey.day,
          officeIn.hour,
          officeIn.minute,
          officeIn.second,
        );

        if (firstPunch.isAfter(officeInDT)) {
          lateMinutes = firstPunch.difference(officeInDT).inMinutes;
        }
      }
    }

    final bool isLate = lateMinutes > 0;

    // ✅ FINAL RULES
    final auth = context.read<AuthProvider>();

    // ✅ target working minutes (fallback 8:30 = 510 minutes)
    final int targetMinutes = 8 * 60 + 30;
    final int workedMinutes = duration.inMinutes;
    // ✅ EARLY OUT: punched but worked less than target
    final bool isEarlyOut =
        hasPunch && workedMinutes > 0 && workedMinutes < targetMinutes;

    final int deficitMinutes = (targetMinutes - workedMinutes).clamp(
      0,
      1 << 30,
    );
    final double workedPct = targetMinutes == 0
        ? 0
        : workedMinutes / targetMinutes;
    final bool ignoreLateButtons = lateMinutes <= 5;

    // Movement + OD: only when punched and >50% worked and deficit 31..119

    final bool showMovementButton =
        !ignoreLateButtons &&
        !isLeaveDay &&
        !isWeekendSunday &&
        hasPunch &&
        ((workedPct > 0.50 && deficitMinutes >= 31 && deficitMinutes < 120) ||
            isEarlyOut);

    final bool showOtButton = isWeekendSunday && hasPunch;

    String format(Duration d) =>
        '${d.inHours.toString().padLeft(2, '0')}h '
        '${d.inMinutes.remainder(60).toString().padLeft(2, '0')}m';

    String formatTime(DateTime? dt) {
      if (dt == null) return '--';
      final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
      return '$h:${dt.minute.toString().padLeft(2, '0')} '
          '${dt.hour >= 12 ? 'PM' : 'AM'}';
    }

    // ✅ UPDATED STATUS for Sunday
    final String status = hasUpdatedStatus
        ? updatedStatus!
        : isWeekendSunday
        ? (hasPunch ? 'Sunday Punch' : 'Sunday')
        : isLeaveDay
        ? leave!
        : hasPunch
        ? (isLate ? 'Late Punch' : 'On Time')
        : 'Absent';

    final Color statusColor = hasUpdatedStatus
        ? AttendanceCalendarController.statusColor(updatedStatus!)
        : isWeekendSunday
        ? AttendanceCalendarController.leaveColor('SUN')
        : isLeaveDay
        ? AttendanceCalendarController.leaveColor(leave!)
        : isAbsent
        ? AppColors.error
        : isLate
        ? AppColors.warning
        : AppColors.success;

    return Column(
      children: [
        AttendanceStatusCard(
          isLeave: isLeaveDay,
          isHoliday: isHoliday,
          showMovementButton: showMovementButton,
          showOtButton: showOtButton,
          selectedDate:
          '${_selectedDay!.day.toString().padLeft(2, '0')}/'
              '${_selectedDay!.month.toString().padLeft(2, '0')}/'
              '${_selectedDay!.year}',
          status: status,
          statusColor: statusColor,
          lateMinutes: lateMinutes,
          isAbsent: isAbsent,
          hasPunch: hasPunch,
          workedDuration: duration,
          canShowActions: canShowActions,
          punchInTime: formatTime(punchTimes['in']),
          punchOutTime: formatTime(punchTimes['out']),
          onApplyLeave: () {
            Navigator.pushNamed(
              context,
              'ApplyLeavesView',
              arguments: {
                'date': _selectedDay,
              },
            );
          },
        ),

        AttendanceOTCard(
          visible: canShowActions && showOtButton,
          selectedDay: _selectedDay,
        ),

        if (vm.monthSummary.isNotEmpty) ...[
          AttendanceMonthDetailsCard(
            details: vm.monthSummary,
          ),
        ],
      ],
    );
  }
  bool _isLateDay(List<PunchLogItem> logs, DateTime dateKey) {
    final valid = logs.where((e) => e.isValidPunch).toList();
    if (valid.isEmpty) return false;

    final firstPunch =
    AttendanceCalendarController.parsePunchDateTime(valid.first);
    if (firstPunch == null) return false;

    final auth = context.read<AuthProvider>();
    final officeIn = auth.officeInTime;

    final threshold = DateTime(
      dateKey.year,
      dateKey.month,
      dateKey.day,
      officeIn?.hour ?? lateHour,
      officeIn?.minute ?? lateMinute,
      officeIn?.second ?? 0,
    );

    return firstPunch.isAfter(threshold);
  }

}
