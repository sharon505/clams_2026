import 'package:flutter/material.dart';
import '../models/model_leaveType.dart';
import '../services/leave_service.dart';

class LeaveTypeProvider with ChangeNotifier {
  // -------------------- CONTROLLERS --------------------
  final TextEditingController cRNController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();

  // -------------------- SERVICES --------------------
  final LeaveService _leaveService = LeaveService();

  // -------------------- STATE --------------------
  List<LeaveTypeData> _leaveTypes = [];
  LeaveTypeData? _selectedLeaveType;

  int? get selectedLeaveTypeId => _selectedLeaveType?.leaveTypeId;


  String _selectedDayType = 'Full Day';
  String _selectedLeaveSection = 'Morning';


  DateTime focusedDay = DateTime.now();
  DateTime? fromDate;
  DateTime? toDate;
  bool isSelectingToDate = false;

  bool _isLoading = false;
  String? _error;

  // -------------------- GETTERS --------------------
  List<LeaveTypeData> get leaveTypes => _leaveTypes;
  LeaveTypeData? get selectedLeaveType => _selectedLeaveType;

  List<String> get dayTypes => const ['Full Day', 'Half Day'];
  String get selectedDayType => _selectedDayType;

  List<String> get leaveSections => const ['Morning', 'After noon'];
  String get selectedLeaveSection => _selectedLeaveSection;

  bool get isLoading => _isLoading;
  String? get error => _error;

  double get selectedLeaveDays {
    if (fromDate == null) return 0;

    if (_selectedDayType == 'Half Day') {
      return 0.5;
    }

    final endDate = toDate ?? fromDate!;
    return endDate.difference(fromDate!).inDays + 1;
  }

  /// ✅ Safe previous month calculation
  DateTime get firstAllowedDate {
    final now = DateTime.now();
    final prevMonth =
    DateTime(now.year, now.month, 1).subtract(const Duration(days: 1));
    return DateTime(prevMonth.year, prevMonth.month, 26);
  }

  /// ✅ Used when navigating from AttendanceCalendar
  void setInitialDate(DateTime date) {
    final cleanDate = DateTime(date.year, date.month, date.day);

    fromDate = cleanDate;
    toDate = null;
    focusedDay = cleanDate;
    isSelectingToDate = false;

    notifyListeners();
  }


  // -------------------- ACTIONS --------------------
  void setSelectedLeaveType(LeaveTypeData? value) {
    _selectedLeaveType = value;
    notifyListeners();
  }

  void setSelectedDayType(String value) {
    _selectedDayType = value;
    notifyListeners();
  }

  void setSelectedLeaveSection(String value) {
    _selectedLeaveSection = value;
    notifyListeners();
  }

  void selectDay(DateTime selectedDay, DateTime focusDay) {
    if (!isSelectingToDate) {
      fromDate = selectedDay;
      toDate = null;
      isSelectingToDate = true;
    } else {
      if (fromDate != null && selectedDay.isAfter(fromDate!)) {
        toDate = selectedDay;
        isSelectingToDate = false;
      } else {
        fromDate = selectedDay;
        toDate = null;
        isSelectingToDate = true;
      }
    }
    focusedDay = focusDay;
    notifyListeners();
  }

  Future<void> fetchLeaveTypes(BuildContext context) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final response = await _leaveService.fetchLeaveTypes(context: context);
    if (response != null) {
      _leaveTypes = response.data;
    } else {
      _error = "Failed to load leave types.";
    }

    _isLoading = false;
    notifyListeners();
  }

  void resetForm({bool notify = true}) {
    cRNController.clear();
    reasonController.clear();
    _selectedLeaveType = null;
    _selectedDayType = 'Full Day';
    _selectedLeaveSection = 'Morning';
    fromDate = null;
    toDate = null;
    isSelectingToDate = false;
    if (notify) notifyListeners();
  }

  // -------------------- CLEANUP --------------------
  @override
  void dispose() {
    cRNController.dispose();
    reasonController.dispose();
    super.dispose();
  }
}
