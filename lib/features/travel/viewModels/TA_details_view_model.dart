import 'package:flutter/material.dart';
import '../models/ta_details_model.dart';
import '../services/TA_details_service.dart';

class TADetailsViewModel extends ChangeNotifier {
  TADetailsViewModel({TADetailsService? service})
      : _service = service ?? TADetailsService();

  final TADetailsService _service;

  bool _isLoading = false;
  String? _error;
  TADetailsModel? _response;

  bool get isLoading => _isLoading;
  String? get error => _error;
  TADetailsModel? get response => _response;

  List<TADetailsResult> get taDetails => _response?.result ?? [];

  TADetailsResult? get firstTA =>
      taDetails.isNotEmpty ? taDetails.first : null;

  bool get hasData => taDetails.isNotEmpty;

  Future<bool> fetch({
    required String travelId,
    required String employeeCode,
  }) async {
    try {
      _setLoading(true);

      if (travelId.isEmpty) {
        _setError('Travel ID is missing');
        return false;
      }

      if (employeeCode.isEmpty) {
        _setError('Employee Code is missing');
        return false;
      }

      final res = await _service.fetchTADetails(
        travelId: travelId,
        employeeCode: employeeCode,
      );

      if (res == null) {
        _setError('Failed to fetch TA details');
        return false;
      }

      _response = res;
      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Unexpected error: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void reset() {
    _isLoading = false;
    _error = null;
    _response = null;
    notifyListeners();
  }

  List<String> get transportList {
    final transport = firstTA?.trModeOfTransportation ?? '';
    if (transport.isEmpty) return [];
    return transport.split(',').map((e) => e.trim()).toList();
  }

  String? get formattedDateRange {
    final ta = firstTA;
    if (ta == null) return null;

    return "${ta.trDepartureDate.toLocal().toString().split(' ')[0]} "
        "→ ${ta.trReturnDate.toLocal().toString().split(' ')[0]}";
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _error = message;
    _response = null;
    notifyListeners();
  }
}