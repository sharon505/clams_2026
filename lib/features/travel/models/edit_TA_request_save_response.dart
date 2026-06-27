class EditTARequestSaveResponse {
  final List<EditTARequestSaveResult> result;

  EditTARequestSaveResponse({required this.result});

  factory EditTARequestSaveResponse.fromJson(Map<String, dynamic> json) {
    return EditTARequestSaveResponse(
      result: (json['Result'] as List)
          .map((item) => EditTARequestSaveResult.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "Result": result.map((item) => item.toJson()).toList(),
    };
  }
}

class EditTARequestSaveResult {
  final int statusId;
  final String msg;

  EditTARequestSaveResult({
    required this.statusId,
    required this.msg,
  });

  factory EditTARequestSaveResult.fromJson(Map<String, dynamic> json) {
    return EditTARequestSaveResult(
      statusId: json['StatusID'] ?? 0,
      msg: json['MSG'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "StatusID": statusId,
      "MSG": msg,
    };
  }
}