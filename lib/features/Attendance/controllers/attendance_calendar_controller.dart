import 'package:clams/constants/app_colors.dart';
import 'package:clams/features/Attendance/models/model_punch_log.dart';
import 'package:flutter/material.dart';

class AttendanceCalendarController {
  AttendanceCalendarController._();

  static const int lateHour = 9;
  static const int lateMinute = 35;

  static String? leaveLabel(List<PunchLogItem> logs) {
    for (final e in logs) {
      final p = (e.punchType ?? '').toUpperCase();

      if (p == 'SUN') return 'SUN';

      if (!p.contains('PUNCH')) {
        return e.punchType;
      }
    }
    return null;
  }

  static String? updatedStatusLabel(List<PunchLogItem> logs) {
    for (final e in logs) {
      final raw = (e.punchType ?? '').trim();

      if (raw.isEmpty) continue;

      final u = raw.toUpperCase();

      if (u.contains('PUNCH')) continue;

      if (u.contains('PENDING') ||
          u.contains('APPROVED') ||
          u.contains('REJECT') ||
          u.contains('CANCEL') ||
          u.contains('APPLIED') ||
          u.contains('SUBMITTED') ||
          u.contains('REQUEST')) {
        return raw;
      }

      if (u.contains('OT') ||
          u.contains('OVERTIME') ||
          u.contains('MOVEMENT') ||
          u.contains('OFFICIAL DUTY') ||
          u == 'OD' ||
          u.contains('LEAVE')) {
        return raw;
      }
    }

    return null;
  }

  static Color statusColor(String statusText) {
    final u = statusText.trim().toUpperCase();

    if (u.contains('APPROVED')) return AppColors.success;

    if (u.contains('PENDING') ||
        u.contains('APPLIED') ||
        u.contains('SUBMITTED')) {
      return AppColors.warning;
    }

    if (u.contains('REJECT') || u.contains('CANCEL')) {
      return AppColors.error;
    }

    if (u.contains('EARNED')) return AppColors.earnedLeave;
    if (u.contains('CASUAL')) return AppColors.casualLeave;
    if (u.contains('OFFICIAL DUTY') || u == 'OD') {
      return AppColors.officialDuty;
    }
    if (u.contains('SICK')) return AppColors.sickLeave;
    if (u.contains('LOSS OF PAY') || u.contains('LOP')) {
      return AppColors.lossOfPay;
    }
    if (u.contains('COMPENSATORY') || u.contains('COMP')) {
      return AppColors.compensatoryOff;
    }
    if (u.contains('OFF DAY')) return AppColors.offDay;
    if (u.contains('OWN MARRIAGE')) return AppColors.ownMarriage;
    if (u.contains('MATERNITY')) return AppColors.maternityLeave;
    if (u.contains('PATERNITY')) return AppColors.paternityLeave;
    if (u.contains('BEREAVEMENT')) return AppColors.bereavementLeave;
    if (u.contains("CHILD'S MARRIAGE")) return AppColors.childMarriage;
    if (u.contains('STERILIZATION')) {
      return AppColors.sterilizationLeave;
    }
    if (u.contains('SATURDAY')) return AppColors.saturdayOff;
    if (u.contains('SUNDAY') || u == 'SUN') {
      return AppColors.sundayOff;
    }

    return AppColors.primaryColor;
  }

  static Color leaveColor(String leaveType) {
    final t = leaveType.trim().toLowerCase();

    if (t == 'sun' || t.contains('sunday')) {
      return AppColors.sundayOff;
    }

    if (t.contains('saturday')) {
      return AppColors.saturdayOff;
    }

    if (t.contains('earned') || t == 'el') {
      return AppColors.earnedLeave;
    }

    if (t.contains('casual') || t == 'cl') {
      return AppColors.casualLeave;
    }

    if (t.contains('official duty') || t == 'od') {
      return AppColors.officialDuty;
    }

    if (t.contains('sick') || t == 'sl') {
      return AppColors.sickLeave;
    }

    if (t.contains('loss of pay') || t.contains('lop')) {
      return AppColors.lossOfPay;
    }

    if (t.contains('compensatory') || t.contains('comp')) {
      return AppColors.compensatoryOff;
    }

    if (t.contains('off day')) {
      return AppColors.offDay;
    }

    if (t.contains('own marriage')) {
      return AppColors.ownMarriage;
    }

    if (t.contains('maternity')) {
      return AppColors.maternityLeave;
    }

    if (t.contains('paternity')) {
      return AppColors.paternityLeave;
    }

    if (t.contains('bereavement')) {
      return AppColors.bereavementLeave;
    }

    if (t.contains("child's marriage")) {
      return AppColors.childMarriage;
    }

    if (t.contains('sterilization')) {
      return AppColors.sterilizationLeave;
    }

    return AppColors.primarySecondary;
  }

  static DateTime? parsePunchDateTime(PunchLogItem item) {
    try {
      final parts = item.punchTime.split(' ');
      final hms = parts[0].split(':');

      int h = int.parse(hms[0]);
      final m = int.parse(hms[1]);
      final s = int.parse(hms[2]);

      if (parts[1] == 'PM' && h != 12) h += 12;
      if (parts[1] == 'AM' && h == 12) h = 0;

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

  static Map<String, DateTime?> getPunchInOut(List<PunchLogItem> logs) {
    final valid = logs.where((e) => e.isValidPunch).toList();

    if (valid.isEmpty) {
      return {
        'in': null,
        'out': null,
      };
    }

    DateTime? first;
    DateTime? last;

    for (final e in valid) {
      final dt = parsePunchDateTime(e);

      if (dt == null) continue;

      first ??= dt;
      last = dt;
    }

    return {
      'in': first,
      'out': last,
    };
  }
}