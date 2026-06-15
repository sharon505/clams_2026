class PunchLogResponse {
  final List<PunchLogItem> result;

  PunchLogResponse({required this.result});

  factory PunchLogResponse.fromJson(Map<String, dynamic> json) {
    return PunchLogResponse(
      result: (json['Result'] as List<dynamic>? ?? [])
          .map((e) => PunchLogItem.fromJson(e))
          .toList(),
    );
  }
}

class PunchLogItem {
  final String branch;
  final int employeeCode;
  final String name;
  final String designation;
  final DateTime? workDate;
  final String punchTime;
  final String? punchType;
  final String device;

  PunchLogItem({
    required this.branch,
    required this.employeeCode,
    required this.name,
    required this.designation,
    required this.workDate,
    required this.punchTime,
    required this.punchType,
    required this.device,
  });

  factory PunchLogItem.fromJson(Map<String, dynamic> json) {
    return PunchLogItem(
      branch: json['Branch'] ?? '',
      employeeCode: json['EmployeeCode'] ?? 0,
      name: json['Name'] ?? '',
      designation: json['Designation'] ?? '',
      workDate: json['WorkDate'] != null
          ? DateTime.tryParse(json['WorkDate'])
          : null,
      punchTime: json['PunchTime'] ?? '--',
      punchType: json['PunchType'],
      device: json['Device'] ?? '',
    );
  }

  /// Valid Punch
  bool get isValidPunch =>
      punchTime.isNotEmpty &&
          punchTime != '--' &&
          punchType != null &&
          punchType != 'SUN';

  // ==========================
  // ADD THESE GETTERS HERE
  // ==========================

  bool get isLeave {
    final type = (punchType ?? '').toLowerCase();

    return type.contains('leave') ||
        type.contains('casual') ||
        type.contains('earned') ||
        type.contains('sick') ||
        type.contains('maternity') ||
        type.contains('paternity') ||
        type.contains('bereavement') ||
        type.contains('loss of pay') ||
        type.contains('lop') ||
        type.contains('compensatory') ||
        type.contains('off day') ||
        type.contains('holiday') ||
        type.contains('rh');
  }

  bool get isMovement {
    final type = (punchType ?? '').toLowerCase();
    return type.contains('movement');
  }

  bool get isOfficialDuty {
    final type = (punchType ?? '').toLowerCase();
    return type.contains('official duty') || type == 'od';
  }

  bool get isHalfDay {
    final type = (punchType ?? '').toLowerCase();
    return type.contains('half day');
  }
}
