import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/working_duration_response_model.dart';
import '../services/employee_working_duration_service.dart';

class EmployeeWorkingDurationViewModel with ChangeNotifier {
  EmployeeWorkingDurationViewModel({
    EmployeeWorkingDurationService? service,
  }) : _service = service ?? EmployeeWorkingDurationService();

  final EmployeeWorkingDurationService _service;

  // ---------------- STATE ----------------
  bool _isLoading = false;
  String? _error;
  WorkingDurationResponse? _response;

  bool get isLoading => _isLoading;
  String? get error => _error;
  WorkingDurationResponse? get response => _response;

  bool get hasData => _response?.data.isNotEmpty == true;

  WorkingDurationData? get today =>
      _response?.data.isNotEmpty == true ? _response!.data.first : null;

  // ---------------- COMPUTED HELPERS ----------------

  /// Total worked duration (safe)
  Duration get workedDuration =>
      Duration(seconds: today?.totalSeconds ?? 0);

  /// HH:MM formatted
  String get workedHHMM {
    final d = workedDuration;
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    return '${h.toString().padLeft(2, '0')}:'
        '${m.toString().padLeft(2, '0')}';
  }

  /// Completion ratio (0 → 1 for 9 hours)
  double progress({int maxHours = 9}) {
    if (maxHours <= 0) return 0;
    return (workedDuration.inMinutes / (maxHours * 60))
        .clamp(0.0, 1.5);
  }

  /// Status text for UI
  String statusText({int maxHours = 9}) {
    final mins = workedDuration.inMinutes;
    final target = maxHours * 60;

    if (mins >= target) {
      return mins > target ? 'Overtime' : 'Target Achieved';
    }
    if (mins >= target * 0.5) return 'In Progress';
    return 'Just Started';
  }

  // ---------------- API CALL ----------------

  Future<bool> fetchTodayWorkingDuration({
    required BuildContext context,
    String? employeeCode,
  }) async {
    _setLoading(true);

    try {
      final res = await _service.fetchEmployeeWorkingDuration(
        context: context,
        employeeCode: employeeCode,
      );

      if (res == null) {
        _setError('Failed to fetch working duration');
        return false;
      }

      _response = res;
      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Unexpected error: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ---------------- UTILITIES ----------------

  void reset() {
    _isLoading = false;
    _error = null;
    _response = null;
    notifyListeners();
  }

  void _setLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }

  void _setError(String msg) {
    _error = msg;
    _response = null;
    notifyListeners();
  }
}
