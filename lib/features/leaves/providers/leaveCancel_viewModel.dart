// lib/viewModels/leave_cancel_provider.dart
import 'package:flutter/material.dart';
import '../models/model_cancelLeave.dart';
import '../services/leave_CancelService.dart';

class LeaveCancelProvider with ChangeNotifier {

  LeaveCancelProvider({LeaveCancelServices? service})
      : _service = service ?? LeaveCancelServices();

  final LeaveCancelServices _service;

  bool _isCancelling = false;
  bool get isCancelling => _isCancelling;

  String? _error;
  String? get error => _error;

  CancelLeaveResponse? _lastResponse;
  CancelLeaveResponse? get lastResponse => _lastResponse;

  /// Cancels a leave and returns true on success (StatusID == 200).
  Future<bool> cancel({
    required BuildContext context,
    required int leaveId,
  }) async {
    _isCancelling = true;
    _error = null;
    notifyListeners();

    try {
      final res = await _service.cancelEmployeeLeave(
        context: context,
        leaveId: leaveId,
      );
      _lastResponse = res;

      final ok = res != null &&
          res.result.isNotEmpty &&
          res.result.first.statusId == 200;

      return ok;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isCancelling = false;
      notifyListeners();
    }
  }

  void reset() {
    _isCancelling = false;
    _error = null;
    _lastResponse = null;
    notifyListeners();
  }
}
