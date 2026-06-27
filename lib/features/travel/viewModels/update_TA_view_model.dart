import 'dart:async';
import 'package:flutter/foundation.dart';

import '../models/update_ta_response.dart';
import '../services/update_ta_service.dart';

enum UpdateTAStatus { idle, submitting, success, error }

class UpdateTAViewModel extends ChangeNotifier {
  final UpdateTAService _service;

  UpdateTAViewModel({
    UpdateTAService? service,
    Duration? requestTimeout,
  })  : _service = service ?? UpdateTAService(),
        _requestTimeout = requestTimeout ?? const Duration(seconds: 25);

  // ---------------- STATE ----------------
  UpdateTAStatus _status = UpdateTAStatus.idle;
  String? _errorMessage;
  UpdateTAResponse? _lastResponse;

  final Duration _requestTimeout;

  // ---------------- GETTERS ----------------
  UpdateTAStatus get status => _status;
  bool get isSubmitting => _status == UpdateTAStatus.submitting;
  bool get isSuccess => _status == UpdateTAStatus.success;
  bool get isError => _status == UpdateTAStatus.error;

  String? get errorMessage => _errorMessage;
  UpdateTAResponse? get lastResponse => _lastResponse;

  String get message {
    if (_lastResponse != null &&
        _lastResponse!.result.isNotEmpty) {
      return _lastResponse!.result.first.message;
    }
    return _errorMessage ?? "Unknown error";
  }

  // ---------------- ACTION ----------------
  Future<bool> submit({
    required String employeeCode,
    required String travelId,
    required String reason,
    required String extendedDays,
    required String extendedDate,
  }) async {
    if (_status == UpdateTAStatus.submitting) return false;

    _setStatus(UpdateTAStatus.submitting);

    try {
      final response = await _service
          .updateTARequest(
        employeeCode: employeeCode,
        travelId: travelId,
        reason: reason,
        extendedDays: extendedDays,
        extendedDate: extendedDate,
      )
          .timeout(_requestTimeout);

      if (response == null) {
        _setError("Request failed. Please try again.");
        return false;
      }

      _lastResponse = response;

      if (response.result.isNotEmpty &&
          response.result.first.statusId == 200) {
        _setStatus(UpdateTAStatus.success);
        return true;
      } else {
        _setError(response.result.isNotEmpty
            ? response.result.first.message
            : "Something went wrong");
        return false;
      }
    } on TimeoutException {
      _setError("Request timed out. Please check your connection.");
      return false;
    } catch (e) {
      _setError("Something went wrong: $e");
      return false;
    }
  }

  // ---------------- RESET ----------------
  void reset() {
    _errorMessage = null;
    _lastResponse = null;
    _setStatus(UpdateTAStatus.idle);
  }

  // ---------------- INTERNAL ----------------
  void _setStatus(UpdateTAStatus status) {
    _status = status;
    notifyListeners();
  }

  void _setError(String msg) {
    _errorMessage = msg;
    _status = UpdateTAStatus.error;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}