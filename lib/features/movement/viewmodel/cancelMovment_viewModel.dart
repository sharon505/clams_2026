import 'package:flutter/material.dart';

import '../models/cancelMovement_model.dart';
import '../services/cancelMovement_services.dart';

class MovementCancelProvider with ChangeNotifier {
  MovementCancelProvider({MovementCancelServices? service})
      : _service = service ?? MovementCancelServices();

  final MovementCancelServices _service;

  bool _isCancelling = false;
  bool get isCancelling => _isCancelling;

  String? _error;
  String? get error => _error;

  CancelMovementResponse? _lastResponse;
  CancelMovementResponse? get lastResponse => _lastResponse;

  /// Cancels a movement and returns true on success (StatusID == 200).
  Future<bool> cancel({
    required BuildContext context,
    required int movementId,
    String? reason, // optional
  }) async {
    _isCancelling = true;
    _error = null;
    notifyListeners();

    try {
      final res = await _service.movementCancel(
        context: context,
        movementId: movementId,
        reason: reason,
      );
      _lastResponse = res;

      final ok = res?.isOk ?? false;
      if (!ok && res != null && res.message.isNotEmpty) {
        _error = res.message; // backend message if available
      }
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
