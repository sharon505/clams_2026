import 'dart:convert';
import 'package:clams/features/Authentication/providers/auth_provider.dart';
import 'package:clams/features/leaves/providers/leaveType_viewModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../network/app_url.dart';
import '../models/model_leaveResponse.dart';
import '../models/model_leaveType.dart';

LeaveService leaveTypeService = LeaveService();


class LeaveService {

  static const bool _sendLeaveTypeId = false;

  Future<LeaveSaveResponse> applyLeave({
    required BuildContext context,
  }) async {

    final info = await PackageInfo.fromPlatform();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final leaveTypeProvider = Provider.of<LeaveTypeProvider>(context, listen: false);

    // ---- Basic validations ----
    final employeeCode = authProvider.loginData?.data.first.employeeCode?.toString() ?? '';
    if (employeeCode.isEmpty) {
      throw Exception('Missing employee code');
    }
    if (leaveTypeProvider.selectedLeaveType == null) {
      throw Exception('Please select a leave type');
    }
    if (leaveTypeProvider.fromDate == null) {
      throw Exception('Please select From Date');
    }

    // ---- Dates & encodings ----
    final df = DateFormat('yyyy-MM-dd');
    final bool isHalfDayBool = leaveTypeProvider.selectedDayType == 'Half Day';

    final String fromDate = df.format(leaveTypeProvider.fromDate!);
    final String toDate = isHalfDayBool
        ? fromDate
        : df.format((leaveTypeProvider.toDate ?? leaveTypeProvider.fromDate!) );
    final String isHalfDay = !isHalfDayBool ? 'false' : 'true';

    // Send name by default; flip _sendLeaveTypeId to true if API needs ID.
    final String leaveTypeValue = _sendLeaveTypeId
        ? (leaveTypeProvider.selectedLeaveType?.leaveTypeId?.toString() ?? '')
        : (leaveTypeProvider.selectedLeaveType?.leaveType ?? '');

    // ---- Body ----
    ///todo leave section is not working
    final Map<String, String> body = {
      'Employeecode': employeeCode,
      'Company': AppUrls.companyName,
      'LeaveType': leaveTypeValue,
      'FromDate': fromDate,
      'Todate': toDate,
      'isHalfDay': isHalfDay, // "0" half, "1" full
      'LeaveSection': isHalfDayBool ? leaveTypeProvider.selectedLeaveSection : 'Full day',
      'LeaveReason': leaveTypeProvider.reasonController.text.trim(),
      'CRN': leaveTypeProvider.cRNController.text.trim(),
      'Version': info.version,
    };

    debugPrint("🟡 Request Body: $body");

    try {
      final uri = AppUrls.applyLeave;
      // final uri = Uri.parse('${AppUrls.baseUrl}ApplyLeave');
      final res = await http.post(
        uri,
        headers: AppUrls.header, // should include application/x-www-form-urlencoded
        body: body,
      );
      if (res.statusCode != 200) {
        debugPrint("❌ Server error: ${res.statusCode} ${res.body}");
        throw Exception('Server error ${res.statusCode}');
      }

      debugPrint("✅ Leave applied: ${res.body}");

      final Map<String, dynamic> jsonMap =
      json.decode(res.body) as Map<String, dynamic>;
      final parsed = LeaveSaveResponse.fromJson(jsonMap);

      // Optional: use API code to decide success
      if (parsed.result.isNotEmpty && parsed.result.first.statusId == 200) {
        leaveTypeProvider.resetForm();
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text(parsed.result.first.msg)),
        // );
      } else {
        // Non-200 in payload but HTTP 200
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text(parsed.result.isNotEmpty
        //       ? parsed.result.first.msg
        //       : 'Failed to apply for leave')),
        // );
      }
      return parsed;
    } catch (e) {
      debugPrint("❌ Error submitting leave: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to apply for leave. Try again.')),
      );
      // Re-throw so caller can handle/log if needed
      rethrow;
    }
  }

  Future<LeaveTypeResponse?> fetchLeaveTypes({
    required BuildContext context,
  }) async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final employeeCode = authProvider.loginData?.data.first.employeeCode;

      final Map<String, String> body = {
        'Employeecode': employeeCode.toString(),
        'Company': AppUrls.companyName,
      };

      final response = await http.post(
        AppUrls.leaveType,
        headers: AppUrls.header,
        body: body,
      );

      print("🔵 Status Code: ${response.statusCode}");
      print("🟢 Response Body:\n${response.body}");

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return LeaveTypeResponse.fromJson(decoded);
      } else {
        print("❌ Failed to fetch leave types.");
        return null;
      }
    } catch (e) {
      print("🔴 Exception in fetchLeaveTypes: $e");
      return null;
    }
  }
}
