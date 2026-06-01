class LeaveSummaryResponse {
  final List<LeaveResult> result;
  final List<LeaveRecord> table1;

  LeaveSummaryResponse({
    required this.result,
    required this.table1,
  });

  factory LeaveSummaryResponse.fromJson(Map<String, dynamic> json) {
    return LeaveSummaryResponse(
      result: (json['Result'] as List<dynamic>)
          .map((e) => LeaveResult.fromJson(e))
          .toList(),
      table1: (json['Table1'] as List<dynamic>)
          .map((e) => LeaveRecord.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Result': result.map((e) => e.toJson()).toList(),
      'Table1': table1.map((e) => e.toJson()).toList(),
    };
  }
}

class LeaveResult {
  final int statusId;
  final String msg;

  LeaveResult({
    required this.statusId,
    required this.msg,
  });

  factory LeaveResult.fromJson(Map<String, dynamic> json) {
    return LeaveResult(
      statusId: json['StatusID'] ?? 0,
      msg: json['MSG'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'StatusID': statusId,
      'MSG': msg,
    };
  }
}

class LeaveRecord {
  final int leaveId;
  final String employeeCode;
  final String fromDate;
  final String toDate;
  final String leaveType;
  final String status;
  final String appliedTo;
  final bool isHalfDay;
  final String leaveSection;
  final double noOfDays;
  final String? updatedDate;
  final String appliedDate;
  final String leaveReason;
  final int processed;
  final String rejectedReason;

  LeaveRecord({
    required this.leaveId,
    required this.employeeCode,
    required this.fromDate,
    required this.toDate,
    required this.leaveType,
    required this.status,
    required this.appliedTo,
    required this.isHalfDay,
    required this.leaveSection,
    required this.noOfDays,
    this.updatedDate,
    required this.appliedDate,
    required this.leaveReason,
    required this.processed,
    required this.rejectedReason,
  });

  factory LeaveRecord.fromJson(Map<String, dynamic> json) {
    return LeaveRecord(
      leaveId: json['LeaveId'] ?? 0,
      employeeCode: json['EmployeeCode'] ?? '',
      fromDate: json['FromDate'] ?? '',
      toDate: json['Todate'] ?? '',
      leaveType: json['LeaveType'] ?? '',
      status: json['Status'] ?? '',
      appliedTo: json['AppliedTo'] ?? '',
      isHalfDay: json['isHalfDay'] ?? false,
      leaveSection: json['leaveSection'] ?? '',
      noOfDays: (json['NoOfDays'] as num?)?.toDouble() ?? 0.0,
      updatedDate: json['UpdatedDate'],
      appliedDate: json['AppliedDate'] ?? '',
      leaveReason: json['LeaveReason'] ?? '',
      processed: json['Processed'] ?? 0,
      rejectedReason: json['RejectedReason'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'LeaveId': leaveId,
      'EmployeeCode': employeeCode,
      'FromDate': fromDate,
      'Todate': toDate,
      'LeaveType': leaveType,
      'Status': status,
      'AppliedTo': appliedTo,
      'isHalfDay': isHalfDay,
      'leaveSection': leaveSection,
      'NoOfDays': noOfDays,
      'UpdatedDate': updatedDate,
      'AppliedDate': appliedDate,
      'LeaveReason': leaveReason,
      'Processed': processed,
      'RejectedReason': rejectedReason,
    };
  }
}
