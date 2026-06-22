// import 'package:flutter/material.dart';
//
// import '../models/applyMovement_model.dart';
// import '../services/applyMovement_services.dart';
//
// class ApplyMovementViewModel extends ChangeNotifier {
//   ApplyMovementViewModel({ApplyMovementServices? service})
//       : _service = service ?? ApplyMovementServices();
//
//   final ApplyMovementServices _service;
//
//   bool _isLoading = false;
//   String? _errorMessage;
//   ApplyMovementResponse? _response;
//   String? _lastMessage;
//   bool _isSuccess = false;
//
//   bool get isLoading => _isLoading;
//   String? get errorMessage => _errorMessage;
//   ApplyMovementResponse? get response => _response;
//   String? get lastMessage => _lastMessage;
//   bool get isSuccess => _isSuccess;
//
//   Future<bool> submit(BuildContext context) async {
//     _isLoading = true;
//     _errorMessage = null;
//     _lastMessage = null;
//     _isSuccess = false;
//     notifyListeners();
//
//     try {
//       final res = await _service.applyMovement(context: context);
//
//       if (res == null || res.result.isEmpty) {
//         _errorMessage = 'Submission failed. Please try again.';
//         return false;
//       }
//
//       _response = res;
//       final r = res.result.first;
//
//       // ✅ SUCCESS
//       if (r.statusId == 1 || r.statusId == 200 || r.statusId == 201) {
//         _isSuccess = true;
//         _lastMessage =
//         r.msg.isNotEmpty ? r.msg : 'Movement applied successfully.';
//         return true;
//       }
//
//       // ❌ BACKEND VALIDATION / ERROR (400, 409, etc.)
//       _isSuccess = false;
//       _errorMessage =
//       r.msg.isNotEmpty ? r.msg : 'Failed to apply movement.';
//       _lastMessage = _errorMessage;
//       return false;
//     } catch (e) {
//       _isSuccess = false;
//       _errorMessage = 'Exception: $e';
//       _lastMessage = _errorMessage;
//       return false;
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
//
//   void reset() {
//     _isLoading = false;
//     _errorMessage = null;
//     _response = null;
//     _lastMessage = null;
//     _isSuccess = false;
//     notifyListeners();
//   }
// }
//


import 'package:flutter/material.dart';

import '../models/applyMovement_model.dart';
import '../services/applyMovement_services.dart';

class ApplyMovementViewModel extends ChangeNotifier {
  ApplyMovementViewModel({ApplyMovementServices? service})
      : _service = service ?? ApplyMovementServices();

  final ApplyMovementServices _service;

  // ---------------------------------------------------------------------------
  // STATE
  // ---------------------------------------------------------------------------

  bool _isLoading = false;
  String? _errorMessage;
  ApplyMovementResponse? _response;
  String? _lastMessage;
  bool _isSuccess = false;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  ApplyMovementResponse? get response => _response;
  String? get lastMessage => _lastMessage;
  bool get isSuccess => _isSuccess;

  // ---------------------------------------------------------------------------
  // SUBMIT MOVEMENT
  // ---------------------------------------------------------------------------

  Future<bool> submit(BuildContext context) async {
    _isLoading = true;
    _errorMessage = null;
    _lastMessage = null;
    _isSuccess = false;
    notifyListeners();

    try {
      final res = await _service.applyMovement(context: context);

      // No response OR empty result
      if (res == null || res.result.isEmpty) {
        _errorMessage = 'Submission failed. Please try again.';
        _lastMessage = _errorMessage;
        return false;
      }

      _response = res;
      final MovementStatus r = res.result.first;

      // ---------------------------------------------------------------------
      // SUCCESS CONDITIONS (Based on your API)
      // ---------------------------------------------------------------------
      if (r.statusId == 1 || r.statusId == 200 || r.statusId == 201) {
        _isSuccess = true;
        _lastMessage =
        r.msg.isNotEmpty ? r.msg : 'Movement applied successfully.';
        return true;
      }

      // ---------------------------------------------------------------------
      // BACKEND VALIDATION ERROR
      // ---------------------------------------------------------------------
      _isSuccess = false;
      _errorMessage =
      r.msg.isNotEmpty ? r.msg : 'Failed to apply movement.';
      _lastMessage = _errorMessage;
      return false;
    }

    // -----------------------------------------------------------------------
    // EXCEPTION HANDLING
    // -----------------------------------------------------------------------
    catch (e) {
      _isSuccess = false;
      _errorMessage = 'Unexpected error occurred. Please try again.';
      _lastMessage = _errorMessage;
      return false;
    }

    finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ---------------------------------------------------------------------------
  // RESET STATE
  // ---------------------------------------------------------------------------

  void reset() {
    _isLoading = false;
    _errorMessage = null;
    _response = null;
    _lastMessage = null;
    _isSuccess = false;
    notifyListeners();
  }
}
