import 'dart:convert';
import 'package:clams/network/app_url.dart';
import 'package:http/http.dart' as http;

import '../models/travel_requisition_response_model.dart';

class ApplyTravelRequisitionService {
  final http.Client _client = http.Client();

  Future<TravelRequisitionResponse?> applyTravelRequisition({
    required TravelRequisitionRequest travelRequisitionRequest,
    required String employeeCode,
    required String? travelId,
  }) async {
    try {
      // final uri = Uri.parse("${AppUrls.baseUrl}ApplyTravelrequisition");
      final uri = AppUrls.applyTravelRequisition;

      /// ⚠️ ASP.NET NEEDS STRING MAP ONLY
      final Map<String, String> map = {
        "EmployeeCode": travelRequisitionRequest.employeeCode,
        "Level": travelRequisitionRequest.level,
        "Destination": travelRequisitionRequest.destination,
        "TravelLocation": travelRequisitionRequest.travelLocation,

        "Departuredate": travelRequisitionRequest.departureDate,
        "ReturnDate": travelRequisitionRequest.returnDate,

        "ModeofTransportation": travelRequisitionRequest.modeOfTransportation,
        "Duration": travelRequisitionRequest.duration,
        "EstimatedKm": travelRequisitionRequest.estimatedKm,
        "Accommodation": travelRequisitionRequest.accommodation,
        "PurposeofTravel": travelRequisitionRequest.purposeOfTravel,

        /// NEW FIELDS
        "CRNNumer": travelRequisitionRequest.crnNumber,
        "CCUDepartment": travelRequisitionRequest.ccuDepartment ?? "",

        "Company": AppUrls.companyName,
        "Version": AppUrls.currentVersion,

        'TravelID': travelId ?? "0",
      };

      print("📤 Travel Request Body:");
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
        return TravelRequisitionResponse.fromJson(data);
      }
      return null;
    } catch (e) {
      print("🔴 Error in ApplyTravelRequisition: $e");
      return null;
    }
  }

  void dispose() => _client.close();
}

class TravelRequisitionRequest {
  final String employeeCode;
  final String level;
  final String destination;
  final String travelLocation;
  final String departureDate;
  final String returnDate;
  final String modeOfTransportation;
  final String duration;
  final String estimatedKm;
  final String accommodation;
  final String purposeOfTravel;
  final String company;
  final String version;

  // 🆕 NEW FIELDS
  final String crnNumber;
  final String? ccuDepartment;

  TravelRequisitionRequest({
    required this.employeeCode,
    this.level = '',
    required this.destination,
    this.travelLocation = '',
    required this.departureDate,
    required this.returnDate,
    this.modeOfTransportation = '',
    this.duration = '',
    this.estimatedKm = '',
    this.accommodation = '',
    this.purposeOfTravel = '',
    required this.company,
    this.version = '',

    // 🆕 NEW
    this.crnNumber = '',
    this.ccuDepartment = '',
  });
}
