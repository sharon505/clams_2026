class LoginResponseModel {
  final List<Result> result;
  final List<EmployeeData> data;
  final List<CompanyData> company;

  LoginResponseModel({
    required this.result,
    required this.data,
    required this.company,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      result: (json['Result'] as List<dynamic>? ?? [])
          .map((item) => Result.fromJson(item))
          .toList(),
      data: (json['Data'] as List<dynamic>? ?? [])
          .map((item) => EmployeeData.fromJson(item))
          .toList(),
      company: (json['Company'] as List<dynamic>? ?? [])
          .map((item) => CompanyData.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Result': result.map((e) => e.toJson()).toList(),
      'Data': data.map((e) => e.toJson()).toList(),
      'Company': company.map((e) => e.toJson()).toList(),
    };
  }
}

class Result {
  final int statusId;
  final String msg;

  Result({
    required this.statusId,
    required this.msg,
  });

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      statusId: json['STATUSID'] is int
          ? json['STATUSID']
          : int.tryParse(json['STATUSID'].toString()) ?? 0,
      msg: json['MSG']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'STATUSID': statusId,
      'MSG': msg,
    };
  }
}

class EmployeeData {
  final int employeeCode;
  final String employeeName;
  final String departmentName;
  final String designation;
  final String location;
  final String reportingName;
  final bool isReportingManager;

  final String attMrIn;
  final String attMrOut;
  final String attEvLimit;

  final String? fileName;
  final String? fileContent;
  final String? fileExtension;

  final String emailId;
  final String mobile;

  EmployeeData({
    required this.employeeCode,
    required this.employeeName,
    required this.departmentName,
    required this.designation,
    required this.location,
    required this.reportingName,
    required this.isReportingManager,
    required this.attMrIn,
    required this.attMrOut,
    required this.attEvLimit,
    this.fileName,
    this.fileContent,
    this.fileExtension,
    required this.emailId,
    required this.mobile,
  });

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }

  static String? _toStr(dynamic value) {
    if (value == null) return null;
    return value.toString().trim();
  }

  static bool _toBool(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    return value.toString().toLowerCase() == 'true';
  }

  factory EmployeeData.fromJson(Map<String, dynamic> json) {
    return EmployeeData(
      employeeCode: _toInt(json['EmployeeCode']),
      employeeName: json['EmployeeName']?.toString() ?? '',
      departmentName: json['DepartmentName']?.toString() ?? '',
      designation: json['Designation']?.toString() ?? '',
      location: json['Location']?.toString() ?? '',
      reportingName: json['ReportingName']?.toString() ?? '',
      isReportingManager: _toBool(json['IsReportingManager']),
      attMrIn: json['AttMrIn']?.toString() ?? '',
      attMrOut: json['AttMrOut']?.toString() ?? '',
      attEvLimit: json['AttEvLimit']?.toString() ?? '',
      fileName: _toStr(json['File_Name']),
      fileContent: _toStr(json['File_Content']),
      fileExtension: _toStr(json['File_Extention']),
      emailId: json['EmailId']?.toString() ?? '',
      mobile: json['Mobile']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'EmployeeCode': employeeCode,
      'EmployeeName': employeeName,
      'DepartmentName': departmentName,
      'Designation': designation,
      'Location': location,
      'ReportingName': reportingName,
      'IsReportingManager': isReportingManager,
      'AttMrIn': attMrIn,
      'AttMrOut': attMrOut,
      'AttEvLimit': attEvLimit,
      'File_Name': fileName,
      'File_Content': fileContent,
      'File_Extention': fileExtension,
      'EmailId': emailId,
      'Mobile': mobile,
    };
  }
}

class CompanyData {
  final String companyName;

  CompanyData({
    required this.companyName,
  });

  factory CompanyData.fromJson(Map<String, dynamic> json) {
    return CompanyData(
      companyName: json['CompanyName']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CompanyName': companyName,
    };
  }
}