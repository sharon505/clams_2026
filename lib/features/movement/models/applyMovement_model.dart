class ApplyMovementResponse {
  final List<MovementStatus> result;

  ApplyMovementResponse({
    required this.result,
  });

  factory ApplyMovementResponse.fromJson(Map<String, dynamic> json) {
    return ApplyMovementResponse(
      result: (json['Result'] as List<dynamic>? ?? [])
          .map((e) => MovementStatus.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Result': result.map((e) => e.toJson()).toList(),
    };
  }
}

class MovementStatus {
  final int statusId;
  final String msg;

  MovementStatus({
    required this.statusId,
    required this.msg,
  });

  factory MovementStatus.fromJson(Map<String, dynamic> json) {
    return MovementStatus(
      // API may send int OR string → handle both safely
      statusId: int.tryParse(json['StatusID']?.toString() ?? '') ?? 0,
      msg: json['MSG']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'StatusID': statusId,
      'MSG': msg,
    };
  }
}

