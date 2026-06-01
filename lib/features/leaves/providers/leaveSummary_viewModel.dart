import 'package:flutter/material.dart';
import '../models/model_leaveSummery.dart';
import '../services/leave_summeryServices.dart';

class LeaveSummaryProvider with ChangeNotifier {

  LeaveSummaryProvider({LeaveSummaryService? service})
      : _service = service ?? LeaveSummaryService();

  final LeaveSummaryService _service;

  // UI state
  bool _isLoading = false;
  String? _error;
  LeaveSummaryResponse? _response;

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  LeaveSummaryResponse? get response => _response;

  // Convenience list for UI
  List<LeaveRecord> get records => _response?.table1 ?? const [];

  // -------- Actions --------

  /// Initial load or reload with current filters.
  Future<bool> load({required BuildContext context}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final res = await _service.fetchMyLeaveSummary(
      context: context,
    );

    _isLoading = false;
    if (res == null) {
      _response = null;
      _error = 'Failed to fetch leave summary';
      notifyListeners();
      return false;
    }
    _response = res;
    notifyListeners();
    return true;
  }

  void reset() {
    _isLoading = false;
    _error = null;
    _response = null;
    notifyListeners();
  }
}
