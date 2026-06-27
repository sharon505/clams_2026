import 'package:clams/features/Authentication/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/travelRequisitionModel.dart';
import '../services/myTravelRequisitionService.dart';

class MyTravelRequisitionViewModel extends ChangeNotifier {
  MyTravelRequisitionViewModel({MyTravelRequisitionService? service})
      : _service = service ?? MyTravelRequisitionService();

  final MyTravelRequisitionService _service;

  bool _isLoading = false;
  String? _error;
  TravelRequisitionModel? _response;

  // ------------------------------
  // DATE FILTERS
  // ------------------------------
  DateTime? fromDate;
  DateTime? toDate;

  // ------------------------------
  // GETTERS
  // ------------------------------
  bool get isLoading => _isLoading;
  String? get error => _error;
  TravelRequisitionModel? get response => _response;

  List<TravelRequisitionRow> _allRows = [];
  String _search = "";

  List<TravelRequisitionRow> get rows {
    if (_search.trim().isEmpty) return _allRows;

    final keyword = _search.toLowerCase().trim();

    return _allRows.where((e) {
      return e.employeeName.toLowerCase().contains(keyword) ||
          e.trLocation.toLowerCase().contains(keyword) ||
          e.trStatus.toLowerCase().contains(keyword) ||
          e.trDestination.toLowerCase().contains(keyword) ||
          e.trId.toString().contains(keyword);
    }).toList();
  }


  String get selectedMonthLabel {
    if (fromDate == null || toDate == null) {
      final now = DateTime.now();
      return DateFormat('MMMM yyyy').format(now);
    }

    // Same month
    if (fromDate!.year == toDate!.year &&
        fromDate!.month == toDate!.month) {
      return DateFormat('MMMM yyyy').format(fromDate!);
    }

    // Multiple months
    return "${DateFormat('MMM yyyy').format(fromDate!)} - "
        "${DateFormat('MMM yyyy').format(toDate!)}";
  }

  String get selectedDateRange {
    if (fromDate == null || toDate == null) {
      return "Current Month";
    }

    return "${DateFormat('dd MMM yyyy').format(fromDate!)}"
        " - "
        "${DateFormat('dd MMM yyyy').format(toDate!)}";
  }

  String? get message =>
      (_response?.result.isNotEmpty ?? false) ? _response!.result.first.msg : null;

  bool get hasData => rows.isNotEmpty;

  // ------------------------------
  // DATE FUNCTIONS
  // ------------------------------

  void setDateRange(DateTimeRange range) {
    fromDate = range.start;
    toDate = range.end;
    notifyListeners();
  }

  void search(String value) {
    _search = value;
    notifyListeners();
  }

  void clearSearch() {
    _search = "";
    notifyListeners();
  }

  void clearDateFilter() {
    fromDate = null;
    toDate = null;
    notifyListeners();
  }

  String? _formatDate(DateTime? date) {
    if (date == null) return null;
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  // ------------------------------
  // FETCH USING AUTH EMPLOYEE CODE
  // ------------------------------
  Future<bool> fetch(BuildContext context) async {
    try {
      _setLoading(true);

      final auth = context.read<AuthProvider>();
      final employeeCode = auth.loginData?.data.first.employeeCode?.toString();

      if (employeeCode == null || employeeCode.isEmpty) {
        _setError('Missing employee code');
        return false;
      }

      final res = await _service.getMyTravelRequisitions(
        employeeCode: employeeCode,
        fromDate: _formatDate(fromDate),
        toDate: _formatDate(toDate),
      );

      if (res == null) {
        _setError('Failed to fetch travel requisitions');
        return false;
      }

      _response = res;
      _allRows = res.table1;
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

  // ------------------------------
  // FETCH BY MANUAL EMPLOYEE CODE
  // ------------------------------
  Future<bool> fetchWithEmployeeCode(String employeeCode) async {
    try {
      _setLoading(true);

      if (employeeCode.isEmpty) {
        _setError('Missing employee code');
        return false;
      }

      final res = await _service.getMyTravelRequisitions(
        employeeCode: employeeCode,
        fromDate: _formatDate(fromDate),
        toDate:   _formatDate(toDate),
      );

      if (res == null) {
        _setError('Failed to fetch travel requisitions');
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

  // ------------------------------
  // RESET STATE
  // ------------------------------
  void reset() {
    _isLoading = false;
    _error = null;
    _response = null;
    _allRows.clear();
    _search = "";
    fromDate = null;
    toDate = null;
    notifyListeners();
  }

  // ------------------------------
  // INTERNAL HELPERS
  // ------------------------------
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
