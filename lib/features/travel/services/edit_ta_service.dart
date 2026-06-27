import 'dart:convert';
import 'package:clams/network/app_url.dart';
import 'package:http/http.dart' as http;
import '../models/edit_ta_response_model.dart';

class EditTAService {
  final http.Client _client = http.Client();

  Future<EditTAResponse?> getEditTA({
    required String travelId,
    required String employeeCode,
  }) async {
    try {
      final uri = AppUrls.editTARequest;

      final Map<String, String> body = {
        "TravelID": travelId,
        "Company": AppUrls.companyName,
        "Employeecode": employeeCode,
      };

      print("📤 Edit TA Request Body:");
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
        return EditTAResponse.fromJson(data);
      } else {
        print("❌ API failed with status: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("🔴 Error in EditTAService: $e");
      return null;
    }
  }

  void dispose() {
    _client.close();
  }
}