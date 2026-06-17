import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'package:clams/features/Authentication/providers/auth_provider.dart';
import 'package:clams/features/profile/models/employee_model.dart';
import 'package:clams/network/app_url.dart';

class EmployeeServices {
  Future<Employee?> fetchMyEmployeeDetails({
    required BuildContext context,
  }) async {
    try {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      final employeeCode = auth.loginData?.data.first.employeeCode?.toString() ?? '';

      if (employeeCode.isEmpty) {
        debugPrint('❌ fetchMyEmployeeDetails: missing employee code');
        return null;
      }

      return fetchEmployeeDetailsByCode(employeeCode: employeeCode);
    } catch (e) {
      debugPrint('🔴 Exception @fetchMyEmployeeDetails: $e');
      return null;
    }
  }

  /// Fetch details for any employee by code.
  /// Useful if you need to look up a peer / reportee.
  Future<Employee?> fetchEmployeeDetailsByCode({
    required String employeeCode,
  }) async {
    try {
      if (employeeCode.isEmpty) {
        debugPrint('❌ fetchEmployeeDetailsByCode: empty employeeCode');
        return null;
      }

      final uri = AppUrls.getEmployeeDetails;
      final body = {
        'EmployeeCode': employeeCode,
        'Company': AppUrls.companyName,
      };

      final res = await http
          .post(uri, headers: AppUrls.header, body: body)
          .timeout(const Duration(seconds: 20));

      debugPrint('🔵 [GetEmployee_Details] ${res.statusCode}');
      if (res.statusCode != 200) {
        debugPrint('❌ Body: ${res.body}');
        return null;
      }

      final Map<String, dynamic> jsonMap =
      json.decode(res.body) as Map<String, dynamic>;

      // Expecting: { "Result": [ { ...employee fields... } ], ... }
      final List<dynamic> resultList = (jsonMap['Result'] as List?) ?? [];
      if (resultList.isEmpty) {
        debugPrint('ℹ️ No employee records found in Result[]');
        return null;
      }

      final Employee emp = Employee.fromJson(
        resultList.first as Map<String, dynamic>,
      );
      return emp;
    } catch (e) {
      debugPrint('🔴 Exception @fetchEmployeeDetailsByCode: $e');
      return null;
    }
  }
}
