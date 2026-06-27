class DepartmentResponse {
  final List<DepartmentData> result;

  DepartmentResponse({
    required this.result,
  });

  factory DepartmentResponse.fromJson(Map<String, dynamic> json) {
    return DepartmentResponse(
      result: (json['Result'] as List? ?? [])
          .map((e) => DepartmentData.fromJson(e))
          .toList(),
    );
  }
}

class DepartmentData {
  final int departmentId;
  final String departmentName;

  DepartmentData({
    required this.departmentId,
    required this.departmentName,
  });

  factory DepartmentData.fromJson(Map<String, dynamic> json) {
    return DepartmentData(
      departmentId: json['DepartmentId'] ?? 0,
      departmentName: json['DepartmentName']?.toString().trim() ?? '',
    );
  }

  @override
  String toString() => departmentName;

  /// Useful if used in Dropdowns
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is DepartmentData &&
              departmentId == other.departmentId;

  @override
  int get hashCode => departmentId.hashCode;
}
