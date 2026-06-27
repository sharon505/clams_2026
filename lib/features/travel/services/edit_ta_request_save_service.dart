import 'dart:convert';
import 'package:clams/network/app_url.dart';
import 'package:http/http.dart' as http;

import '../models/edit_ta_request_save_response.dart';
import 'ApplyTravel_service.dart';

class EditTARequestSaveService {
  final http.Client _client = http.Client();

  Future<EditTARequestSaveResponse?> saveEditTA({
    required TravelRequisitionRequest request,
    required String travelId,
  }) async {
    try {
      final uri = AppUrls.editTARequestSave;

      /// ⚠️ SAME BODY AS APPLY
      final Map<String, String> map = {
        "TravelID": travelId,
        "EmployeeCode": request.employeeCode,
        "Level": request.level,
        "Destination": request.destination,
        "TravelLocation": request.travelLocation,

        "Departuredate": request.departureDate,
        "ReturnDate": request.returnDate,

        "ModeofTransportation": request.modeOfTransportation,
        "Duration": request.duration,
        "EstimatedKm": request.estimatedKm,
        "Accommodation": request.accommodation,
        "PurposeofTravel": request.purposeOfTravel,

        /// NEW FIELDS
        "CRNNumer": request.crnNumber,
        "CCUDepartment": request.ccuDepartment ?? "",

        "Company": AppUrls.companyName,
        // "Version": AppUrls.currentVersion,
      };

      print("📤 Edit TA Save Body:");
      map.forEach((k, v) => print("$k : $v"));

      final response = await _client.post(
        uri,
        headers: AppUrls.header,
        body: map,
      );

      print("🔵 Status Code: ${response.statusCode}");
      print("🟢 Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return EditTARequestSaveResponse.fromJson(data);
      }

      return null;
    } catch (e) {
      print("🔴 Error in EditTARequestSaveService: $e");
      return null;
    }
  }

  void dispose() => _client.close();
}