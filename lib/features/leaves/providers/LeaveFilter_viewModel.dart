import 'package:flutter/material.dart';

/// LEAVE STATUS FILTER
enum LeaveFilter { all, pending, approved, cancelled, byDate }

/// SORTING OPTIONS
enum LeaveSort {
  none,
  latestFirst,
  oldestFirst,
  shortest,
  longest,
}

class LeaveFilterProvider with ChangeNotifier {
  LeaveFilter _filter = LeaveFilter.all;
  DateTimeRange? _dateRange;
  String? _leaveTypeFilter;
  LeaveSort _sort = LeaveSort.none;

  // -------------------- GETTERS --------------------
  LeaveFilter get filter => _filter;
  DateTimeRange? get dateRange => _dateRange;
  String? get leaveTypeFilter => _leaveTypeFilter;
  LeaveSort get sort => _sort;

  /// List for dropdown / chips
  List<String> get leaveTypeOptions => const [
    'All Types',
    'Earned Leave',
    'Casual Leave',
    'Official Duty',
    'Sick Leave',
    'Loss of Pay',
    'Compensatory Off',
    'Off Day',
    'Own Marriage Leave',
    'Maternity Leave',
    'Paternity Leave',
    "Bereavement Leave",
    "Child's Marriage Leave",
    "Sterilization Leave",
    "Saturday Off",
  ];

  // -------------------- FILTER SETTERS --------------------

  void setFilter(LeaveFilter next) {
    _filter = next;
    notifyListeners();
  }

  void setDateRange(DateTimeRange range) {
    _dateRange = range;
    _filter = LeaveFilter.byDate; // auto-apply date mode
    notifyListeners();
  }

  void clearDateRange() {
    _dateRange = null;
    notifyListeners();
  }

  void setLeaveTypeFilter(String? type) {
    if (type == null || type == 'All Types') {
      _leaveTypeFilter = null;
    } else {
      _leaveTypeFilter = type;
    }
    notifyListeners();
  }

  // -------------------- SORT SETTER --------------------
  void setSort(LeaveSort value) {
    _sort = value;
    notifyListeners();
  }
}
