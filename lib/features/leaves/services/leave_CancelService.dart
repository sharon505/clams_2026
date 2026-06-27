import 'dart:convert';
import 'package:clams/features/Authentication/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../../network/app_url.dart';
import '../models/model_cancelLeave.dart';

class LeaveCancelServices {

  Future<CancelLeaveResponse?> cancelEmployeeLeave({
    required BuildContext context,
    required int leaveId,
  }) async {
    try {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      final employeeCode =
          auth.loginData?.data.first.employeeCode?.toString() ?? '';

      if (employeeCode.isEmpty) {
        debugPrint('❌ cancelEmployeeLeave: missing employee code');
        return null;
      }

      final body = <String, String>{
        'LeaveId': leaveId.toString(),
        'StatusId': '3',
        'Status_Description': '',
        'UpdatedBy': employeeCode,
        'Employeecode'     : employeeCode,
        'RejectedReason': '',
        'Company': AppUrls.companyName,
      };

      final uri = AppUrls.cancelEmployeeLeave;
      debugPrint('================ Cancel Leave API ================');
      debugPrint('🌐 URL      : $uri');
      debugPrint('📤 Headers  : ${AppUrls.header}');
      debugPrint('📤 Body     : ${jsonEncode(body)}');

      final res = await http.post(uri, headers: AppUrls.header, body: body);

      debugPrint('🟣 [CancelEmployeeLeave] ${res.statusCode}');
      if (res.statusCode != 200) {
        debugPrint('❌ Body: ${res.body}');
        return null;
      }

      final map = json.decode(res.body) as Map<String, dynamic>;
      debugPrint('📥 Parsed JSON : ${jsonEncode(map)}');

      final response = CancelLeaveResponse.fromJson(map);

      debugPrint(
        '✅ StatusID : ${response.result.isNotEmpty ? response.result.first.statusId : "N/A"}',
      );
      debugPrint(
        '✅ Message  : ${response.result.isNotEmpty ? response.result.first.msg : "N/A"}',
      );
      debugPrint('==================================================');
      return CancelLeaveResponse.fromJson(map);
    } catch (e) {
      debugPrint('🔴 Exception @cancelEmployeeLeave: $e');
      return null;
    }
  }
}
