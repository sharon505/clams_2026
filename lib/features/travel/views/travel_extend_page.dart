import 'package:clams/features/Authentication/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_styles.dart';
import '../viewModels/travel_emp_details_view_model.dart';
import '../viewModels/ta_details_view_model.dart';
import '../viewModels/update_TA_view_model.dart';

class TravelExtendPage extends StatefulWidget {
  final String travelId;

  const TravelExtendPage({super.key, required this.travelId});

  @override
  State<TravelExtendPage> createState() => _TravelExtendPageState();
}

class _TravelExtendPageState extends State<TravelExtendPage> {

  final daysController = TextEditingController();
  final reasonController = TextEditingController();
  final dateController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthProvider>();
      final employeeCode =
          auth.userData?.employeeCode.toString() ?? '';

      context.read<TravelEmpDetailsViewModel>().fetchWithAuth(context);

      context.read<TADetailsViewModel>().fetch(
        travelId: widget.travelId,
        employeeCode: employeeCode,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        // backgroundColor: AppColors.primary,
        elevation: 0,
        title: Text(
          "Extend Travel",
          // style: AppStyles.heading2.copyWith(color: Colors.black),
        ),
        centerTitle: true,
      ),

      body: Consumer3<TravelEmpDetailsViewModel, TADetailsViewModel,UpdateTAViewModel>(
        builder: (_, empVM, taVM,updateVM, __) {

          /// LOADING
          if (empVM.isLoading || taVM.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          /// ERROR
          if (empVM.error != null || taVM.error != null) {
            return Center(child: Text(empVM.error ?? taVM.error!));
          }

          /// EMPTY
          if (!empVM.hasData || !taVM.hasData) {
            return const Center(child: Text("No Data"));
          }

          final emp = empVM.employees.first;
          final ta = taVM.firstTA!;

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [

                /// 👤 EMPLOYEE DETAILS
                _card(
                  "Employee Details",
                  Column(
                    children: [
                      _tile("Name", emp.employeeName),
                      _tile("Employee Code", emp.employeeCode.toString()),
                      _tile("Designation", emp.designation),
                      _tile("Department", emp.departmentName),
                      _tile("Reporting Manager", emp.reportingName),
                    ],
                  ),
                ),

                SizedBox(height: 16.h),

                /// ✈ TRAVEL DETAILS
                _card(
                  "Travel Details",
                  Column(
                    children: [
                      _tile("Destination", ta.trDestination),
                      _tile("Location", ta.trLocation),
                      _tile("Purpose", ta.trPurposeOfTravel),
                      _tile("Departure", _formatDate(ta.trDepartureDate)),
                      _tile("Return", _formatDate(ta.trReturnDate)),
                      _tile("Transport", ta.trModeOfTransportation),
                      _tile("Duration", "${ta.trDuration} Days"),
                      _tile("KM", ta.trEstimatedKm),
                      _tile("Accommodation", ta.trAccommodation),
                    ],
                  ),
                ),

                SizedBox(height: 16.h),

                /// 📝 EXTENSION FORM
                _card(
                  "Extension Details",
                  Column(
                    children: [
                      /// EXTENDED DATE
                      _input(
                        controller: dateController,
                        hint: "Extended Date",
                        readOnly: true,
                        icon: Icons.calendar_today,
                        onTap: () async {

                          final picked = await showDatePicker(
                            context: context,
                            initialDate: ta.trReturnDate,
                            firstDate: ta.trReturnDate,
                            lastDate: DateTime(2100),
                          );

                          if (picked != null) {

                            /// ❗ VALIDATION
                            final diff =
                                picked.difference(ta.trReturnDate).inDays;

                            if (diff <= 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      "Select date after return date"),
                                ),
                              );
                              return;
                            }

                            /// SET DATE
                            dateController.text =
                            "${picked.year}/${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}";

                            /// AUTO CALCULATE DAYS
                            daysController.text = diff.toString();
                          }
                        },
                      ),

                      SizedBox(height: 10.h),

                      _input(
                        controller: daysController,
                        hint: "Extended Days",
                        readOnly: true,
                      ),

                      SizedBox(height: 10.h),

                      /// REASON
                      _input(
                        controller: reasonController,
                        hint: "Reason",
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 24.h),

                /// 🔘 BUTTON
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    // style: AppStyles.elevatedButtonStyle,
                    onPressed: updateVM.isSubmitting
                        ? null
                        : () async {
                      if (dateController.text.isEmpty ||
                          daysController.text.isEmpty ||
                          reasonController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Fill all fields")),
                        );
                        return;
                      }



                      final success = await updateVM.submit(
                        employeeCode: emp.employeeCode.toString(),
                        travelId: widget.travelId,
                        reason: reasonController.text,
                        extendedDays: daysController.text,
                        extendedDate: dateController.text,
                      );

                      if (!context.mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(updateVM.message)),
                      );

                      if (success) {
                        Navigator.pop(context); // go back after success
                      }
                    },
                    child: const Text("UPDATE"),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// ---------------- UI ----------------

  Widget _card(String title, Widget child) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.textColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.textColor,
            blurRadius: 10,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppStyles.heading2),
          SizedBox(height: 10.h),
          child,
        ],
      ),
    );
  }

  Widget _tile(String label, String value) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.textColor),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          Expanded(child: Text(label, style: AppStyles.heading3)),
          Expanded(child: Text(value, style: AppStyles.heading3)),
        ],
      ),
    );
  }

  Widget _input({
    required TextEditingController controller,
    required String hint,
    bool readOnly = false,
    int maxLines = 1,
    IconData? icon,
    VoidCallback? onTap,
    TextInputType? keyboard,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      maxLines: maxLines,
      keyboardType: keyboard,
      onTap: onTap,
      decoration: InputDecoration(
        hintText: hint,
        suffixIcon: icon != null ? Icon(icon) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}-${date.month}-${date.year}";
  }
}