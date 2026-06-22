// lib/features/movement/viewModels/movement_report_provider.dart

import 'package:flutter/material.dart';
import '../models/viewMovement_model.dart';
import '../services/viewMovement_services.dart';

class MovementReportProvider with ChangeNotifier {
  MovementReportProvider({MovementViewServices? service})
      : _service = service ?? MovementViewServices();

  final MovementViewServices _service;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  MovementReportResponse? _lastResponse;
  MovementReportResponse? get lastResponse => _lastResponse;

  List<MovementReportItem> get items => _lastResponse?.result ?? [];

  // ---------------------------------------------------------------------------
  // 🔵 FILTER STATE
  // ---------------------------------------------------------------------------
  DateTime? fromDate;
  DateTime? toDate;

  /// UI filter (string) – only used to filter list inside UI
  String? status;

  /// Actual ID for API
  int? _statusIndex;
  int? get statusIndex => _statusIndex;

  void setStatusIndex(int? index) {
    _statusIndex = index;
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // 🔵 SET DATE RANGE
  // ---------------------------------------------------------------------------
  void setDateRange(DateTimeRange range) {
    fromDate = range.start;
    toDate = range.end;
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // 🔵 SET STATUS (STRING FOR UI FILTERING)
  // ---------------------------------------------------------------------------
  void setStatus(String? value) {
    status = value;
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // 🔵 CLEAR FILTERS
  // ---------------------------------------------------------------------------
  void clearFilters() {
    fromDate = null;
    toDate = null;
    status = null;
    _statusIndex = null;
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // 🔵 FETCH REPORTS (WITH FILTERS)
  // ---------------------------------------------------------------------------
  Future<bool> fetchReports({
    required BuildContext context,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      String? fromStr;
      String? toStr;

      if (fromDate != null) {
        fromStr = "${fromDate!.year}-${_pad(fromDate!.month)}-${_pad(fromDate!.day)}";
      }

      if (toDate != null) {
        toStr = "${toDate!.year}-${_pad(toDate!.month)}-${_pad(toDate!.day)}";
      }

      final res = await _service.movementView(
        context: context,
        fromDate: fromStr,
        toDate: toStr,

        /// IMPORTANT: Now API receives index (int) not text
        statusId: _statusIndex,
      );

      _lastResponse = res;
      final ok = res != null && res.result.isNotEmpty;

      return ok;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ---------------------------------------------------------------------------
  // 🔵 RESET
  // ---------------------------------------------------------------------------
  void reset() {
    _isLoading = false;
    _error = null;
    _lastResponse = null;
    clearFilters();
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // HELPER
  // ---------------------------------------------------------------------------
  String _pad(int v) => v.toString().padLeft(2, '0');
}
