import 'package:flutter/material.dart';
import '../models/model_leaveResponse.dart';
import '../services/leave_service.dart';

class LeaveApplyProvider with ChangeNotifier {

  LeaveApplyProvider({LeaveService? service}) : _service = service ?? LeaveService();

  final LeaveService _service;

  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;

  LeaveSaveResponse? _lastResponse;
  LeaveSaveResponse? get lastResponse => _lastResponse;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<LeaveSaveResponse?> submit(BuildContext context) async {
    _isSubmitting = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final res = await _service.applyLeave(context: context);
      _lastResponse = res;
      return res;
    } catch (e) {
      _errorMessage = e.toString();
      return null;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  /// Clear transient state (e.g., after navigating away)
  void reset() {
    _isSubmitting = false;
    _lastResponse = null;
    _errorMessage = null;
    notifyListeners();
  }
}
