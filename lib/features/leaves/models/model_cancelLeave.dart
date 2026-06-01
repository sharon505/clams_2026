

class CancelLeaveResponse {
  final List<CancelLeaveResult> result;

  CancelLeaveResponse({required this.result});

  factory CancelLeaveResponse.fromJson(Map<String, dynamic> json) {
    return CancelLeaveResponse(
      result: (json['Result'] as List<dynamic>)
          .map((e) => CancelLeaveResult.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Result': result.map((e) => e.toJson()).toList(),
    };
  }
}

class CancelLeaveResult {
  final int statusId;
  final String msg;

  CancelLeaveResult({
    required this.statusId,
    required this.msg,
  });

  factory CancelLeaveResult.fromJson(Map<String, dynamic> json) {
    return CancelLeaveResult(
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
