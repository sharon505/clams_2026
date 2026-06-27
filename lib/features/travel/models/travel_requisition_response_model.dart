class TravelRequisitionResponse {
  final List<TravelRequisitionResult> result;

  TravelRequisitionResponse({required this.result});

  factory TravelRequisitionResponse.fromJson(Map<String, dynamic> json) {
    return TravelRequisitionResponse(
      result: (json['Result'] as List)
          .map((item) => TravelRequisitionResult.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "Result": result.map((item) => item.toJson()).toList(),
    };
  }
}

class TravelRequisitionResult {
  final int statusId;
  final String msg;

  TravelRequisitionResult({
    required this.statusId,
    required this.msg,
  });

  factory TravelRequisitionResult.fromJson(Map<String, dynamic> json) {
    return TravelRequisitionResult(
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
