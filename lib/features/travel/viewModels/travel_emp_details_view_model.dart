import 'package:clams/features/Authentication/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/travel_emp_details_model.dart';
import '../services/travel_emp_details_service.dart';

class TravelEmpDetailsViewModel extends ChangeNotifier {
  TravelEmpDetailsViewModel({TravelEmpDetailsService? service})
      : _service = service ?? TravelEmpDetailsService();

  final TravelEmpDetailsService _service;

  bool _isLoading = false;
  String? _error;
  TravelEmpDetailsModel? _response;

  // ------------------------------
  // GETTERS
  // ------------------------------
  bool get isLoading => _isLoading;
  String? get error => _error;
  TravelEmpDetailsModel? get response => _response;

  List<EmployeeResult> get employees => _response?.result ?? [];

  bool get hasData => employees.isNotEmpty;

  // ------------------------------
  // FETCH USING EMPCODE (UPDATED)
  // ------------------------------
  Future<bool> fetch({
    required String empCode, // ✅ renamed
  }) async {
    try {
      _setLoading(true);

      if (empCode.isEmpty) {
        _setError('Employee code is missing');
        return false;
      }

      final res = await _service.fetchTravelEmpDetails(
        travelId: empCode, // still using same param internally
      );

      if (res == null) {
        _setError('Failed to fetch travel employee details');
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
  // FETCH USING AUTH (BEST PRACTICE)
  // ------------------------------
  Future<bool> fetchWithAuth(BuildContext context) async {
    try {
      _setLoading(true);

      final auth = context.read<AuthProvider>();
      final employeeCode =
      auth.loginData?.data.first.employeeCode?.toString();

      if (employeeCode == null || employeeCode.isEmpty) {
        _setError('Missing employee code from login');
        return false;
      }

      final res = await _service.fetchTravelEmpDetails(
        travelId: employeeCode, // ✅ using logged user
      );

      if (res == null) {
        _setError('Failed to fetch travel employee details');
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
  // RESET
  // ------------------------------
  void reset() {
    _isLoading = false;
    _error = null;
    _response = null;
    notifyListeners();
  }

  // ------------------------------
  // INTERNAL HELPERS
  // ------------------------------
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _error = message;
    _response = null;
    notifyListeners();
  }
}