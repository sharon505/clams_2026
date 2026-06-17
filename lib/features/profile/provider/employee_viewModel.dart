import 'package:flutter/material.dart';

import '../models/employee_model.dart';
import '../services/employee_services.dart';

enum LoadState { idle, loading, loaded, error, success }

class EmployeeViewModel with ChangeNotifier {
  final EmployeeServices _service;

  EmployeeViewModel({EmployeeServices? service})
      : _service = service ?? EmployeeServices();

  LoadState _state = LoadState.idle;
  String? _error;
  Employee? _employee;

  LoadState get state => _state;
  String? get error => _error;
  Employee? get employee => _employee;

  bool get hasData => _employee != null;

  void _setState(LoadState s, {String? err}) {
    _state = s;
    _error = err;
    notifyListeners();
  }

  /// Load currently logged-in employee using AuthProvider (via service).
  Future<void> loadMyProfile(BuildContext context) async {
    _setState(LoadState.loading);
    try {
      final emp = await _service.fetchMyEmployeeDetails(context: context);
      if (emp == null) {
        _setState(LoadState.error, err: 'No employee record found.');
        return;
      }
      _employee = emp as Employee?;
      _setState(LoadState.loaded);
    } catch (e) {
      _setState(LoadState.error, err: 'Failed to load profile: $e');
    }
  }

  /// Load any employee by code (does not require AuthProvider).
  Future<void> loadByCode(String code) async {
    _setState(LoadState.loading);
    try {
      final emp = await _service.fetchEmployeeDetailsByCode(employeeCode: code);
      if (emp == null) {
        _setState(LoadState.error, err: 'No record for code $code');
        return;
      }
      _employee = emp as Employee?;
      _setState(LoadState.loaded);
    } catch (e) {
      _setState(LoadState.error, err: 'Failed to load: $e');
    }
  }

  /// Pull-to-refresh helper (decides what to refresh based on what we loaded).
  Future<void> refresh({BuildContext? context, String? code}) async {
    if (context != null) {
      await loadMyProfile(context);
    } else if (code != null && code.isNotEmpty) {
      await loadByCode(code);
    }
  }

  /// Optional: clear current data (e.g., on logout)
  void clear() {
    _employee = null;
    _state = LoadState.idle;
    _error = null;
    notifyListeners();
  }
}
