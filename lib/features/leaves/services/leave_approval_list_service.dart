import 'dart:convert';

import 'package:clams/features/Authentication/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../../network/app_url.dart';
import '../models/leave_approval_response_model.dart';
import 'package:clams/features/Authentication/models/model_login.dart';

class LeaveApprovalListService {
  Future<LeaveApprovalResponse?> leaveApprovalListResponce({
    required BuildContext context,
  }) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    EmployeeData? employeeData = authProvider.loginData?.data.first;

    // 🔹 POST body
    final Map<String, String> body = {
      'EmployeeCode': employeeData!.employeeCode.toString(),
      'Company': AppUrls.companyName,
    };

    try {
      print("🔻 Sending LeaveApprovalList request:\n$body");

      final response = await http.post(
        AppUrls.leaveApprovalList,
        headers: AppUrls.header,
        body: body,
      );

      print("🔵 Status Code: ${response.statusCode}");
      print("🟢 Response Body:\n${response.body}");

      if (response.statusCode == 200) {
        final decodedJson = jsonDecode(response.body);
        return LeaveApprovalResponse.fromJson(decodedJson);
      } else {
        print("❌ LeaveApprovalList failed with status: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("🔴 HTTP error in LeaveApprovalListService: $e");
      return null;
    }
  }
}
