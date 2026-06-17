class Employee {
  final int? employeeCode;
  final String? name;
  final String? gender;
  final String? dateOfJoining;
  final int? employmentTypeId;
  final String? employmentType;
  final String? photo;
  final String? employeeCode1;
  final String? emailId;
  final String? officePhone;
  final String? extension;
  final String? mobile;
  final int? departmentId;
  final int? designationId;
  final String? reportingTo;
  final String? location;
  final String? designation;
  final String? departmentName;
  final double? basic;
  final double? cityCompensatoryAllowance;
  final double? da;
  final bool? esi;
  final double? grossSalary;
  final double? hra;
  final double? specialAllowance;
  final bool? swf;
  final String? bankName;
  final String? accountNumber;
  final String? benificiaryName;
  final String? drivingLicence;
  final String? licenseValidTill;
  final String? esiNumber;
  final String? insuranceProvider;
  final String? pfNumber;
  final String? panNumber;
  final String? policyNumber;
  final String? uanNumber;
  final String? reportingTo1;

  // Allowances
  final double? conveyanceAllowance;
  final double? uniformAllowance;
  final double? educationalAllowance;
  final double? hostelAllowance;
  final double? washingAllowance;
  final double? csa;

  Employee({
    this.employeeCode,
    this.name,
    this.gender,
    this.dateOfJoining,
    this.employmentTypeId,
    this.employmentType,
    this.photo,
    this.employeeCode1,
    this.emailId,
    this.officePhone,
    this.extension,
    this.mobile,
    this.departmentId,
    this.designationId,
    this.reportingTo,
    this.location,
    this.designation,
    this.departmentName,
    this.basic,
    this.cityCompensatoryAllowance,
    this.da,
    this.esi,
    this.grossSalary,
    this.hra,
    this.specialAllowance,
    this.swf,
    this.bankName,
    this.accountNumber,
    this.benificiaryName,
    this.drivingLicence,
    this.licenseValidTill,
    this.esiNumber,
    this.insuranceProvider,
    this.pfNumber,
    this.panNumber,
    this.policyNumber,
    this.uanNumber,
    this.reportingTo1,
    this.conveyanceAllowance,
    this.uniformAllowance,
    this.educationalAllowance,
    this.hostelAllowance,
    this.washingAllowance,
    this.csa,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      employeeCode: json['EmployeeCode'],
      name: json['Name'],
      gender: json['Gender'],
      dateOfJoining: json['DateOfJoining'],
      employmentTypeId: json['EmploymentTypeId'],
      employmentType: json['EmploymentType'],
      photo: json['Photo'],
      employeeCode1: json['EmployeeCode1'],
      emailId: json['EmailId'],
      officePhone: json['OfficePhone'],
      extension: json['Extension'],
      mobile: json['Mobile'],
      departmentId: json['DepartmentId'],
      designationId: json['DesignationId'],
      reportingTo: json['ReportingTo'],
      location: json['Location'],
      designation: json['Designation'],
      departmentName: json['DepartmentName'],
      basic: (json['Basic'] as num?)?.toDouble(),
      cityCompensatoryAllowance: (json['CityCompensatoryAllowance'] as num?)?.toDouble(),
      da: (json['DA'] as num?)?.toDouble(),
      esi: json['ESI'],
      grossSalary: (json['GrossSalary'] as num?)?.toDouble(),
      hra: (json['HRA'] as num?)?.toDouble(),
      specialAllowance: (json['SpecialAllowance'] as num?)?.toDouble(),
      swf: json['SWF'],
      bankName: json['BankName'],
      accountNumber: json['AccountNumber'],
      benificiaryName: json['BenificiaryName'],
      drivingLicence: json['DrivingLicence'],
      licenseValidTill: json['LicenseValidTill'],
      esiNumber: json['ESINumber'],
      insuranceProvider: json['InsuranceProvider'],
      pfNumber: json['PFNumber'],
      panNumber: json['PanNumber'],
      policyNumber: json['PolicyNumber'],
      uanNumber: json['UANNumber'],
      reportingTo1: json['ReportingTo1'],
      conveyanceAllowance: (json['ConveyanceAllowance'] as num?)?.toDouble(),
      uniformAllowance: (json['UniformAllowance'] as num?)?.toDouble(),
      educationalAllowance: (json['EducationalAllowance'] as num?)?.toDouble(),
      hostelAllowance: (json['HostelAllowance'] as num?)?.toDouble(),
      washingAllowance: (json['WashingAllowance'] as num?)?.toDouble(),
      csa: (json['CSA'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'EmployeeCode': employeeCode,
      'Name': name,
      'Gender': gender,
      'DateOfJoining': dateOfJoining,
      'EmploymentTypeId': employmentTypeId,
      'EmploymentType': employmentType,
      'Photo': photo,
      'EmployeeCode1': employeeCode1,
      'EmailId': emailId,
      'OfficePhone': officePhone,
      'Extension': extension,
      'Mobile': mobile,
      'DepartmentId': departmentId,
      'DesignationId': designationId,
      'ReportingTo': reportingTo,
      'Location': location,
      'Designation': designation,
      'DepartmentName': departmentName,
      'Basic': basic,
      'CityCompensatoryAllowance': cityCompensatoryAllowance,
      'DA': da,
      'ESI': esi,
      'GrossSalary': grossSalary,
      'HRA': hra,
      'SpecialAllowance': specialAllowance,
      'SWF': swf,
      'BankName': bankName,
      'AccountNumber': accountNumber,
      'BenificiaryName': benificiaryName,
      'DrivingLicence': drivingLicence,
      'LicenseValidTill': licenseValidTill,
      'ESINumber': esiNumber,
      'InsuranceProvider': insuranceProvider,
      'PFNumber': pfNumber,
      'PanNumber': panNumber,
      'PolicyNumber': policyNumber,
      'UANNumber': uanNumber,
      'ReportingTo1': reportingTo1,
      'ConveyanceAllowance': conveyanceAllowance,
      'UniformAllowance': uniformAllowance,
      'EducationalAllowance': educationalAllowance,
      'HostelAllowance': hostelAllowance,
      'WashingAllowance': washingAllowance,
      'CSA': csa,
    };
  }
}
