import 'package:flutter/material.dart';

import '../models/model_punching.dart';
import '../services/punching_service.dart';

class PunchingProvider with ChangeNotifier {
  PunchResponseModel? _punchResponse;
  bool _isLoading = false;
  String? _error;

  PunchResponseModel? get punchResponse => _punchResponse;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // -------------------- HELPERS --------------------

  DateTime _dateKey(DateTime d) => DateTime(d.year, d.month, d.day);

  DateTime? _parsePunchTimeToDateTime(String timeText, DateTime day) {
    final t = timeText.trim();
    if (t.isEmpty || t == '--') return null;

    // Expected: "09:24:51 AM" OR "06:01:26 PM" OR "09:24 AM"
    // Also may have "12:00:00 AM" for leave day.
    final parts = t.split(' ');
    if (parts.length < 2) return null;

    final clock = parts[0]; // hh:mm:ss
    final ampm = parts[1].toUpperCase(); // AM/PM

    final timeParts = clock.split(':');
    if (timeParts.length < 2) return null;

    final hh = int.tryParse(timeParts[0]) ?? 0;
    final mm = int.tryParse(timeParts[1]) ?? 0;
    final ss = timeParts.length >= 3 ? (int.tryParse(timeParts[2]) ?? 0) : 0;

    int hour24 = hh % 12;
    if (ampm == 'PM') hour24 += 12;

    return DateTime(day.year, day.month, day.day, hour24, mm, ss);
  }

  /// ignore SUN/leave/invalid punches for in/out checks
  bool _isRealPunch(PunchingTime p) {
    final type = p.punchType.trim().toUpperCase();
    if (type == 'SUN') return false;
    if (type.contains('LEAVE')) return false;
    if (type.contains('HOLIDAY')) return false;

    // ✅ NEW (safe): exclude status rows (so they don't affect punch-in/out)
    if (type.contains('PENDING') ||
        type.contains('APPROVED') ||
        type.contains('REJECT') ||
        type.contains('CANCEL') ||
        type.contains('APPLIED') ||
        type.contains('REQUEST')) {
      return false;
    }

    if (p.time.trim() == '--') return false;
    return true;
  }

  // ✅ NEW: key builder to avoid mixing multiple employees on same date
  String _mergeKey(PunchDayLog log, {required bool teamMode}) {
    final date = (log.punchDate).trim();
    if (!teamMode) return date;
    return '${log.employeeCode}|$date';
  }

  /// If API returns duplicate PunchDate entries, merge them into one.
  /// ✅ UPDATED: merges punchingTimes + photos, and safe for team data.
  List<PunchDayLog> _mergeDuplicateDates(List<PunchDayLog> input) {
    final map = <String, PunchDayLog>{};

    // ✅ NEW: detect multi-employee response (team data)
    final empSet = <int>{};
    for (final x in input) {
      empSet.add(x.employeeCode);
    }
    final bool teamMode = empSet.length > 1;

    for (final log in input) {
      final rawDate = log.punchDate;
      if (rawDate.trim().isEmpty) continue;

      final key = _mergeKey(log, teamMode: teamMode);

      if (!map.containsKey(key)) {
        map[key] = log;
      } else {
        final existing = map[key]!;

        // ---------------- merge punchingTimes ----------------
        final merged = <PunchingTime>[
          ...existing.punchingTimes,
          ...log.punchingTimes,
        ];

        // remove duplicates (same time+type+location+lateCount)
        final seen = <String>{};
        final unique = <PunchingTime>[];
        for (final p in merged) {
          final sig = '${p.time}|${p.punchType}|${p.location}|${p.lateCount}';
          if (seen.add(sig)) unique.add(p);
        }

        // ---------------- ✅ NEW: merge photos ----------------
        final mergedPhotos = <PunchPhoto>[
          ...existing.photos,
          ...log.photos,
        ];

        // remove duplicates (prefer filename; fallback base64 length)
        final photoSeen = <String>{};
        final uniquePhotos = <PunchPhoto>[];
        for (final ph in mergedPhotos) {
          final k = (ph.fileName ?? '').trim().isNotEmpty
              ? (ph.fileName ?? '').trim()
              : 'b64_${(ph.fileContent ?? '').trim().length}';
          if (photoSeen.add(k)) uniquePhotos.add(ph);
        }

        map[key] = PunchDayLog(
          employeeCode: existing.employeeCode != 0
              ? existing.employeeCode
              : log.employeeCode,
          punchDate: existing.punchDate.isNotEmpty
              ? existing.punchDate
              : log.punchDate,
          punchingTimes: unique,
          photos: uniquePhotos, // ✅ keep both IN + OUT photos
        );
      }
    }

    // keep sorted by date
    final list = map.values.toList();

    // ✅ keep your original sort behavior (ascending)
    list.sort((a, b) => a.punchDate.compareTo(b.punchDate));

    return list;
  }

