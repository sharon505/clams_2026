import 'dart:convert';
import 'package:clams/network/app_url.dart';
import 'package:http/http.dart' as http;

import '../models/ta_details_model.dart';

class TADetailsService {
  final http.Client _client = http.Client();

  Future<TADetailsModel?> fetchTADetails({
    required String travelId,
    required String employeeCode,
  }) async {
    try {
      final uri = AppUrls.getTADetails;

      final Map<String, String> body = {
        'TravelID': travelId,
        'Company': AppUrls.companyName,
        'Employeecode': employeeCode,
      };

      print('📩 Get_TADetails Request: $body');

      final response = await _client.post(
        uri,
        headers: AppUrls.header,
        body: body,
      );

      print('🔵 Status Code: ${response.statusCode}');
      print('🟢 Response Body:\n${response.body}');

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return TADetailsModel.fromJson(decoded);
      } else {
        print('❌ Get_TADetails failed: ${response.statusCode}');
        return null;
      }
    } catch (e, st) {
      print('🔴 Error in TADetailsService');
      print('👉 Error: $e');
      print('👉 Stacktrace:\n$st');
      return null;
    }
  }

  void dispose() {
    _client.close();
  }
}