import 'package:flutter/material.dart';

import '../models/get_emp_travel_details_model.dart';
import '../services/get_emp_travel_details_service.dart';

class GetEmpTravelDetailsViewModel extends ChangeNotifier {
  final GetEmpTravelDetailsService _service = GetEmpTravelDetailsService();

  /// ---------------- STATE ----------------
  bool isLoading = false;
  String? error;

  GetEmpTravelDetailsModel? _model;

  TravelResult? travel;
  List<TravelExtension> extensions = [];

  /// ---------------- FETCH ----------------
  Future<void> fetchTravelDetails({
    required String travelId,
    required String employeeCode,
  }) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final response = await _service.getEmpTravelDetails(
        travelId: travelId,
        employeeCode: employeeCode,
      );

      if (response != null) {
        _model = response;

        /// MAIN TRAVEL DATA
        if (_model!.result.isNotEmpty) {
          travel = _model!.result.first;
        } else {
          travel = null;
        }

        /// EXTENSIONS
        extensions = _model!.extensions;
      } else {
        error = "Unable to fetch travel details";
      }
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// ---------------- HELPERS ----------------

  bool get hasData => travel != null;

  bool get hasExtension => extensions.isNotEmpty;

  /// Total extended days
  int get totalExtendedDays {
    return extensions.fold<int>(0, (sum, e) => sum + e.extendedDays);
  }

  /// Latest extension
  TravelExtension? get latestExtension {
    if (extensions.isEmpty) return null;
    return extensions.last;
  }

  /// Filter by travel ID
  List<TravelExtension> getExtensionsByTravelId(int trId) {
    return extensions.where((e) => e.trId == trId).toList();
  }

  /// ---------------- RESET ----------------
  void clear() {
    _model = null;
    travel = null;
    extensions = [];
    error = null;
    isLoading = false;
    notifyListeners();
  }
}