  List<PunchDayLog> get _logs {
    final raw = _punchResponse?.result ?? const <PunchDayLog>[];
    return _mergeDuplicateDates(raw);
  }

  List<PunchingTime> punchesForDate(DateTime date) {
    final key = _dateKey(date);

    final log = _logs.firstWhere(
          (e) {
        final d = DateTime.tryParse(e.punchDate);
        if (d == null) return false;
        return _dateKey(d) == key;
      },
      orElse: () =>
          PunchDayLog(employeeCode: 0, punchDate: '', punchingTimes: const []),
    );

    return log.punchingTimes;
  }

  List<PunchingTime> get todayPunches => punchesForDate(DateTime.now());

  List<PunchingTime> _todayPunchingTimes() => todayPunches;

  // ✅ NEW: today photos (IN+OUT) if needed anywhere in UI (optional usage)
  List<PunchPhoto> get todayPhotos {
    final key = _dateKey(DateTime.now());
    final log = _logs.firstWhere(
          (e) {
        final d = DateTime.tryParse(e.punchDate);
        if (d == null) return false;
        return _dateKey(d) == key;
      },
      orElse: () =>
          PunchDayLog(employeeCode: 0, punchDate: '', punchingTimes: const []),
    );
    return log.photos;
  }

  // -------------------- BUSINESS LOGIC --------------------

  bool isPunchInBeforeNineThirty() {
    try {
      final list = _todayPunchingTimes().where(_isRealPunch).toList();
      if (list.isEmpty) return false;

      final today = DateTime.now();
      final first = list.first;

      final punchDT = _parsePunchTimeToDateTime(first.time, today);
      if (punchDT == null) return false;

      final threshold = DateTime(today.year, today.month, today.day, 9, 30);
      return punchDT.isBefore(threshold);
    } catch (e) {
      debugPrint("❌ Error checking punch-in time: $e");
      return false;
    }
  }

  bool isPunchOutAfterSix() {
    try {
      final list = _todayPunchingTimes().where(_isRealPunch).toList();
      if (list.length < 2) return false;

      final today = DateTime.now();
      final last = list.last;

      final punchOutDT = _parsePunchTimeToDateTime(last.time, today);
      if (punchOutDT == null) return false;

      final sixPM = DateTime(today.year, today.month, today.day, 18, 0);
      return punchOutDT.isAfter(sixPM);
    } catch (e) {
      debugPrint("❌ Error checking punch-out time: $e");
      return false;
    }
  }

  String? get punchOutTime {
    try {
      final list = _todayPunchingTimes().where(_isRealPunch).toList();
      if (list.length >= 2) return list.last.time;
    } catch (e) {
      debugPrint("❌ Error getting punch-out time: $e");
    }
    return null;
  }

  // -------------------- API --------------------

  Future<void> fetchTodayPunchingDetails(BuildContext context) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response =
      await punchingDetailsServices.punchingToday(context: context);

      if (response != null && response.result.isNotEmpty) {
        _punchResponse = response;
      } else {
        _error = "No punching data found";
      }
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  void clearPunchData() {
    _punchResponse = null;
    notifyListeners();
  }
}
