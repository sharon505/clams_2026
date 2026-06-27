class UpdateTAResponse {
  final List<UpdateTAResult> result;

  UpdateTAResponse({
    required this.result,
  });

  factory UpdateTAResponse.fromJson(Map<String, dynamic> json) {
    return UpdateTAResponse(
      result: (json['Result'] as List)
          .map((e) => UpdateTAResult.fromJson(e))
          .toList(),
    );
  }
}

class UpdateTAResult {
  final int statusId;
  final String message;

  UpdateTAResult({
    required this.statusId,
    required this.message,
  });

  factory UpdateTAResult.fromJson(Map<String, dynamic> json) {
    return UpdateTAResult(
      statusId: json['StatusID'] ?? 0,
      message: json['MSG'] ?? '',
    );
  }
}