import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:clams/features/Authentication/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../../network/app_url.dart';
import '../models/applyMovement_model.dart';
import '../viewmodel/movementForm_ViewModel.dart';

class ApplyMovementServices {
  /// Applies a movement request using values from MovementFormViewModel.
  /// Returns null on any error.
  Future<ApplyMovementResponse?> applyMovement({
    required BuildContext context,
  }) async {
    try {
      final auth = context.read<AuthProvider>();
      final vm = context.read<MovementFormViewModel>();

      final employeeCode =
          auth.loginData?.data.first.employeeCode?.toString() ?? '';

      if (employeeCode.isEmpty) {
        debugPrint('❌ [ApplyMovement] Employee code missing');
        return null;
      }

      // ---------- VALIDATION ----------
      final err = vm.validate();
      if (err != null) {
        debugPrint('❌ [ApplyMovement] Validation failed: $err');
        return null;
      }

      // ---------- BUILD DATETIME ----------
      final fromDT = _combine(vm.fromDate!, vm.fromTime!);
      final toDT = _combine(vm.toDate!, vm.toTime!);

      // ---------- REQUEST BODY ----------
      final body = <String, String>{
        'Fromdate': _fmtDateTime(fromDT),
        'ToDate': _fmtDateTime(toDT),
        'Description': vm.reasonC.text.trim(),
        'Status': '1',
        'UpdatedBy': employeeCode,
        'EmployeeCode': employeeCode,
        'Company': AppUrls.companyName,
        'Version': '1.0.0',
      };

      debugPrint('📤 [ApplyMovement] REQUEST BODY:');
      debugPrint(const JsonEncoder.withIndent('  ').convert(body));

      // ---------- API CALL ----------
      // final uri = Uri.parse('${AppUrls.baseUrl}ApplyMovement');
      final uri = AppUrls.applyMovement;

      final res = await http
          .post(uri, headers: AppUrls.header, body: body)
          .timeout(const Duration(seconds: 30));

      debugPrint('📥 [ApplyMovement] STATUS CODE: ${res.statusCode}');
      debugPrint('📥 [ApplyMovement] RAW RESPONSE: ${res.body}');

      if (res.statusCode != 200) {
        debugPrint('❌ [ApplyMovement] HTTP error');
        return null;
      }

      // ---------- PARSE JSON ----------
      final Map<String, dynamic> map =
      json.decode(res.body) as Map<String, dynamic>;

      debugPrint('🧾 [ApplyMovement] PARSED JSON:');
      debugPrint(const JsonEncoder.withIndent('  ').convert(map));

      // ---------- MODEL ----------
      final response = ApplyMovementResponse.fromJson(map);

      // ---------- IMPORTANT FIELDS ----------
      if (response.result != null && response.result!.isNotEmpty) {
        debugPrint(
            '✅ [ApplyMovement] STATUS ID: ${response.result!.first.statusId}');
        debugPrint(
            '✅ [ApplyMovement] MESSAGE: ${response.result!.first.msg}');
      }

      return response;
    }

    // ---------- ERROR HANDLING ----------
    on TimeoutException catch (e) {
      debugPrint('⏰ [ApplyMovement] Timeout: $e');
      return null;
    } on SocketException catch (e) {
      debugPrint('🌐 [ApplyMovement] Network error: $e');
      return null;
    } on FormatException catch (e) {
      debugPrint('🧨 [ApplyMovement] JSON parse error: $e');
      return null;
    } catch (e) {
      debugPrint('🔥 [ApplyMovement] Unknown error: $e');
      return null;
    }
  }

  // ---------------------------------------------------------------------------
  // HELPERS
  // ---------------------------------------------------------------------------

  DateTime _combine(DateTime d, TimeOfDay t) {
    return DateTime(d.year, d.month, d.day, t.hour, t.minute);
  }

  String _fmtDateTime(DateTime dt) {
    String two(int n) => n < 10 ? '0$n' : '$n';

    final y = dt.year.toString().padLeft(4, '0');
    final m = two(dt.month);
    final d = two(dt.day);
    final hh = two(dt.hour);
    final mm = two(dt.minute);

    return '$y-$m-$d $hh:$mm:00';
  }
}
