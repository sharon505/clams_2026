import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'package:clams/network/app_url.dart';
import 'package:clams/features/Authentication/models/model_login.dart';
import 'package:clams/features/Authentication/providers/auth_provider.dart';
import 'package:clams/features/profile/models/model_leaveBalance.dart';

class LeaveBalanceService {

  Future<LeaveBalanceResponse?> LeaveBalanceResponce({
    required BuildContext context,
  }) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    EmployeeData? employeeData = authProvider.loginData?.data.first;

    Map<String,String>map={
      'Employeecode':employeeData!.employeeCode.toString(),
      'Company':AppUrls.companyName
    };

    try {
      print("🔻 Sending request:\n$map");
      final response = await http.post(
        AppUrls.leaveBalanceData,
        headers: AppUrls.header,
        body: map,
      );

      print("🔵 Status Code: ${response.statusCode}");
      print("🟢 Response Body:\n${response.body}");

      if (response.statusCode == 200) {
        final decodedJson = jsonDecode(response.body);
        return LeaveBalanceResponse.fromJson(decodedJson);
      } else {
        print("❌ Request failed with status: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("🔴 HTTP error: $e");
      return null;
    }

  }

}
