class GetEmpTravelDetailsModel {
  final List<TravelResult> result;
  final List<TravelExtension> extensions;

  GetEmpTravelDetailsModel({
    required this.result,
    required this.extensions,
  });

  factory GetEmpTravelDetailsModel.fromJson(Map<String, dynamic> json) {
    return GetEmpTravelDetailsModel(
      result: (json['Result'] as List<dynamic>)
          .map((e) => TravelResult.fromJson(e))
          .toList(),
      extensions: (json['Table1'] as List<dynamic>)
          .map((e) => TravelExtension.fromJson(e))
          .toList(),
    );
  }
}

class TravelResult {
  final int trId;
  final String employeeName;
  final String designation;
  final int employeeCode;
  final String departmentName;
  final String reportingTo;
  final String rpDesignation;
  final String level;

  final String ccuDepartment;
  final String crnNumber;
  final String extendedCrnNumber;

  final String destination;
  final String departureDate;
  final String returnDate;
  final String appliedDate;
  final String approvedDate;
  final String estimatedKm;
  final String accommodation;
  final String modeOfTransportation;
  final String purpose;
  final String location;
  final int duration;
  final String status;

  TravelResult({
    required this.trId,
    required this.employeeName,
    required this.designation,
    required this.employeeCode,
    required this.departmentName,
    required this.reportingTo,
    required this.rpDesignation,
    required this.level,
    required this.ccuDepartment,
    required this.crnNumber,
    required this.extendedCrnNumber,
    required this.destination,
    required this.departureDate,
    required this.returnDate,
    required this.appliedDate,
    required this.approvedDate,
    required this.estimatedKm,
    required this.accommodation,
    required this.modeOfTransportation,
    required this.purpose,
    required this.location,
    required this.duration,
    required this.status,
  });

  factory TravelResult.fromJson(Map<String, dynamic> json) {
    return TravelResult(
      trId: json['TR_ID'] ?? 0,
      employeeName: json['EmployeeName'] ?? '',
      designation: json['Designation'] ?? '',
      employeeCode: json['TR_EmployeeCode'] ?? 0,
      departmentName: json['DepartmentName'] ?? '',
      reportingTo: json['ReportingTo'] ?? '',
      rpDesignation: json['RpDesignation'] ?? '',
      level: json['TR_Level'] ?? '',

      ccuDepartment: json['CCU_Department'] ?? '',
      crnNumber: json['TR_CRNNumber'] ?? '',
      extendedCrnNumber: json['TR_ExtendedCRNNo'] ?? '',

      destination: json['TR_Destination'] ?? '',
      departureDate: json['TR_Departuredate'] ?? '',
      returnDate: json['TR_ReturnDate'] ?? '',
      appliedDate: json['Applieddatedt'] ?? '',
      approvedDate: json['ApprovedDate'] ?? '',
      estimatedKm: json['TR_EstimatedKm']?.toString() ?? '',
      accommodation: json['TR_Accommodation'] ?? '',
      modeOfTransportation: json['TR_modeofTransportation'] ?? '',
      purpose: json['TR_PurposeofTravel'] ?? '',
      location: json['TR_Location'] ?? '',
      duration: json['TR_Duration'] ?? 0,
      status: (json['TR_Status'] ?? '').toString().trim(),
    );
  }
}

class TravelExtension {
  final int trdId;
  final int trId;
  final int employeeCode;
  final String reason;
  final int extendedDays;
  final String extendedDate;
  final int status;
  final String createdDate;

  TravelExtension({
    required this.trdId,
    required this.trId,
    required this.employeeCode,
    required this.reason,
    required this.extendedDays,
    required this.extendedDate,
    required this.status,
    required this.createdDate,
  });

  factory TravelExtension.fromJson(Map<String, dynamic> json) {
    return TravelExtension(
      trdId: json['TRD_ID'] ?? 0,
      trId: json['TRD_TR_ID'] ?? 0,
      employeeCode: json['TRD_EmployeeCode'] ?? 0,
      reason: json['TRD_Extended_Reason'] ?? '',
      extendedDays: json['TRD_Extendeddays'] ?? 0,
      extendedDate: json['TRD_Extendeddate'] ?? '',
      status: json['TRD_Status'] ?? 0,
      createdDate: json['TRD_CreatedDate'] ?? '',
    );
  }
}