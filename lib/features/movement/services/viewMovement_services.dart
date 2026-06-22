import 'dart:async';
import 'dart:convert';

import 'package:clams/features/Authentication/providers/auth_provider.dart';
import 'package:clams/network/app_url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../models/viewMovement_model.dart';

class MovementViewServices {
  Future<MovementReportResponse?> movementView({
    required BuildContext context,
    String? fromDate,   // yyyy-MM-dd
    String? toDate,     // yyyy-MM-dd
    int? statusId,      // 👈 use ID now
  }) async {
    try {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      final employeeCode =
          auth.loginData?.data.first.employeeCode?.toString() ?? '';

      if (employeeCode.isEmpty) {
        debugPrint('❌ movementView: missing employee code');
        return null;
      }

      // ✅ DEFAULT FILTERS: if all null → current month + status=0
      if ((fromDate == null || fromDate.isEmpty) &&
          (toDate == null || toDate.isEmpty) &&
          (statusId == null)) {
        final now = DateTime.now();
        final firstDay = DateTime(now.year, now.month, 1);
        final lastDay = DateTime(now.year, now.month + 1, 0);

        fromDate =
        "${firstDay.year}-${_pad(firstDay.month)}-${_pad(firstDay.day)}";
        toDate =
        "${lastDay.year}-${_pad(lastDay.month)}-${_pad(lastDay.day)}";
        statusId = 0; // 👈 API requirement for "All"
      }

      final headers = {
        ...AppUrls.header,
        "Content-Type": "application/x-www-form-urlencoded",
      };

      final body = <String, String>{
        "EmployeeCode": employeeCode,
        "Company": AppUrls.companyName,
        if (fromDate != null) "FromDate": fromDate,
        if (toDate != null) "ToDate": toDate,
        if (statusId != null) "Status": statusId.toString(), // 👈 ID sent here
      };

      debugPrint("📤 Sending Movement Report request: $body");

      // final uri = Uri.parse("${AppUrls.baseUrl}GetMovement_Report");
      final uri = AppUrls.getMovementReport;

      final res = await http
          .post(uri, headers: headers, body: body)
          .timeout(const Duration(seconds: 30));

      debugPrint("🟣 [movementView] HTTP ${res.statusCode}");

      if (res.statusCode != 200) {
        debugPrint("❌ Response body: ${res.body}");
        return null;
      }

      final map = json.decode(res.body) as Map<String, dynamic>;
      return MovementReportResponse.fromJson(map);
    } catch (e) {
      debugPrint("🔴 Error @movementView: $e");
      return null;
    }
  }

  String _pad(int n) => n.toString().padLeft(2, '0');
}

