import 'package:clams/features/Authentication/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_styles.dart';
import '../services/travel_pdf_service.dart';
import '../viewModels/get_emp_travel_details_view_model.dart';

class TravelDetailsPage extends StatefulWidget {
  final String travelId;

  const TravelDetailsPage({super.key, required this.travelId});

  @override
  State<TravelDetailsPage> createState() => _TravelDetailsPageState();
}

class _TravelDetailsPageState extends State<TravelDetailsPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final auth = context.read<AuthProvider>();
      final employeeCode =
          auth.userData?.employeeCode.toString() ?? '';

      context.read<GetEmpTravelDetailsViewModel>().fetchTravelDetails(
        travelId: widget.travelId,
        employeeCode: employeeCode,
      );
    });
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_showFab) {
          setState(() => _showFab = false);
        }
      } else if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (!_showFab) {
          setState(() => _showFab = true);
        }
      }
    });
  }

  bool _showFab = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColors.scaffoldBackground,
      floatingActionButton: _showFab
          ? Padding(
              padding: EdgeInsets.only(bottom: 17.h),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: _showFab ? 1 : 0,
                child: FloatingActionButton.extended(
                  backgroundColor: AppColors.primaryColor,
                  onPressed: () {
                    final vm = context.read<GetEmpTravelDetailsViewModel>();
                    final auth = context.read<AuthProvider>();

                    if (vm.travel != null) {
                      TravelPdfService.openPdf(
                        vm.travel!,
                        vm.extensions,
                        context,
                        auth.loginData?.data.first.employeeName ?? "Unknown",
                      );
                    }
                  },
                  icon: Icon(Icons.download, color: Colors.white),
                  label: Text("PDF", style: TextStyle(color: Colors.white)),
                ),
              ),
            )
          : null,
      appBar: AppBar(
        title: Text("Travel Details", style: AppStyles.heading2),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.black,
        elevation: 0,
      ),
      body: Consumer<GetEmpTravelDetailsViewModel>(
        builder: (_, vm, __) {
          /// AUTO FETCH
          if (!vm.isLoading && vm.travel == null && vm.error == null) {
            final auth = context.read<AuthProvider>();
            final employeeCode =
                auth.userData?.employeeCode.toString() ?? '';

            vm.fetchTravelDetails(
              travelId: widget.travelId,
              employeeCode: employeeCode,
            );
          }

          if (vm.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (vm.error != null) {
            return Center(child: Text(vm.error!, style: AppStyles.heading3));
          }

          if (!vm.hasData) {
            return Center(child: Text("No Data", style: AppStyles.heading3));
          }

          final data = vm.travel!;

          return RefreshIndicator(
            color: AppColors.primaryColor,
            onRefresh: () async {
              final auth = context.read<AuthProvider>();
              final employeeCode =
                  auth.userData?.employeeCode.toString() ?? '';

              await vm.fetchTravelDetails(
                travelId: widget.travelId,
                employeeCode: employeeCode,
              );
            },
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: EdgeInsets.all(16.w),
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColors.textColor,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.textColor,
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// TITLE
                      Center(
                        child: Text(
                          "EMPLOYEE TRAVEL REQUISITION",
                          style: AppStyles.heading2,
                        ),
                      ),

                      SizedBox(height: 16.h),

                      /// INFO GRID
                      _infoRow(
                        "Name",
                        data.employeeName,
                        "Designation",
                        data.designation,
                      ),

                      _infoRow(
                        "Employee Code",
                        data.employeeCode.toString(),
                        "Department",
                        data.departmentName,
                      ),

                      _infoRow(
                        "CCU Department",
                        data.ccuDepartment,
                        "Level",
                        data.level,
                      ),

                      _infoRow(
                        "Reporting To",
                        data.reportingTo,
                        "Designation",
                        data.rpDesignation,
                      ),

                      _infoRow(
                        "Destination",
                        data.destination,
                        "Status",
                        data.status,
                      ),

                      SizedBox(height: 16.h),

                      /// CRN DETAILS
                      _detailRow("CRN Number", data.crnNumber),

                      if (data.extendedCrnNumber.isNotEmpty)
                        _detailRow("Extended CRN", data.extendedCrnNumber),

                      SizedBox(height: 16.h),

                      /// LOCATION
                      Text(
                        "Travel Location",
                        style: AppStyles.heading2,
                      ),
                      SizedBox(height: 6.h),

                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: AppColors.textColor,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          data.location,
                          style: AppStyles.heading3,
                        ),
                      ),

                      SizedBox(height: 16.h),

                      /// PURPOSE
                      Text(
                        "Purpose of Travel",
                        style: AppStyles.heading2,
                      ),
                      SizedBox(height: 6.h),

                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: AppColors.textColor,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          data.purpose,
                          style: AppStyles.heading3,
                        ),
                      ),

                      SizedBox(height: 16.h),

                      /// TRAVEL DETAILS
                      _detailRow("Departure Date", data.departureDate),
                      _detailRow("Return Date", data.returnDate),
                      _detailRow("Applied Date", data.appliedDate),
                      // _detailRow("Approved Date", data.approvedDate),
                      _detailRow("Mode of Transport", data.modeOfTransportation),
                      _detailRow("Accommodation", data.accommodation),
                      _detailRow("Estimated KM", data.estimatedKm),
                      _detailRow("Duration", "${data.duration} Days"),

                      SizedBox(height: 20.h),

                      /// APPROVER
                      Text(
                        "Approved By",
                        style: AppStyles.heading2,
                      ),
                      SizedBox(height: 8.h),

                      Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.reportingTo,
                              style: AppStyles.heading3,
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              data.rpDesignation,
                              style: AppStyles.heading3,
                            ),
                          ],
                        ),
                      ),

                      /// EXTENSIONS
                      if (vm.hasExtension) ...[
                        SizedBox(height: 20.h),

                        Text(
                          "Travel Extensions",
                          style: AppStyles.heading2,
                        ),

                        SizedBox(height: 10.h),

                        ...vm.extensions.map((e) {
                          return Container(
                            margin: EdgeInsets.only(bottom: 10.h),
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _detailRow("Reason", e.reason),
                                _detailRow("Extended Days", e.extendedDays.toString()),
                                _detailRow("Extended Date", e.extendedDate),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// ---------------- COMPONENTS ----------------

  Widget _infoRow(String l1, String v1, String l2, String v2) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _tile(l1, v1)),
          SizedBox(width: 8.w),
          Expanded(child: _tile(l2, v2)),
        ],
      ),
    );
  }

  Widget _tile(String label, String value) {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.textColor),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppStyles.heading2),
          SizedBox(height: 4.h),
          Text(value, style: AppStyles.heading2),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Container(
      margin: EdgeInsets.only(bottom: 6.h),
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.textColor),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          Expanded(child: Text(label, style: AppStyles.heading2)),
          Expanded(child: Text(value, style: AppStyles.heading2)),
        ],
      ),
    );
  }
}
