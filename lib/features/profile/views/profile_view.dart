import 'package:clams/constants/app_colors.dart';
import 'package:clams/features/profile/provider/LeaveBalance_viewModel.dart';
import 'package:clams/features/profile/widjets/employment_details_card.dart';
import 'package:clams/features/profile/widjets/leave_balance_card.dart';
import 'package:clams/features/profile/widjets/salary_details_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'package:clams/features/Authentication/providers/auth_provider.dart';
import 'package:clams/features/profile/provider/employee_viewModel.dart';
import 'package:clams/features/profile/widjets/profile_header_card.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {

  String _removeTitle(String? name) {
    if (name == null || name.trim().isEmpty) {
      return '';
    }
    return name.replaceFirst(RegExp(r'^(Mr|Mrs|Ms|Miss)\s*', caseSensitive: false),'')
        .replaceAll('.', '').replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  Future<void> _loadProfileData() async {
    await Future.wait([
      context.read<EmployeeViewModel>().loadMyProfile(context),
      context.read<LeaveBalanceProvider>().fetchLeaveBalance(context),
    ]);
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProfileData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<EmployeeViewModel>();
    final leaveProvider = context.watch<LeaveBalanceProvider>();

    if (vm.state == LoadState.loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (vm.state == LoadState.error) {
      return RefreshIndicator(
        color: AppColors.primaryColor,
        onRefresh: _loadProfileData,
        child: Scaffold(
          body: Center(
            child: Text(vm.error ?? "Something went wrong"),
          ),
        ),
      );
    }

    final employee = vm.employee;

    if (employee == null) {
      return RefreshIndicator(
        color: AppColors.primaryColor,
        onRefresh: _loadProfileData,
        child: const Scaffold(
          body: Center(
            child: Text("No employee data found"),
          ),
        ),
      );
    }

    return RefreshIndicator(
      color: AppColors.primaryColor,
      onRefresh: _loadProfileData,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Profile"),
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            bottom: true,
            child: Column(
              children: [

                ProfileHeaderCard(
                  name: _removeTitle(employee.name ?? ''),
                  designation: employee.designation ?? '',
                  employeeCode: employee.employeeCode?.toString() ?? '',
                  department: employee.departmentName ?? '',
                  email: employee.emailId ?? '',
                  mobile: employee.mobile ?? '',
                  image: context.watch<AuthProvider>().profileImageBytes,
                ),

                LeaveBalanceCard(
                  leaveBalances:
                  leaveProvider.leaveBalanceResponse?.data ?? [],
                ),

                EmploymentDetailsCard(
                  designation: employee.designation ?? '',
                  department: employee.departmentName ?? '',
                  location: employee.location ?? '',
                  officePhone: employee.officePhone ?? '',
                  extension: employee.extension ?? '',
                  employmentType: employee.employmentType ?? '',
                  dateOfJoining: employee.dateOfJoining ?? '',
                  reportingTo: _removeTitle(employee.reportingTo1 ?? ''),
                ),

                SalaryDetailsCard(
                  grossSalary: employee.grossSalary,
                  basic: employee.basic,
                  hra: employee.hra,
                  da: employee.da,
                  cityCompensatoryAllowance: employee.cityCompensatoryAllowance,
                  csa: employee.csa,
                  esi: employee.esi,
                  swf: employee.swf,
                ),
                SizedBox(height: 20.h)
              ],
            ),
          ),
        ),
      ),
    );
  }
}