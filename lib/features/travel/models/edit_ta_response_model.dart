class EditTAResponse {
  final List<EditTAResult> result;
  final List<dynamic> table1;
  final List<dynamic> table2;

  EditTAResponse({
    required this.result,
    required this.table1,
    required this.table2,
  });

  factory EditTAResponse.fromJson(Map<String, dynamic> json) {
    return EditTAResponse(
      result: (json['Result'] as List)
          .map((e) => EditTAResult.fromJson(e))
          .toList(),
      table1: json['Table1'] ?? [],
      table2: json['Table2'] ?? [],
    );
  }
}

class EditTAResult {
  final int trId;
  final int employeeCode;
  final String level;
  final String destination;
  final String location;
  final String departureDate;
  final String returnDate;
  final String modeOfTransportation;
  final int duration;
  final String estimatedKm;
  final String accommodation;
  final String purposeOfTravel;
  final String status;

  // NEW FIELDS
  final String departmentName;
  final int crnNumber;

  EditTAResult({
    required this.trId,
    required this.employeeCode,
    required this.level,
    required this.destination,
    required this.location,
    required this.departureDate,
    required this.returnDate,
    required this.modeOfTransportation,
    required this.duration,
    required this.estimatedKm,
    required this.accommodation,
    required this.purposeOfTravel,
    required this.status,
    required this.departmentName,
    required this.crnNumber,
  });

  factory EditTAResult.fromJson(Map<String, dynamic> json) {
    return EditTAResult(
      trId: json['TR_ID'] ?? 0,
      employeeCode: json['TR_EmployeeCode'] ?? 0,
      level: json['TR_Level'] ?? '',
      destination: json['TR_Destination'] ?? '',
      location: json['TR_Location'] ?? '',
      departureDate: json['TR_Departuredate'] ?? '',
      returnDate: json['TR_ReturnDate'] ?? '',
      modeOfTransportation: json['TR_modeofTransportation'] ?? '',
      duration: json['TR_Duration'] ?? 0,
      estimatedKm: json['TR_EstimatedKm'] ?? '',
      accommodation: json['TR_Accommodation'] ?? '',
      purposeOfTravel: json['TR_PurposeofTravel'] ?? '',
      status: (json['TR_Status'] ?? '').toString().trim(),

      // NEW
      departmentName: json['DepartmentName'] ?? '',
      crnNumber: json['TR_CRNNumber'] ?? 0,
    );
  }
}