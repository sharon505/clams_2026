import 'dart:convert';
import 'package:clams/features/Authentication/providers/auth_provider.dart';
import 'package:clams/network/app_url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../models/model_punch_log.dart';

class PunchLogService {
  Future<PunchLogResponse?> fetchPunchLog({
    required BuildContext context,
    required String processFrom,
    required String processTo,
    int branchId = 0,
    String departmentId = '0',
    String? employeeCode,
  }) async {
    try {
      final auth = context.read<AuthProvider>();

      final empCode = employeeCode ??
          auth.loginData?.data.first.employeeCode?.toString();

      if (empCode == null || empCode.isEmpty) return null;

      final body = {
        'ProcessFrom': processFrom,
        'ProcessTo': processTo,
        'BranchId': branchId.toString(),
        'DepartmentId': departmentId,
        'EmployeeCode': empCode,
        'Company': AppUrls.companyName,
      };

      // final uri = Uri.parse('${AppString.baseUrl}MyAttendance');
      final uri = AppUrls.myAttendance;
      final res = await http.post(uri, body: body, headers: AppUrls.header);

      if (res.statusCode != 200 || res.body.isEmpty) return null;

      return PunchLogResponse.fromJson(jsonDecode(res.body));
    } catch (e) {
      debugPrint('❌ PunchLogService error: $e');
      return null;
    }
  }
}
