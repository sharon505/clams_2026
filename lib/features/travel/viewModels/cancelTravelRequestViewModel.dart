import 'package:flutter/foundation.dart';

import '../models/cancle_travel_model.dart';
import '../services/cancelTravelResponse.dart';

class CancelTravelRequestViewModel extends ChangeNotifier {
  CancelTravelRequestViewModel({CancelTravelRequestService? service})
      : _service = service ?? CancelTravelRequestService();

  final CancelTravelRequestService _service;

  final Set<int> _loadingIds = <int>{};

  String? _error;
  String? _lastMessage;

  String? get error => _error;
  String? get lastMessage => _lastMessage;
  bool isCancelling(int trId) => _loadingIds.contains(trId);

  Future<bool> cancel(int trId, String employeeCode) async {
    if (_loadingIds.contains(trId)) return false;

    _loadingIds.add(trId);
    _error = null;
    _lastMessage = null;
    notifyListeners();

    try {
      final CancelTravelModel? res = await _service.cancelTravelRequest(
        trId: trId,
        employeeCode: employeeCode,
      );

      if (res == null) {
        _error = 'Network/parse error';
        return false;
      }

      final ok = res.isOk;
      _lastMessage = res.table1.first.msg;

      if (!ok) {
        _error = _lastMessage?.isNotEmpty == true
            ? _lastMessage
            : 'Cancellation failed';
      }

      return ok;
    } catch (e) {
      _error = 'Unexpected error: $e';
      return false;
    } finally {
      _loadingIds.remove(trId);
      notifyListeners();
    }
  }

  void reset() {
    _loadingIds.clear();
    _error = null;
    _lastMessage = null;
    notifyListeners();
  }
}