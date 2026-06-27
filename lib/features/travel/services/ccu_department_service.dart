import 'dart:convert';
import 'package:clams/network/app_url.dart';
import 'package:http/http.dart' as http;

import '../models/department_response_model.dart';

class CCUDepartmentService {
  final http.Client _client = http.Client();

  /// Fetch CCU Departments
  Future<DepartmentResponse?> fetchDepartments({
    required String employeeCode,
  }) async {
    try {
      // final uri = Uri.parse('${AppUrls.baseUrl}CCUDepartment');

      final uri = AppUrls.ccuDepartment;

      final Map<String, String> body = {
        'Employeecode': employeeCode,
        'Company': AppUrls.companyName,
      };

      print('📩 CCU Department Request: $body');

      final response = await _client.post(
        uri,
        headers: AppUrls.header,
        body: body,
      );

      print('🔵 Status Code: ${response.statusCode}');
      print('🟢 Response Body:\n${response.body}');

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return DepartmentResponse.fromJson(decoded);
      } else {
        print('❌ CCUDepartment failed: ${response.statusCode}');
        return null;
      }
    } catch (e, st) {
      print('🔴 Error in CCUDepartmentService');
      print('👉 Error: $e');
      print('👉 Stacktrace:\n$st');
      return null;
    }
  }

  /// Dispose client if needed
  void dispose() {
    _client.close();
  }
}
