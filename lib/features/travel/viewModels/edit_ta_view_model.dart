import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/edit_ta_response_model.dart';
import '../services/edit_ta_service.dart';

enum EditTAStatus { idle, loading, success, error }

class EditTAViewModel extends ChangeNotifier {
  final EditTAService _service;

  EditTAViewModel({
    EditTAService? service,
    Duration? requestTimeout,
  })  : _service = service ?? EditTAService(),
        _requestTimeout = requestTimeout ?? const Duration(seconds: 25);

  // ---------------- STATE ----------------
  EditTAStatus _status = EditTAStatus.idle;
  String? _errorMessage;
  EditTAResponse? _response;

  final Duration _requestTimeout;

  // ---------------- GETTERS ----------------
  EditTAStatus get status => _status;
  bool get isLoading => _status == EditTAStatus.loading;
  bool get isSuccess => _status == EditTAStatus.success;
  bool get isError => _status == EditTAStatus.error;

  String? get errorMessage => _errorMessage;
  EditTAResponse? get response => _response;

  EditTAResult? get data =>
      (_response != null && _response!.result.isNotEmpty)
          ? _response!.result.first
          : null;

  // ---------------- ACTION ----------------
  Future<bool> fetch({
    required String travelId,
    required String employeeCode,
  }) async {
    if (_status == EditTAStatus.loading) return false;

    _setStatus(EditTAStatus.loading);

    try {
      final res = await _service
          .getEditTA(
        travelId: travelId,
        employeeCode: employeeCode, // <-- added
      )
          .timeout(_requestTimeout);

      if (res == null || res.result.isEmpty) {
        _setError("No data found");
        return false;
      }

      _response = res;
      _errorMessage = null;
      _setStatus(EditTAStatus.success);
      return true;
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
    _response = null;
    _setStatus(EditTAStatus.idle);
  }

  // ---------------- INTERNAL ----------------
  void _setStatus(EditTAStatus s) {
    _status = s;
    notifyListeners();
  }

  void _setError(String msg) {
    _errorMessage = msg;
    _status = EditTAStatus.error;
    notifyListeners();
  }

  @override
  void dispose() {
    _service.dispose(); // close http client
    super.dispose();
  }
}