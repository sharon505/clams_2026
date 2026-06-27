import 'dart:async';
import 'package:flutter/foundation.dart';

import '../models/edit_ta_request_save_response.dart';
import '../services/edit_ta_request_save_service.dart';
import '../services/ApplyTravel_service.dart'; // for TravelRequisitionRequest

enum EditTASaveStatus { idle, submitting, success, error }

class EditTARequestSaveViewModel extends ChangeNotifier {
  final EditTARequestSaveService _service;

  EditTARequestSaveViewModel({
    EditTARequestSaveService? service,
    Duration? requestTimeout,
  })  : _service = service ?? EditTARequestSaveService(),
        _requestTimeout = requestTimeout ?? const Duration(seconds: 25);

  // ---------------- STATE ----------------
  EditTASaveStatus _status = EditTASaveStatus.idle;
  String? _errorMessage;
  EditTARequestSaveResponse? _lastResponse;

  final Duration _requestTimeout;

  // ---------------- GETTERS ----------------
  EditTASaveStatus get status => _status;
  bool get isSubmitting => _status == EditTASaveStatus.submitting;
  bool get isSuccess => _status == EditTASaveStatus.success;
  bool get isError => _status == EditTASaveStatus.error;

  String? get errorMessage => _errorMessage;
  EditTARequestSaveResponse? get lastResponse => _lastResponse;

  String get message {
    if (_lastResponse != null &&
        _lastResponse!.result.isNotEmpty) {
      return _lastResponse!.result.first.msg;
    }
    return _errorMessage ?? "Unknown error";
  }

  // ---------------- ACTION ----------------
  Future<bool> submit({
    required TravelRequisitionRequest request,
    required String travelId, // ✅ ADD THIS
  }) async {
    if (_status == EditTASaveStatus.submitting) return false;

    _setStatus(EditTASaveStatus.submitting);

    try {
      final res = await _service
          .saveEditTA(
        request: request,
        travelId: travelId, // ✅ PASS HERE
      )
          .timeout(_requestTimeout);

      if (res == null) {
        _setError("Request failed. Please try again.");
        return false;
      }

      _lastResponse = res;

      if (res.result.isNotEmpty &&
          res.result.first.statusId == 200) {
        _setStatus(EditTASaveStatus.success);
        return true;
      } else {
        _setError(res.result.isNotEmpty
            ? res.result.first.msg
            : "Something went wrong");
        return false;
      }
    } on TimeoutException {
      _setError("Request timed out. Check connection.");
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
    _setStatus(EditTASaveStatus.idle);
  }

  // ---------------- INTERNAL ----------------
  void _setStatus(EditTASaveStatus s) {
    _status = s;
    notifyListeners();
  }

  void _setError(String msg) {
    _errorMessage = msg;
    _status = EditTASaveStatus.error;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}