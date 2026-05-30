import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../../network/app_url.dart';
import '../providers/auth_provider.dart';

class ImageUploadService {
  Future<Map<String, dynamic>?> uploadImage({
    required BuildContext context,
    required String fileBytes,
    required String fileExtension,
  }) async {
    try {
      final auth = Provider.of<AuthProvider>(context, listen: false);

      final employeeCode =
          auth.loginData?.data.first.employeeCode?.toString() ?? '';

      if (employeeCode.isEmpty) {
        debugPrint('❌ uploadImage: missing employee code');
        return null;
      }

      final body = <String, String>{
        'Employeecode': employeeCode,
        'FileBytes': fileBytes,
        'FileExtention': fileExtension,
        'CreatedBy': employeeCode,
        'Company': AppUrls.companyName,
      };

      final uri = AppUrls.imageUpload;

      final res = await http.post(
        uri,
        headers: AppUrls.header,
        body: body,
      );

      debugPrint('🟣 [ImageUpload] Status: ${res.statusCode}');
      debugPrint('🟣 [ImageUpload] Response: ${res.body}');

      if (res.statusCode != 200) {
        debugPrint('❌ Image upload failed');
        return null;
      }

      final map = json.decode(res.body) as Map<String, dynamic>;
      return map;
    } catch (e) {
      debugPrint('🔴 Exception @uploadImage: $e');
      return null;
    }
  }
}