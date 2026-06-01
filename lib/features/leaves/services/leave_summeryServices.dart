import 'dart:convert';
import 'package:clams/features/Authentication/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../../network/app_url.dart';
import '../models/model_leaveSummery.dart';

class LeaveSummaryService {

  Future<LeaveSummaryResponse?> fetchMyLeaveSummary({
    required BuildContext context,
  }) async {
    try {

      final auth = Provider.of<AuthProvider>(context, listen: false);
      final employeeCode = auth.loginData?.data.first.employeeCode?.toString() ?? '';

      if (employeeCode.isEmpty) {
        debugPrint('❌ fetchMyLeaveSummary: missing employee code');
        return null;
      }

      final Map<String, String> body = {
        'EmployeeCode': employeeCode,
        'Company': AppUrls.companyName,
      };

      final uri = AppUrls.myLeaveSummary;
      final res = await http.post(
        uri,
        headers:AppUrls.header,
        body: body,
      );

      debugPrint('🔵 [MyLeaveSummary] ${res.statusCode}');
      if (res.statusCode != 200) {
        debugPrint('❌ Body: ${res.body}');
        return null;
      }

      final Map<String, dynamic> jsonMap = json.decode(res.body) as Map<String, dynamic>;
      final parsed = LeaveSummaryResponse.fromJson(jsonMap);
      return parsed;
    } catch (e) {
      debugPrint('🔴 Exception @fetchMyLeaveSummary: $e');
      return null;
    }
  }
}
