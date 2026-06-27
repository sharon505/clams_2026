import 'dart:convert';
import 'package:clams/network/app_url.dart';
import 'package:http/http.dart' as http;

import '../models/update_ta_response.dart';

class UpdateTAService {
  final http.Client _client = http.Client();

  Future<UpdateTAResponse?> updateTARequest({
    required String employeeCode,
    required String travelId,
    required String reason,
    required String extendedDays,
    required String extendedDate,
  }) async {
    try {
      final uri = AppUrls.updateTARequest;

      /// ⚠️ ASP.NET requires String map
      final Map<String, String> body = {
        "Employeecode": employeeCode,
        "TravelID": travelId,
        "Reason": reason,
        "ExtendedDays": extendedDays,
        "ExtendedDate": extendedDate,
        "Company": AppUrls.companyName,
      };

      print("📤 Update TA Request Body:");
      body.forEach((k, v) => print("$k : $v"));

      final response = await _client.post(
        uri,
        headers: AppUrls.header,
        body: body,
      );

      print("🔵 Status Code: ${response.statusCode}");
      print("🟢 Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return UpdateTAResponse.fromJson(data);
      }

      return null;
    } catch (e) {
      print("🔴 Error in UpdateTAService: $e");
      return null;
    }
  }

  void dispose() => _client.close();
}