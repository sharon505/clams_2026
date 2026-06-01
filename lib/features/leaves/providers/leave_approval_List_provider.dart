import 'package:flutter/material.dart';

import '../models/leave_approval_response_model.dart';
import '../services/leave_approval_list_service.dart';

class LeaveApprovalListProvider with ChangeNotifier {
  final LeaveApprovalListService _leaveApprovalService =
  LeaveApprovalListService();

  LeaveApprovalResponse? _leaveApprovalResponse;
  bool _isLoading = false;
  String? _error;

  LeaveApprovalResponse? get leaveApprovalResponse => _leaveApprovalResponse;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Convenience list for UI
  List<LeaveApprovalItem> get items =>
      _leaveApprovalResponse?.table1 ?? [];

  /// Fetch Leave Approval List
  Future<void> fetchLeaveApprovalList(BuildContext context) async {
    /// 🔥 Reset old data
    _leaveApprovalResponse = null;
    _error = null;
    notifyListeners();

    _isLoading = true;
    notifyListeners();

    try {
      final response =
      await _leaveApprovalService.leaveApprovalListResponce(
        context: context,
      );

      /// ✅ UPDATED LOGIC
      if (response != null && response.result.status == 200) {
        _leaveApprovalResponse = response;
      } else {
        _error = response?.result.message ?? 'Failed to fetch approval list';
      }
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Reset provider state
  void clearData() {
    _leaveApprovalResponse = null;
    _error = null;
    notifyListeners();
  }
}