class CancelMovementResponse {
  final List<CancelMovementResult> result;

  CancelMovementResponse({required this.result});

  /// True if first result has StatusID == 200
  bool get isOk => result.isNotEmpty && result.first.statusId == 200;

  /// First message (or empty string)
  String get message => result.isNotEmpty ? result.first.msg : '';

  factory CancelMovementResponse.fromJson(Map<String, dynamic> json) {
    final list = (json['Result'] as List<dynamic>? ?? [])
        .map((e) => CancelMovementResult.fromJson(e as Map<String, dynamic>))
        .toList();
    return CancelMovementResponse(result: list);
  }

  Map<String, dynamic> toJson() => {
    'Result': result.map((e) => e.toJson()).toList(),
  };
}

class CancelMovementResult {
  final int statusId;
  final String msg;

  CancelMovementResult({
    required this.statusId,
    required this.msg,
  });

  factory CancelMovementResult.fromJson(Map<String, dynamic> json) =>
      CancelMovementResult(
        statusId: (json['StatusID'] as num?)?.toInt() ?? 0,
        msg: json['MSG'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
    'StatusID': statusId,
    'MSG': msg,
  };
}
