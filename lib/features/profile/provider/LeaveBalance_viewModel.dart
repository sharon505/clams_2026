import 'package:flutter/material.dart';

import '../models/model_leaveBalance.dart';
import '../services/leaveBalance_service.dart';

class LeaveBalanceProvider with ChangeNotifier {
  final LeaveBalanceService _leaveBalanceService = LeaveBalanceService();

  LeaveBalanceResponse? _leaveBalanceResponse;
  bool _isLoading = false;
  String? _error;

  LeaveBalanceResponse? get leaveBalanceResponse => _leaveBalanceResponse;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Fetch leave balance from API
  Future<void> fetchLeaveBalance(BuildContext context) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _leaveBalanceService.LeaveBalanceResponce(context: context);
      if (response != null && response.result.first.statusId == 200) {
        _leaveBalanceResponse = response as LeaveBalanceResponse?;
      } else {
        _error = response?.result.first.msg ?? 'Failed to fetch leave balance';
      }
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Clear all leave balance data
  void clearData() {
    _leaveBalanceResponse = null;
    _error = null;
    notifyListeners();
  }
}
