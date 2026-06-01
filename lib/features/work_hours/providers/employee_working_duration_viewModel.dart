import 'dart:async';

import 'package:clams/features/Authentication/models/model_login.dart';
import 'package:flutter/material.dart';

class EmployeeWorkingDurationViewModel
    extends ChangeNotifier {

  EmployeeData? _employee;

  Timer? _timer;

  Duration _liveDuration = Duration.zero;

  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;

  String? get error => _error;

  Duration get workedDuration => _liveDuration;

  void setEmployee(EmployeeData employee) {
    _employee = employee;
    _startLiveTimer();
  }

  DateTime _parseTime(String value) {
    final now = DateTime.now();

    final parts = value.split(' ');

    final timeParts =
    parts[0].split(':');

    int hour =
        int.tryParse(timeParts[0]) ?? 0;

    final minute =
        int.tryParse(timeParts[1]) ?? 0;

    final second =
        int.tryParse(timeParts[2]) ?? 0;

    final amPm =
    parts.length > 1 ? parts[1] : '';

    if (amPm == 'PM' && hour != 12) {
      hour += 12;
    }

    if (amPm == 'AM' && hour == 12) {
      hour = 0;
    }

    return DateTime(
      now.year,
      now.month,
      now.day,
      hour,
      minute,
      second,
    );
  }

  Duration get targetDuration {
    if (_employee == null) {
      return const Duration(hours: 9);
    }

    final mrIn =
    _parseTime(_employee!.attMrIn);

    final evLimit =
    _parseTime(_employee!.attEvLimit);

    return evLimit.difference(mrIn);
  }

  Duration get remainingDuration {
    if (workedDuration >= targetDuration) {
      return Duration.zero;
    }

    return targetDuration - workedDuration;
  }

  double get progress {
    if (targetDuration.inSeconds == 0) {
      return 0;
    }

    return workedDuration.inSeconds /
        targetDuration.inSeconds;
  }

  String get statusText {
    final workedMinutes =
        workedDuration.inMinutes;

    final targetMinutes =
        targetDuration.inMinutes;

    if (workedMinutes >= targetMinutes) {
      return workedMinutes >
          targetMinutes
          ? 'Overtime'
          : 'Target Achieved';
    }

    if (workedMinutes >=
        targetMinutes * .5) {
      return 'In Progress';
    }

    return 'Just Started';
  }

  String get workedHHMM {
    final h = workedDuration.inHours;
    final m = workedDuration.inMinutes
        .remainder(60);

    return '${h.toString().padLeft(2, '0')}:'
        '${m.toString().padLeft(2, '0')}';
  }

  void _updateWorkedDuration() {
    if (_employee == null) return;

    final now = DateTime.now();

    final mrIn =
    _parseTime(_employee!.attMrIn);

    final mrOut =
    _parseTime(_employee!.attMrOut);

    final evLimit =
    _parseTime(_employee!.attEvLimit);

    /// Before check-in
    if (now.isBefore(mrIn)) {
      _liveDuration = Duration.zero;
      return;
    }

    /// Morning session
    if (now.isBefore(mrOut)) {
      _liveDuration =
          now.difference(mrIn);
      return;
    }

    /// Afternoon session
    if (now.isBefore(evLimit)) {
      final morningDuration =
      mrOut.difference(mrIn);

      final afternoonDuration =
      now.difference(mrOut);

      _liveDuration =
          morningDuration +
              afternoonDuration;

      return;
    }

    /// After office hours
    _liveDuration =
        evLimit.difference(mrIn);
  }

  void _startLiveTimer() {
    _timer?.cancel();

    _updateWorkedDuration();

    notifyListeners();

    _timer = Timer.periodic(
      const Duration(seconds: 1),
          (_) {
        _updateWorkedDuration();
        notifyListeners();
      },
    );
  }

  void stopTimer() {
    _timer?.cancel();
  }

  void reset() {
    _timer?.cancel();

    _employee = null;
    _liveDuration = Duration.zero;
    _error = null;

    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}