import 'package:flutter/material.dart';

import '../models/department_response_model.dart';
import '../services/ccu_department_service.dart';

class CCUDepartmentViewModel with ChangeNotifier {

  final CCUDepartmentService _service = CCUDepartmentService();

  List<DepartmentData> _departments = [];
  DepartmentData? _selectedDepartment;

  bool _isLoading = false;
  String? _error;

  List<DepartmentData> get departments => _departments;
  DepartmentData? get selectedDepartment => _selectedDepartment;

  /// ⭐ ADD THIS
  List<String> get departmentNames =>
      _departments.map((e) => e.departmentName).toList();

  int? get selectedDepartmentId => _selectedDepartment?.departmentId;

  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchDepartments({
    required BuildContext context,
    required String employeeCode,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final response =
    await _service.fetchDepartments(employeeCode: employeeCode);

    if (response != null) {
      _departments = response.result;
    } else {
      _error = 'Failed to load departments';
    }

    _isLoading = false;
    notifyListeners();
  }

  void setSelectedDepartment(DepartmentData? value) {
    _selectedDepartment = value;
    notifyListeners();
  }

  void reset({bool notify = true}) {
    _selectedDepartment = null;
    if (notify) notifyListeners();
  }

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }
}

