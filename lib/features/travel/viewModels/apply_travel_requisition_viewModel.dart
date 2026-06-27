import 'dart:async';
import 'package:flutter/foundation.dart';

import '../models/travel_requisition_response_model.dart';
import '../services/ApplyTravel_service.dart';

enum ApplyReqStatus { idle, submitting, success, error }

class ApplyTravelRequisitionViewModel extends ChangeNotifier {
  final ApplyTravelRequisitionService _service;

  ApplyTravelRequisitionViewModel({
    ApplyTravelRequisitionService? service,
    Duration? requestTimeout,
  })  : _service = service ?? ApplyTravelRequisitionService(),
        _requestTimeout = requestTimeout ?? const Duration(seconds: 25);

  // --- State ---
  ApplyReqStatus _status = ApplyReqStatus.idle;
  String? _errorMessage;
  TravelRequisitionResponse? _lastResponse;

  final Duration _requestTimeout;

  // --- Getters ---
  ApplyReqStatus get status => _status;
  bool get isSubmitting => _status == ApplyReqStatus.submitting;
  String? get errorMessage => _errorMessage;
  TravelRequisitionResponse? get lastResponse => _lastResponse;

  // --- Actions ---
  Future<bool> submit({
    required TravelRequisitionRequest request,
    required String employeeCode,
    required String? travelId,
  }) async {
    if (_status == ApplyReqStatus.submitting) return false;

    _setStatus(ApplyReqStatus.submitting);

    try {
      final resp = await _service
          .applyTravelRequisition(
        travelRequisitionRequest: request,
        employeeCode: employeeCode, travelId: travelId ?? '0',
      )
          .timeout(_requestTimeout);

      if (resp == null) {
        _setError('Request failed. Please try again.');
        return false;
      }

      _lastResponse = resp;
      _setStatus(ApplyReqStatus.success);
      return true;
    } on TimeoutException {
      _setError('Request timed out. Check your connection and retry.');
      return false;
    } catch (e) {
      _setError('Something went wrong: $e');
      return false;
    }
  }

  void reset() {
    _errorMessage = null;
    _lastResponse = null;
    _setStatus(ApplyReqStatus.idle);
  }

  // --- Internals ---
  void _setStatus(ApplyReqStatus s) {
    _status = s;
    notifyListeners();
  }

  void _setError(String msg) {
    _errorMessage = msg;
    _setStatus(ApplyReqStatus.error);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
