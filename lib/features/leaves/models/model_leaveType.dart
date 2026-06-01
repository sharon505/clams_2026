class LeaveTypeResponse {
  final List<LeaveTypeResult> result;
  final List<LeaveTypeData> data;

  LeaveTypeResponse({
    required this.result,
    required this.data,
  });

  factory LeaveTypeResponse.fromJson(Map<String, dynamic> json) {
    return LeaveTypeResponse(
      result: (json['Result'] as List)
          .map((e) => LeaveTypeResult.fromJson(e))
          .toList(),
      data: (json['Data'] as List)
          .map((e) => LeaveTypeData.fromJson(e))
          .toList(),
    );
  }
}

class LeaveTypeResult {
  final int statusId;
  final String msg;

  LeaveTypeResult({
    required this.statusId,
    required this.msg,
  });

  factory LeaveTypeResult.fromJson(Map<String, dynamic> json) {
    return LeaveTypeResult(
      statusId: json['StatusID'],
      msg: json['MSG'],
    );
  }
}

class LeaveTypeData {
  final int leaveTypeId;
  final String leaveType;

  LeaveTypeData({
    required this.leaveTypeId,
    required this.leaveType,
  });

  factory LeaveTypeData.fromJson(Map<String, dynamic> json) {
    return LeaveTypeData(
      leaveTypeId: json['LeaveTypeId'],
      leaveType: json['LeaveType'],
    );
  }
}
