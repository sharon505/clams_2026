import 'package:clams/constants/app_colors.dart';
import 'package:clams/features/Attendance/models/model_punch_log.dart';
import 'package:clams/features/Attendance/services/my_attendance_service.dart';
import 'package:clams/features/Attendance/widgets/attendance_month_details_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class PunchLogViewModel with ChangeNotifier {
  PunchLogViewModel({PunchLogService? service})
      : _service = service ?? PunchLogService();

  final PunchLogService _service;

  bool _isLoading = false;
  String? _error;
  PunchLogResponse? _response;

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<PunchLogItem> get logs => _response?.result ?? [];

  final _fmt = DateFormat('yyyy-MM-dd');

  bool hasLeave(DateTime day) {
    final key = DateTime(day.year, day.month, day.day);
    return (groupedByDate[key] ?? []).any((e) => e.isLeave);
  }

  bool hasMovement(DateTime day) {
    final key = DateTime(day.year, day.month, day.day);
    return (groupedByDate[key] ?? []).any((e) => e.isMovement);
  }

  bool hasOfficialDuty(DateTime day) {
    final key = DateTime(day.year, day.month, day.day);
    return (groupedByDate[key] ?? []).any((e) => e.isOfficialDuty);
  }

  bool hasHalfDay(DateTime day) {
    final key = DateTime(day.year, day.month, day.day);
    return (groupedByDate[key] ?? []).any((e) => e.isHalfDay);
  }

  List<AttendanceMonthDetail> get monthSummary {
    final List<AttendanceMonthDetail> list = [];

    for (final log in logs) {
      if (log.workDate == null) continue;

      final type = (log.punchType ?? '').trim();

      if (type.isEmpty) continue;

      // Remove normal punches
      if (type.toUpperCase().contains('PUNCH')) continue;

      // ✅ Remove Sundays
      if (type.toUpperCase() == 'SUN' ||
          type.toLowerCase().contains('sunday')) {
        continue;
      }

      list.add(
        AttendanceMonthDetail(
          title: type,
          date: DateFormat('dd/MM/yyyy').format(log.workDate!),
          color: _summaryColor(type),
        ),
      );
    }

    return list;
  }

  Color _summaryColor(String type) {
    final t = type.toLowerCase();

    if (t.contains('casual')) return AppColors.casualLeave;
    if (t.contains('earned')) return AppColors.earnedLeave;
    if (t.contains('official duty') || t == 'od') {
      return AppColors.officialDuty;
    }
    if (t.contains('movement')) return AppColors.warning;
    if (t.contains('saturday')) return AppColors.saturdayOff;
    if (t.contains('sun')) return AppColors.sundayOff;
    if (t.contains('sick')) return AppColors.sickLeave;
    if (t.contains('loss of pay') || t.contains('lop')) {
      return AppColors.lossOfPay;
    }
    if (t.contains('comp')) return AppColors.compensatoryOff;
    if (t.contains('maternity')) return AppColors.maternityLeave;
    if (t.contains('paternity')) return AppColors.paternityLeave;

    return AppColors.primaryColor;
  }

  // --------------------------------------------------
  // DEFAULT DATE RANGE
  // last month 25 → today
  // --------------------------------------------------
  Map<String, String> _defaultRange() {
    final now = DateTime.now();

    final lastMonth = DateTime(now.year, now.month - 1, 25);
    final today = DateTime(now.year, now.month, now.day);

    return {
      'from': _fmt.format(lastMonth),
      'to': _fmt.format(today),
    };
  }

  // ---------------- API ----------------

  Future<void> fetchForMonth({
    required BuildContext context,
    required DateTime month,
  }) async {
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);

    String fmt(DateTime d) =>
        '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

    await fetchPunchLogs(
      context: context,
      from: fmt(firstDay),
      to: fmt(lastDay),
    );
  }


  Future<void> fetchPunchLogs({
    required BuildContext context,
    String? from,
    String? to,
  }) async {
    _isLoading = true;
    notifyListeners();

    final range = _defaultRange();

    final res = await _service.fetchPunchLog(
      context: context,
      processFrom: (from == null || from.isEmpty) ? range['from']! : from,
      processTo: (to == null || to.isEmpty) ? range['to']! : to,
    );

    if (res == null) {
      _error = 'Failed to load punch logs';
      _response = null;
    } else {
      _response = res;
      _error = null;
    }

    _isLoading = false;
    notifyListeners();
  }

  // ---------------- HELPERS ----------------


  /// Group logs by date
  Map<DateTime, List<PunchLogItem>> get groupedByDate {
    final map = <DateTime, List<PunchLogItem>>{};

    for (final log in logs) {
      if (log.workDate == null) continue;

      final day = DateTime(
        log.workDate!.year,
        log.workDate!.month,
        log.workDate!.day,
      );

      map.putIfAbsent(day, () => []);
      map[day]!.add(log);
    }
    return map;
  }

  /// Calculate worked duration for a day
  Duration workedDurationFor(DateTime date) {
    final key = DateTime(date.year, date.month, date.day);
    final list = groupedByDate[key] ?? [];

    final valid = list.where((e) => e.isValidPunch).toList();
    if (valid.length < 2) return Duration.zero;

    DateTime? inTime;
    DateTime? outTime;

    for (final p in valid) {
      final dt = _parsePunchDateTime(p);
      if (dt == null) continue;
      inTime ??= dt;
      outTime = dt;
    }

    if (inTime == null || outTime == null) return Duration.zero;
    return outTime.difference(inTime);
  }

  DateTime? _parsePunchDateTime(PunchLogItem item) {
    if (!item.isValidPunch || item.workDate == null) return null;

    try {
      final parts = item.punchTime.split(' ');
      final hms = parts[0].split(':');

      int h = int.parse(hms[0]);
      final m = int.parse(hms[1]);
      final s = int.parse(hms[2]);

      final isPM = parts[1].toUpperCase() == 'PM';
      if (isPM && h != 12) h += 12;
      if (!isPM && h == 12) h = 0;

      return DateTime(
        item.workDate!.year,
        item.workDate!.month,
        item.workDate!.day,
        h,
        m,
        s,
      );
    } catch (_) {
      return null;
    }
  }
}
