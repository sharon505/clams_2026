import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../../network/app_url.dart';
import '../../Authentication/providers/auth_provider.dart';
import '../models/model_punching.dart';
import '../providers/dateTime_viewModel.dart';
import '../../Authentication/models/model_login.dart';

PunchingDetailsServices punchingDetailsServices = PunchingDetailsServices();

class PunchingDetailsServices {

  Future<PunchResponseModel?> punchingToday({
    required BuildContext context,
  }) async {

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final dateTime = Provider.of<DateTimeViewModel>(context, listen: false);

    EmployeeData? employeeData = authProvider.loginData?.data.first;
    if (employeeData?.employeeCode == null) return null;

    Map<String, dynamic> map = {
      'Employeecode': employeeData!.employeeCode.toString(),
      'fromDate': dateTime.getTodayServerFormat().toString(),
      'toDate': dateTime.getTodayServerFormat().toString(),
      'Company': AppUrls.companyName,
    };

    try {
      print("🔻 Sending request:\n$map");
      final response = await http.post(
        AppUrls.punchingDetails,
        headers: AppUrls.header,
        body: map,
      );

      print("🔵 Status Code: ${response.statusCode}");
      print("🟢 Response Body:\n${response.body}");

      if (response.statusCode == 200) {
        final decodedJson = jsonDecode(response.body);
        return PunchResponseModel.fromJson(decodedJson);
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
