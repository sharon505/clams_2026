class AppUrls {

  static const String companyName   = 'all';


  static const String version = "1.0.11+12";

  static const String currentVersion = version;

  static const Map<String, String> header = {
    'Content-Type': 'application/x-www-form-urlencoded',
  };

  /// Base URL
  // static const String baseUrl =
  //     "https://clamsapi.ciinfos.com:56235/CRMSIntegration.asmx";

  /// Test URL
  static const String baseUrl =
      "https://clamsapiuat.ciinfos.com:25456/CRMSIntegration.asmx/";


  static Uri _u(String path) =>  Uri.parse('$baseUrl/$path');

  /// AUTH
  static Uri get login =>                            _u("LoginCheck");

  /// Add profile pic
  static Uri get imageUpload =>                      _u("IMAGE_UPLOAD");

  ///Approvals
  static Uri get approveLeaveStatusHod =>            _u("ApproveLeaveStatusHod");

  static Uri get approveMovement =>                  _u("ApproveMovement");

  static Uri get approvedTravelRequisition =>        _u("ApprovedTravelRequisition");

  static Uri get overtimeApprove =>                  _u("Overtime_Approve");

  static Uri get approveEmployeeTravelRequisition => _u("ApproveEmployeeTravelRequisition");

  static Uri get leaveApprovalList =>                _u("LeaveApprovalList");

  static Uri get movementApprovalList =>             _u("MovementApprovalList");

  static Uri get overtimeApprovalList =>             _u("Overtime_ApprovalList");

  ///HomePage
  static Uri get leaveBalanceData =>                 _u("LeaveBalanceData");

  static Uri get punchingDetails =>                  _u("PunchingDetails");

  ///Leaves
  static Uri get cancelEmployeeLeave =>              _u("CancelEmployeeLeave");

  static Uri get leaveType =>                        _u("LeaveType");

  static Uri get applyLeave =>                       _u("ApplyLeave");

  static Uri get myLeaveSummary =>                   _u("MyLeaveSummary");

  ///Movement
  static Uri get applyMovement =>                    _u("ApplyMovement");

  static Uri get cancelEmployeeMovement =>           _u("CancelEmployeeMovement");

  static Uri get getMovementReport =>                _u("GetMovement_Report");

  ///OverTime
  static Uri get applyOvertime =>                    _u("ApplyOvertime");

  static Uri get getOvertimeReport =>                _u("GetOvertime_Report");

  ///Profile
  static Uri get getEmployeeDetails =>               _u("GetEmployee_Details");

  ///punching
  static Uri get employeeWorkingDuration =>          _u("EmployeeWorkingDuration");

  static Uri get myAttendance =>                     _u("MyAttendance");

  static Uri get getMobilePunchingData =>            _u("GetMobilePunchingData");

  ///Team
  static Uri get getTeamDetails =>                   _u("GetTeam_Details");

  ///Travel
  static Uri get applyTravelRequisition =>           _u("ApplyTravelrequisition");

  static Uri get cancelEmployeeTravelRequest =>      _u("CancelEmployee_TravelRequest");

  static Uri get ccuDepartment =>                    _u("CCUDepartment");

  static Uri get myTravelRequisition =>              _u("MyTravelRequisition");

  static Uri get getEmpTravelDetails =>              _u("Get_EmpTravelDetails");

  ///todo new added
  static Uri get getTravelEmpDetails =>              _u("Get_TravelEmpDetails");

  static Uri get getTADetails =>                     _u("Get_TADetails");

  static Uri get updateTARequest =>                  _u("Update_TARequest");

  static Uri get editTARequest =>                    _u("Edit_TARequest");

  static Uri get editTARequestSave =>                _u("Edit_TARequestSave");

  ///cancel
  static Uri get cancelTARequest =>                  _u("Cancel_TARequest");

  ///salary
  static Uri get getSalaryBankDetails =>             _u("Get_SalaryBankDetails");

  static Uri get getSalarySlip =>                    _u("Get_Salaryslip");

  /// ccu work registration-----------------------------------------------------

  static Uri get ccuCategory           =>           _u("GET_CCUCATEGORY");

  static Uri get ccuWorkRegistration   =>           _u("CCU_Work_Register");

  static Uri get ccuCompany            =>           _u("GET_CCUCOMPANY");

  static Uri get ccuEmployeeNames      =>           _u("GET_CCU_EMPLOYEENAMES");

  static Uri get ccuRegistrationDetails =>          _u("GET_CCU_REGISTRATION_DETAILS");

  static Uri get ccuRegistrationStatus  =>          _u("GET_CCU_REGISTRATION_STATUS");

}
