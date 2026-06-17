class LeaveBalanceResponse {
  final List<ResultItem> result;
  final List<LeaveBalanceData> data;

  LeaveBalanceResponse({
    required this.result,
    required this.data,
  });

  factory LeaveBalanceResponse.fromJson(Map<String, dynamic> json) {
    return LeaveBalanceResponse(
      result: List<ResultItem>.from(
        json['Result'].map((item) => ResultItem.fromJson(item)),
      ),
      data: List<LeaveBalanceData>.from(
        json['Data'].map((item) => LeaveBalanceData.fromJson(item)),
      ),
    );
  }
}

class ResultItem {
  final int statusId;
  final String msg;

  ResultItem({
    required this.statusId,
    required this.msg,
  });

  factory ResultItem.fromJson(Map<String, dynamic> json) {
    return ResultItem(
      statusId: json['StatusID'],
      msg: json['MSG'],
    );
  }
}

class LeaveBalanceData {
  final int employeeCode;
  final String leaveType;
  final double leaveBalance;

  LeaveBalanceData({
    required this.employeeCode,
    required this.leaveType,
    required this.leaveBalance,
  });

  factory LeaveBalanceData.fromJson(Map<String, dynamic> json) {
    return LeaveBalanceData(
      employeeCode: json['EMPLOYEECODE'],
      leaveType: json['LeaveType'],
      leaveBalance: (json['LeaveBalance'] as num).toDouble(),
    );
  }
}
