import 'package:flutter/material.dart';

import '../models/model_leaveSummery.dart';
import '../services/leave_summeryServices.dart';
import 'LeaveFilter_viewModel.dart';

class LeaveSummaryProvider with ChangeNotifier {
  LeaveSummaryProvider({
    LeaveSummaryService? service,
  }) : _service = service ?? LeaveSummaryService();

  final LeaveSummaryService _service;

  bool _isLoading = false;
  String? _error;
  LeaveSummaryResponse? _response;

  bool get isLoading => _isLoading;
  String? get error => _error;
  LeaveSummaryResponse? get response => _response;

  List<LeaveRecord> get records => _response?.table1 ?? const [];

  /// Date Filter
  DateTimeRange? _dateRange;

  DateTimeRange? get dateRange => _dateRange;

  void setDateRange(DateTimeRange range) {
    _dateRange = range;
    notifyListeners();
  }

  void clearDateRange() {
    _dateRange = null;
    notifyListeners();
  }

  /// Leave Type Filter
  String? _leaveTypeFilter;

  String? get leaveTypeFilter => _leaveTypeFilter;

  void setLeaveTypeFilter(String? value) {
    if (value == null || value == "All Types") {
      _leaveTypeFilter = null;
    } else {
      _leaveTypeFilter = value;
    }

    notifyListeners();
  }

  void clearLeaveTypeFilter() {
    _leaveTypeFilter = null;
    notifyListeners();
  }

  /// Status Lists
  final Map<LeaveFilter, List<LeaveRecord>> leaveMap = {
    LeaveFilter.all: [],
    LeaveFilter.approved: [],
    LeaveFilter.pending: [],
    LeaveFilter.cancelled: [],
  };

  List<LeaveRecord> getLeaves(LeaveFilter filter) {
    List<LeaveRecord> data =
    List<LeaveRecord>.from(leaveMap[filter] ?? []);

    // Leave Type Filter
    if (_leaveTypeFilter != null) {
      data = data.where((item) {
        return item.leaveType.trim().toLowerCase() ==
            _leaveTypeFilter!.trim().toLowerCase();
      }).toList();
    }

    // Date Filter
    if (_dateRange != null) {
      data = data.where((item) {
        final date = _parseDate(item.appliedDate);

        if (date == null) return false;

        return !date.isBefore(_dateRange!.start) &&
            !date.isAfter(_dateRange!.end);
      }).toList();
    }

    return data;
  }

  DateTime? _parseDate(String value) {
    try {
      return DateTime.parse(value);
    } catch (_) {}

    try {
      final parts = value.split('/');
      if (parts.length == 3) {
        return DateTime(
          int.parse(parts[2]),
          int.parse(parts[1]),
          int.parse(parts[0]),
        );
      }
    } catch (_) {}

    return null;
  }

  void _prepareLists() {
    final data = _response?.table1 ?? [];

    leaveMap[LeaveFilter.all] = List.from(data);

    leaveMap[LeaveFilter.approved] = [];
    leaveMap[LeaveFilter.pending] = [];
    leaveMap[LeaveFilter.cancelled] = [];

    for (final item in data) {
      final status = item.status.trim().toLowerCase();

      debugPrint("Status From API => '$status'");

      if (status.contains("approved")) {
        leaveMap[LeaveFilter.approved]!.add(item);
      } else if (status.contains("pending")) {
        leaveMap[LeaveFilter.pending]!.add(item);
      } else if (status.contains("cancel") ||
          status.contains("reject")) {
        leaveMap[LeaveFilter.cancelled]!.add(item);
      }
    }

    // debugPrint("All = ${leaveMap[LeaveFilter.all]!.length}");
    // debugPrint("Approved = ${leaveMap[LeaveFilter.approved]!.length}");
    // debugPrint("Pending = ${leaveMap[LeaveFilter.pending]!.length}");
    // debugPrint("Cancelled = ${leaveMap[LeaveFilter.cancelled]!.length}");
  }

  Future<bool> load({
    required BuildContext context,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final res = await _service.fetchMyLeaveSummary(
      context: context,
    );

    _isLoading = false;

    if (res == null) {
      _response = null;
      _error = "Failed to fetch leave summary";

      for (final key in leaveMap.keys) {
        leaveMap[key] = [];
      }

      notifyListeners();
      return false;
    }

    _response = res;

    _prepareLists();

    notifyListeners();

    return true;
  }

  void reset() {
    _isLoading = false;
    _error = null;
    _response = null;
    _dateRange = null;
    _leaveTypeFilter = null;

    for (final key in leaveMap.keys) {
      leaveMap[key] = [];
    }

    notifyListeners();
  }
}