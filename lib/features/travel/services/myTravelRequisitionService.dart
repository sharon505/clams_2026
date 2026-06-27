import 'dart:convert';
import 'package:clams/network/app_url.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../models/travelRequisitionModel.dart';

class MyTravelRequisitionService {
  final http.Client _client = http.Client();

  Future<TravelRequisitionModel?> getMyTravelRequisitions({
    required String employeeCode,
    String? fromDate,
    String? toDate,
  }) async {
    try {
      final stopwatch = Stopwatch()..start();

      // ---------------- DEFAULT CURRENT MONTH ----------------
      if ((fromDate == null || fromDate.isEmpty) && (toDate == null || toDate.isEmpty)) {
        final now = DateTime.now();

        /// First day of the previous month
        final firstDay = DateTime(now.year, now.month - 1, 1);

        /// Last day of the current month
        final lastDay = DateTime(now.year, now.month + 1, 0);

        final df = DateFormat('yyyy-MM-dd');
        fromDate = df.format(firstDay);
        toDate = df.format(lastDay);
      }

      final uri = AppUrls.myTravelRequisition;

      final Map<String, String> body = {
        "EmployeeCode": employeeCode,
        "Company": AppUrls.companyName,
        if (fromDate != null && fromDate.isNotEmpty) "FromDate": fromDate,
        if (toDate != null && toDate.isNotEmpty) "ToDate": toDate,
      };

      // ---------------- DEBUG PRINTS ----------------
      print("════════════════ API CALL ════════════════");
      print("📡 URL       → $uri");
      print("📨 HEADERS   → ${AppUrls.header}");
      print("📦 BODY      → ${jsonEncode(body)}");
      print("⏰ TIME      → ${DateTime.now()}");
      print("══════════════════════════════════════════");

      final response = await _client.post(
        uri,
        headers: AppUrls.header,
        body: body,
      );

      stopwatch.stop();

      print("════════════════ RESPONSE ════════════════");
      print("📊 StatusCode → ${response.statusCode}");
      print("⏱ Duration   → ${stopwatch.elapsedMilliseconds} ms");
      print("🧾 Raw Body   ↓↓↓");
      print(response.body);
      print("══════════════════════════════════════════");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        print("🧩 Parsed JSON → ${jsonEncode(data)}");

        return TravelRequisitionModel.fromJson(data);
      } else {
        print("❌ MyTravelRequisition FAILED");
        return null;
      }
    } catch (e, stack) {
      print("🔴 EXCEPTION in MyTravelRequisition");
      print("Error → $e");
      print("Stack → $stack");
      return null;
    }
  }
}
