/// ================= ROOT MODEL =================
class LeaveApprovalResponse {
  final LeaveStatusResult result;
  final List<LeaveApprovalItem> table1;

  LeaveApprovalResponse({
    required this.result,
    required this.table1,
  });

  factory LeaveApprovalResponse.fromJson(Map<String, dynamic> json) {
    return LeaveApprovalResponse(
      result: LeaveStatusResult.fromJson(json['Result'] ?? {}),
      table1: (json['Table1'] as List<dynamic>? ?? [])
          .map((e) => LeaveApprovalItem.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "Result": result.toJson(),
      "Table1": table1.map((e) => e.toJson()).toList(),
    };
  }
}

/// ================= RESULT MODEL =================
class LeaveStatusResult {
  final int status;
  final String message;

  LeaveStatusResult({
    required this.status,
    required this.message,
  });

  factory LeaveStatusResult.fromJson(Map<String, dynamic> json) {
    return LeaveStatusResult(
      status: _toInt(json['Status']),
      message: json['Message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "Status": status,
      "Message": message,
    };
  }
}

/// ================= MAIN ITEM =================
class LeaveApprovalItem {
  final int leaveId;
  final String employeeCode;
  final String employeeName;
  final String designation;
  final String location;
  final String fromDate;
  final String toDate;
  final double noOfDays;
  final String leaveType;
  final bool isHalfDay;
  final String leaveSection;
  final String appliedCode;
  final String appliedTo;
  final String status;
  final int eligibleCasual;
  final int eligibleSick;
  final String availableLeave;
  final int leaveTypeId;
  final double eligibleEarnLeave;
  final String appliedDate;
  final String appDate;
  final String leaveReason;
  final String? crnDetails;
  final int enableFlag;
  final String crn;
  final List<LeaveDetail> leaveDetails;

  LeaveApprovalItem({
    required this.leaveId,
    required this.employeeCode,
    required this.employeeName,
    required this.designation,
    required this.location,
    required this.fromDate,
    required this.toDate,
    required this.noOfDays,
    required this.leaveType,
    required this.isHalfDay,
    required this.leaveSection,
    required this.appliedCode,
    required this.appliedTo,
    required this.status,
    required this.eligibleCasual,
    required this.eligibleSick,
    required this.availableLeave,
    required this.leaveTypeId,
    required this.eligibleEarnLeave,
    required this.appliedDate,
    required this.appDate,
    required this.leaveReason,
    required this.crnDetails,
    required this.enableFlag,
    required this.crn,
    required this.leaveDetails,
  });

  factory LeaveApprovalItem.fromJson(Map<String, dynamic> json) {
    return LeaveApprovalItem(
      leaveId: _toInt(json['LeaveId']),
      employeeCode: json['EmployeeCode'] ?? '',
      employeeName: json['EmployeeName'] ?? '',
      designation: json['Designation'] ?? '',
      location: json['Location'] ?? '',
      fromDate: json['FromDate'] ?? '',
      toDate: json['Todate'] ?? '',
      noOfDays: _toDouble(json['NoOfDays']),
      leaveType: json['LeaveType'] ?? '',
      isHalfDay: json['isHalfDay'] ?? false,
      leaveSection: json['leaveSection'] ?? '',
      appliedCode: json['AppliedCode'] ?? '',
      appliedTo: json['AppliedTo'] ?? '',
      status: json['Status'] ?? '',
      eligibleCasual: _toInt(json['EligibleCasual']),
      eligibleSick: _toInt(json['EligibleSick']),

      /// 🔥 IMPORTANT FIX
      availableLeave: json['EmployAvailableLeaveeeName'] ?? '',

      leaveTypeId: _toInt(json['LeaveTypeId']),
      eligibleEarnLeave: _toDouble(json['EligibleEarnLeave']),
      appliedDate: json['AppliedDate'] ?? '',
      appDate: json['AppDate'] ?? '',
      leaveReason: json['LeaveReason'] ?? '',
      crnDetails: json['crndetails'],
      enableFlag: _toInt(json['EnableFlag']),
      crn: json['CRN'] ?? '',

      /// 🔥 NEW FIELD
      leaveDetails: (json['leave_details'] as List<dynamic>? ?? [])
          .map((e) => LeaveDetail.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "LeaveId": leaveId,
      "EmployeeCode": employeeCode,
      "EmployeeName": employeeName,
      "Designation": designation,
      "Location": location,
      "FromDate": fromDate,
      "Todate": toDate,
      "NoOfDays": noOfDays,
      "LeaveType": leaveType,
      "isHalfDay": isHalfDay,
      "leaveSection": leaveSection,
      "AppliedCode": appliedCode,
      "AppliedTo": appliedTo,
      "Status": status,
      "EligibleCasual": eligibleCasual,
      "EligibleSick": eligibleSick,
      "EmployAvailableLeaveeeName": availableLeave,
      "LeaveTypeId": leaveTypeId,
      "EligibleEarnLeave": eligibleEarnLeave,
      "AppliedDate": appliedDate,
      "AppDate": appDate,
      "LeaveReason": leaveReason,
      "crndetails": crnDetails,
      "EnableFlag": enableFlag,
      "CRN": crn,
      "leave_details": leaveDetails.map((e) => e.toJson()).toList(),
    };
  }
}

/// ================= LEAVE DETAILS =================
class LeaveDetail {
  final String employeeCode;
  final String punchDateTime;
  final String deviceName;

  LeaveDetail({
    required this.employeeCode,
    required this.punchDateTime,
    required this.deviceName,
  });

  factory LeaveDetail.fromJson(Map<String, dynamic> json) {
    return LeaveDetail(
      employeeCode: json['EmployeeCode'] ?? '',
      punchDateTime: json['PunchDateTime'] ?? '',
      deviceName: json['DeviceName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "EmployeeCode": employeeCode,
      "PunchDateTime": punchDateTime,
      "DeviceName": deviceName,
    };
  }
}

/// ================= COMMON PARSERS =================
int _toInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  return int.tryParse(value.toString()) ?? 0;
}

double _toDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  return double.tryParse(value.toString()) ?? 0.0;
}