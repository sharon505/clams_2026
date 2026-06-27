class TravelEmpDetailsModel {
  final List<EmployeeResult> result;

  TravelEmpDetailsModel({
    required this.result,
  });

  factory TravelEmpDetailsModel.fromJson(Map<String, dynamic> json) {
    return TravelEmpDetailsModel(
      result: (json['Result'] as List)
          .map((e) => EmployeeResult.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Result': result.map((e) => e.toJson()).toList(),
    };
  }
}

class EmployeeResult {
  final int employeeCode;
  final String employeeName;
  final String branchCode;
  final String location;
  final String departmentName;
  final String designation;
  final String employmentType;
  final int reportingTo;
  final String reportingName;
  final String status;
  final double grossSalary;
  final String password;
  final DateTime dateOfJoining;
  final int branchId;
  final int motherBranchId;

  EmployeeResult({
    required this.employeeCode,
    required this.employeeName,
    required this.branchCode,
    required this.location,
    required this.departmentName,
    required this.designation,
    required this.employmentType,
    required this.reportingTo,
    required this.reportingName,
    required this.status,
    required this.grossSalary,
    required this.password,
    required this.dateOfJoining,
    required this.branchId,
    required this.motherBranchId,
  });

  factory EmployeeResult.fromJson(Map<String, dynamic> json) {
    return EmployeeResult(
      employeeCode: json['EmployeeCode'],
      employeeName: json['EmployeeName'],
      branchCode: json['BranchCode'],
      location: json['Location'],
      departmentName: json['DepartmentName'],
      designation: json['Designation'],
      employmentType: json['EmploymentType'],
      reportingTo: json['ReportingTo'],
      reportingName: json['ReportingName'],
      status: json['Status'],
      grossSalary: (json['GrossSalary'] as num).toDouble(),
      password: json['Password'],
      dateOfJoining: DateTime.parse(json['DateOfJoining']),
      branchId: json['Branchid'],
      motherBranchId: json['MotherBranchID'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'EmployeeCode': employeeCode,
      'EmployeeName': employeeName,
      'BranchCode': branchCode,
      'Location': location,
      'DepartmentName': departmentName,
      'Designation': designation,
      'EmploymentType': employmentType,
      'ReportingTo': reportingTo,
      'ReportingName': reportingName,
      'Status': status,
      'GrossSalary': grossSalary,
      'Password': password,
      'DateOfJoining': dateOfJoining.toIso8601String(),
      'Branchid': branchId,
      'MotherBranchID': motherBranchId,
    };
  }
}