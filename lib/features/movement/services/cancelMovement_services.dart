import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:clams/features/Authentication/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../../network/app_url.dart';
import '../models/cancelMovement_model.dart';

class MovementCancelServices {
  Future<CancelMovementResponse?> movementCancel({
    required BuildContext context,
    required int movementId,
    String? reason,
  }) async {
    try {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      final employeeCode =
          auth.loginData?.data.first.employeeCode?.toString() ?? '';

      if (employeeCode.isEmpty) {
        debugPrint('❌ movementCancel: missing employee code');
        return null;
      }

      final body = <String, String>{
        'Id': movementId.toString(),
        'Status':'3',
        'UpdatedBy': employeeCode,
        'Employeecode':employeeCode,
        'Company': AppUrls.companyName,
      };

      // final uri = Uri.parse('${AppUrls.baseUrl}CancelEmployeeMovement');
      final uri = AppUrls.cancelEmployeeMovement;
      final res = await http
          .post(uri, headers: AppUrls.header, body: body)
          .timeout(const Duration(seconds: 30));

      debugPrint('🟣 [movementCancel] HTTP ${res.statusCode}');
      if (res.statusCode != 200) {
        debugPrint('❌ Response body: ${res.body}');
        return null;
      }

      final map = json.decode(res.body) as Map<String, dynamic>;
      return CancelMovementResponse.fromJson(map);
    } on TimeoutException catch (e) {
      debugPrint('🔴 Timeout @movementCancel: $e');
      return null;
    } on SocketException catch (e) {
      debugPrint('🔴 Network @movementCancel: $e');
      return null;
    } on FormatException catch (e) {
      debugPrint('🔴 JSON parse @movementCancel: $e');
      return null;
    } catch (e) {
      debugPrint('🔴 Exception @movementCancel: $e');
      return null;
    }
  }
}
