class LeaveSaveResponse {
  final List<Result> result;

  LeaveSaveResponse({required this.result});

  factory LeaveSaveResponse.fromJson(Map<String, dynamic> json) {
    return LeaveSaveResponse(
      result: (json['Result'] as List)
          .map((e) => Result.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Result': result.map((e) => e.toJson()).toList(),
    };
  }
}

class Result {
  final int statusId;
  final String msg;

  Result({required this.statusId, required this.msg});

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
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
