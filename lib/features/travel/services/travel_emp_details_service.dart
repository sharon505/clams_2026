import 'dart:convert';
import 'package:clams/network/app_url.dart';
import 'package:http/http.dart' as http;

import '../models/travel_emp_details_model.dart';

class TravelEmpDetailsService {
  final http.Client _client = http.Client();

  /// Fetch Travel Employee Details
  Future<TravelEmpDetailsModel?> fetchTravelEmpDetails({
    required String travelId,
  }) async {
    try {
      final uri = AppUrls.getTravelEmpDetails;

      final Map<String, String> body = {
        'Empcode': travelId, // ✅ CHANGED HERE
        'Company': AppUrls.companyName,
      };

      print('📩 Get_TravelEmpDetails Request: $body');

      final response = await _client.post(
        uri,
        headers: AppUrls.header,
        body: body,
      );

      print('🔵 Status Code: ${response.statusCode}');
      print('🟢 Raw Response:\n${response.body}');

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final decoded = jsonDecode(response.body);

        /// 🔥 HANDLE .asmx RESPONSE
        final data = decoded['d'] ?? decoded;

        /// ⚠️ Sometimes "d" is STRING → decode again
        final finalData = data is String ? jsonDecode(data) : data;

        print('🟣 Parsed Data:\n$finalData');

        return TravelEmpDetailsModel.fromJson(finalData);
      } else {
        print('❌ Failed: ${response.statusCode}');
        return null;
      }
    } catch (e, st) {
      print('🔴 Error in TravelEmpDetailsService');
      print('👉 Error: $e');
      print('👉 Stacktrace:\n$st');
      return null;
    }
  }

  /// Dispose HTTP client
  void dispose() {
    _client.close();
  }
}