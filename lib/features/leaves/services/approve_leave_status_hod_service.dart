// // approve_leave_status_hod_service.dart
//
// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:provider/provider.dart';
//
// import 'package:clams_ciinfos/constants/app_strings.dart';
// import '../../../../network/app_url.dart';
// import '../../../authentication/models/model_login.dart';
// import '../../../authentication/viewModels/auth_provider.dart';
// import '../../models/succeses/leave_update_response.dart';
//
// class ApproveLeaveStatusHodService {
//   /// Calls `ApproveLeaveStatusHod` API
//   ///
//   /// POST body:
//   /// LeaveId:
//   /// StatusId:
//   /// StatusDescription:
//   /// Updatedby:
//   /// Reason:
//   /// Company:
//   Future<LeaveUpdateResponse?> approveLeaveStatusHod({
//     required BuildContext context,
//     required String leaveId,
//     required String statusId,
//     required String statusDescription,
//     required String reason,
//   }) async {
//
//     // 🔹 Get logged in employee (for Updatedby)
//     final authProvider = Provider.of<AuthProvider>(context, listen: false);
//     EmployeeData? employeeData = authProvider.loginData?.data.first;
//
//     if (employeeData == null) {
//       debugPrint("❌ No employee data found in AuthProvider!");
//       return null;
//     }
//
//     // Updatedby → EmployeeCode
//     final String updatedBy = employeeData.employeeCode.toString();
//
//     final Map<String, String> body = {
//       'LeaveId'          : leaveId,
//       'StatusId'         : statusId,
//       'StatusDescription': statusDescription,
//       'Updatedby'        : updatedBy,
//       'Employeecode'     : updatedBy,
//       'Reason'           : reason,
//       'Company'          : AppString.companyName,
//     };
//
//     try {
//       debugPrint("🔻 Sending ApproveLeaveStatusHod request:\n$body");
//
//       final response = await http.post(
//         AppUrls.approveLeaveStatusHod,
//         headers: AppString.header,
//         body: body,
//       );
//
//       debugPrint("🔵 Status Code: ${response.statusCode}");
//       debugPrint("🟢 Response Body:\n${response.body}");
//
//       if (response.statusCode == 200) {
//         final decodedJson = jsonDecode(response.body) as Map<String, dynamic>;
//         return LeaveUpdateResponse.fromJson(decodedJson);
//       } else {
//         debugPrint(
//           "❌ ApproveLeaveStatusHod failed with status: ${response.statusCode}",
//         );
//         return null;
//       }
//     } catch (e) {
//       debugPrint("🔴 HTTP error in ApproveLeaveStatusHodService: $e");
//       return null;
//     }
//   }
// }
