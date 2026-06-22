class MovementReportResponse {
  final List<MovementReportItem> result;

  MovementReportResponse({required this.result});

  factory MovementReportResponse.fromJson(Map<String, dynamic> json) {
    final list = (json['Result'] as List<dynamic>? ?? [])
        .map((e) => MovementReportItem.fromJson(e as Map<String, dynamic>))
        .toList();
    return MovementReportResponse(result: list);
  }

  Map<String, dynamic> toJson() {
    return {
      'Result': result.map((e) => e.toJson()).toList(),
    };
  }
}

class MovementReportItem {
  final int id;
  final String fromDate;
  final String toDate;
  final String appliedTo;
  final String status;
  final String description;

  MovementReportItem({
    required this.id,
    required this.fromDate,
    required this.toDate,
    required this.appliedTo,
    required this.status,
    required this.description,
  });

  factory MovementReportItem.fromJson(Map<String, dynamic> json) {
    return MovementReportItem(
      id: json['Id'] as int,
      fromDate: json['FromDate'] as String? ?? '',
      toDate: json['ToDate'] as String? ?? '',
      appliedTo: json['AppliedTo'] as String? ?? '',
      status: json['Status'] as String? ?? '',
      description: json['Description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'FromDate': fromDate,
      'ToDate': toDate,
      'AppliedTo': appliedTo,
      'Status': status,
      'Description': description,
    };
  }
}
