import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../../network/app_url.dart';
import '../models/model_login.dart';
import '../models/model_user.dart';

class AuthService {
  Future<LoginResponseModel?> login({
    required UserModel userModel,
  }) async {
    try {

      final url = AppUrls.login;

      print('🌐 Hitting URL: $url');
      print('📩 Headers: ${AppUrls.header}');
      print(
        '📩 Body: { Employeecode: ${userModel.usercode}, '
            'Password: ******, '
            'Company: ${AppUrls.companyName} }',
      );

      final response = await http.post(
        url,
        headers: AppUrls.header,
        body: {
          'Employeecode': userModel.usercode,
          'Password': userModel.password,
          'Company': AppUrls.companyName,
          'Version': AppUrls.version
        },
      );

      print('🔵 Status Code: ${response.statusCode}');
      print('🟢 Raw Response:\n${response.body}');

      // ❌ HTTP error
      if (response.statusCode != 200) {
        print('❌ HTTP ERROR: ${response.statusCode}');
        return null;
      }

      // ❌ Empty body
      if (response.body.isEmpty) {
        print('❌ EMPTY RESPONSE BODY');
        return null;
      }

      // ✅ Decode JSON safely
      final decoded = jsonDecode(response.body);
      print('✅ JSON decoded successfully');

      // ❌ Not a JSON object
      if (decoded is! Map<String, dynamic>) {
        print('❌ Invalid JSON structure (not a Map)');
        return null;
      }

      // ✅ Parse model safely
      try {
        final model = LoginResponseModel.fromJson(decoded);
        print('✅ LoginResponseModel parsed successfully');
        return model;
      } catch (e, st) {
        print('🛑 CRASH INSIDE LoginResponseModel.fromJson');
        print('👉 Type: ${e.runtimeType}');
        print('👉 Error: $e');
        print('👉 Stacktrace:\n$st');
        return null;
      }
    }

    // ---------------- NETWORK / SSL ----------------

    on HandshakeException catch (e, st) {
      print('🛑 HandshakeException (SSL/TLS)');
      print('👉 $e');
      print('👉 Stacktrace:\n$st');
      return null;
    } on SocketException catch (e, st) {
      print('🛑 SocketException (No Internet)');
      print('👉 $e');
      print('👉 Stacktrace:\n$st');
      return null;
    } on http.ClientException catch (e, st) {
      print('🛑 ClientException');
      print('👉 $e');
      print('👉 Stacktrace:\n$st');
      return null;
    }

    // ---------------- JSON / FORMAT ----------------

    on FormatException catch (e, st) {
      print('🛑 FormatException (Invalid JSON)');
      print('👉 $e');
      print('👉 Stacktrace:\n$st');
      return null;
    }

    // ---------------- UNKNOWN ----------------

    catch (e, st) {
      print('🛑 UNKNOWN ERROR IN LOGIN');
      print('👉 Type: ${e.runtimeType}');
      print('👉 Message: $e');
      print('👉 Stacktrace:\n$st');
      return null;
    }
  }
}
