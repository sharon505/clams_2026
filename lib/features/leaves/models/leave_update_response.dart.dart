/// Root model for:
/// {
///   "Result": [ { "StatusID": 200, "MSG": "Leave Successfully Updated!" } ]
/// }
class LeaveUpdateResponse {
  final List<LeaveUpdateResult> result;

  LeaveUpdateResponse({required this.result});

  factory LeaveUpdateResponse.fromJson(Map<String, dynamic> json) {
    return LeaveUpdateResponse(
      result: (json['Result'] as List<dynamic>? ?? [])
          .map((e) => LeaveUpdateResult.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Result': result.map((e) => e.toJson()).toList(),
    };
  }
}

class LeaveUpdateResult {
  final int statusId;
  final String msg;

  LeaveUpdateResult({
    required this.statusId,
    required this.msg,
  });

  factory LeaveUpdateResult.fromJson(Map<String, dynamic> json) {
    final rawStatus = json['StatusID'];

    return LeaveUpdateResult(
      statusId: rawStatus is String
          ? int.tryParse(rawStatus) ?? 0
          : (rawStatus ?? 0) as int,
      msg: (json['MSG'] ?? '') as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'StatusID': statusId,
      'MSG': msg,
    };
  }
}
