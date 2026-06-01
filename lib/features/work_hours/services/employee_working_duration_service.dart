import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../../network/app_url.dart';
import '../../Authentication/providers/auth_provider.dart';
import '../models/working_duration_response_model.dart';

class EmployeeWorkingDurationService {
  Future<WorkingDurationResponse?> fetchEmployeeWorkingDuration({
    required BuildContext context,
    String? employeeCode, // 👈 optional (team / self)
  }) async {
    try {
      final auth = Provider.of<AuthProvider>(context, listen: false);

      // Resolve employee code
      final effectiveEmployeeCode =
      (employeeCode != null && employeeCode.trim().isNotEmpty)
          ? employeeCode.trim()
          : auth.loginData?.data.first.employeeCode?.toString() ?? '';

      if (effectiveEmployeeCode.isEmpty) {
        debugPrint('❌ EmployeeWorkingDuration: missing employee code');
        return null;
      }

      final body = <String, String>{
        'EmployeeCode': effectiveEmployeeCode,
        'Company': AppUrls.companyName,
      };

      debugPrint('➡️ POST EmployeeWorkingDuration: $body');

      // final uri =
      // Uri.parse('${AppUrls.baseUrl}EmployeeWorkingDuration');
      final uri = AppUrls.employeeWorkingDuration;

      final response =
      await http.post(uri, headers: AppUrls.header, body: body);

      debugPrint(
        '⬅️ EmployeeWorkingDuration status: ${response.statusCode}',
      );

      if (response.statusCode != 200) {
        debugPrint(
          '❌ EmployeeWorkingDuration error body: ${response.body}',
        );
        return null;
      }

      if (response.body.isEmpty) {
        debugPrint('❌ EmployeeWorkingDuration: empty response body');
        return null;
      }

      final decoded = jsonDecode(response.body);

      if (decoded is! Map<String, dynamic>) {
        debugPrint(
          '❌ EmployeeWorkingDuration: unexpected JSON structure',
        );
        return null;
      }

      return WorkingDurationResponse.fromJson(decoded);
    } catch (e, st) {
      debugPrint(
        '🔴 Exception @EmployeeWorkingDurationService: $e\n$st',
      );
      return null;
    }
  }
}
