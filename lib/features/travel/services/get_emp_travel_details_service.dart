import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../network/app_url.dart';
import '../models/get_emp_travel_details_model.dart';

class GetEmpTravelDetailsService {
  final http.Client _client = http.Client();

  Future<GetEmpTravelDetailsModel?> getEmpTravelDetails({
    required String travelId,
    required String employeeCode,
  }) async {
    try {
      final stopwatch = Stopwatch()..start();

      final uri = AppUrls.getEmpTravelDetails;

      final Map<String, String> body = {
        "TravelID": travelId,
        "Company": AppUrls.companyName,
        "Employeecode": employeeCode,
      };

      // ---------------- DEBUG PRINTS ----------------
      print("════════════ GET EMP TRAVEL DETAILS ════════════");
      print("📡 URL       → $uri");
      print("📨 HEADERS   → ${AppUrls.header}");
      print("📦 BODY      → ${jsonEncode(body)}");
      print("⏰ TIME      → ${DateTime.now()}");
      print("════════════════════════════════════════════════");

      final response = await _client.post(
        uri,
        headers: AppUrls.header,
        body: body,
      );

      stopwatch.stop();

      print("════════════ RESPONSE ════════════");
      print("📊 StatusCode → ${response.statusCode}");
      print("⏱ Duration   → ${stopwatch.elapsedMilliseconds} ms");
      print("🧾 Raw Body   ↓↓↓");
      print(response.body);
      print("══════════════════════════════════");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        print("🧩 Parsed JSON → ${jsonEncode(data)}");

        return GetEmpTravelDetailsModel.fromJson(data);
      } else {
        print("❌ GetEmpTravelDetails FAILED");
        return null;
      }
    } catch (e, stack) {
      print("🔴 EXCEPTION in GetEmpTravelDetails");
      print("Error → $e");
      print("Stack → $stack");
      return null;
    }
  }
}