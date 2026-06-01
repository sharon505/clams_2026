import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../models/model_login.dart';
import '../models/model_user.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  bool _isObscure = true;
  bool get isObscure => _isObscure;

  void toggleVisibility() {
    _isObscure = !_isObscure;
    notifyListeners();
  }

  bool _isLoading = false;
  LoginResponseModel? _loginData;
  LoginResponseModel? _errorData;
  String? _error;

  Uint8List? _profileImageBytes;
  Uint8List? get profileImageBytes => _profileImageBytes;

  final AuthService _authService = AuthService();

  bool get isLoading => _isLoading;
  LoginResponseModel? get loginData => _loginData;
  LoginResponseModel? get errorData => _errorData;
  String? get error => _error;

  EmployeeData? get userData {
    return _loginData?.data.isNotEmpty == true
        ? _loginData!.data.first
        : null;
  }

  String? get companyName {
    return _loginData?.company.isNotEmpty == true
        ? _loginData!.company.first.companyName
        : null;
  }

  bool get isManager {
    return _loginData?.data.first.isReportingManager == true;
  }

  Future<void> refreshProfileImage(String? fileContent) async {
    if (fileContent == null || fileContent.isEmpty) {
      _profileImageBytes = null;
      notifyListeners();
      return;
    }

    try {
      final cleaned = fileContent.contains(',')
          ? fileContent.split(',').last
          : fileContent;

      _profileImageBytes = base64Decode(cleaned);
    } catch (e) {
      _profileImageBytes = null;
      debugPrint("Image refresh decode error: $e");
    }

    notifyListeners();
  }

  Future<void> loginUser(UserModel userModel) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _authService.login(userModel: userModel);

      if (response != null && response.result.first.statusId == 200) {
        _loginData = response;

        final fileContent = response.data.isNotEmpty
            ? response.data.first.fileContent
            : null;

        if (fileContent != null && fileContent.isNotEmpty) {
          try {
            _profileImageBytes = base64Decode(fileContent);
          } catch (e) {
            _profileImageBytes = null;
            debugPrint("Image decode error: $e");
          }
        } else {
          _profileImageBytes = null;
        }

        debugPrint(
          "✅ Login Successful: ${_loginData?.data.first.employeeName}",
        );
      } else {
        _errorData = response;
        _error = "Login failed. Please check your credentials.";
        debugPrint("❌ Login failed.");
      }
    } catch (e) {
      _error = e.toString();
      debugPrint("🔴 Error: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  DateTime? get officeInTime {
    final t = _loginData?.data.first.attMrIn;
    return _parseTime(t);
  }

  DateTime? get officeOutTime {
    final t = _loginData?.data.first.attMrOut;
    return _parseTime(t);
  }

  DateTime? get eveningLimitTime {
    final t = _loginData?.data.first.attEvLimit;
    return _parseTime(t);
  }

  DateTime? _parseTime(String? time) {
    if (time == null || time.isEmpty) return null;

    try {
      final parts = time.split(' ');
      final hms = parts[0].split(':');

      int h = int.parse(hms[0]);
      final m = int.parse(hms[1]);
      final s = int.parse(hms[2]);

      if (parts[1] == 'PM' && h != 12) h += 12;
      if (parts[1] == 'AM' && h == 12) h = 0;

      return DateTime(0, 1, 1, h, m, s);
    } catch (_) {
      return null;
    }
  }

  String? get loginErrorMessage {
    return errorData?.result.isNotEmpty == true
        ? errorData?.result.first.msg
        : error;
  }

  void clearProfileImage() {
    _profileImageBytes = null;
    notifyListeners();
  }

  void logoutUser() {
    _loginData = null;
    _profileImageBytes = null;
    notifyListeners();
  }
}