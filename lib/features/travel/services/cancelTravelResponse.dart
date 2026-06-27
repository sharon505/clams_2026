import 'dart:convert';
import 'package:clams/network/app_url.dart';
import 'package:http/http.dart' as http;

import '../models/cancle_travel_model.dart';

class CancelTravelRequestService {
  final http.Client _client = http.Client();

  Future<CancelTravelModel?> cancelTravelRequest({
    required int trId,
    required String employeeCode,
  }) async {
    try {
      final uri = AppUrls.cancelEmployeeTravelRequest;

      final body = {
        "TR_ID": trId.toString(),
        "Employeecode": employeeCode,
        "Company": AppUrls.companyName,
      };

      print("➡️ CancelTravelRequest: $body");

      final response = await _client.post(
        uri,
        headers: AppUrls.header,
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return CancelTravelModel.fromJson(data);
      } else {
        print("❌ CancelEmployee_TravelRequest failed: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("🔴 Error in CancelEmployee_TravelRequest: $e");
      return null;
    }
  }
}