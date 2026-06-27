import 'package:clams/constants/app_colors.dart';
import 'package:clams/constants/app_dialog.dart';
import 'package:clams/constants/app_padding.dart';
import 'package:clams/constants/app_radius.dart';
import 'package:clams/constants/app_textfield.dart';
import 'package:clams/features/Authentication/providers/auth_provider.dart';
import 'package:clams/features/profile/provider/employee_viewModel.dart';
import 'package:clams/features/travel/widgets/app_segmented_toggle.dart';
import 'package:clams/network/app_url.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../services/ApplyTravel_service.dart';
import '../viewModels/apply_travel_requisition_viewModel.dart';
import '../viewModels/ccu_department_view_model.dart';
import '../viewModels/edit_ta_view_model.dart';
import '../viewModels/travel_requisition_textfield_view_model.dart';

class ApplyTravelView extends StatefulWidget {
  final String? travelId;

  const ApplyTravelView({super.key, this.travelId});

  @override
  State<ApplyTravelView> createState() => _ApplyTravelViewState();
}

class _ApplyTravelViewState extends State<ApplyTravelView> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadInitial();
    });
  }

  String _formatDate(String date) {
    try {
      final parsed = DateTime.parse(date);
      return DateFormat("dd/MM/yyyy").format(parsed);
    } catch (_) {
      return date;
    }
  }

  Future<void> _loadInitial() async {
    final employeeVm = context.read<EmployeeViewModel>();
    final ccuVm = context.read<CCUDepartmentViewModel>();
    final editVm = context.read<EditTAViewModel>();
    final loVm = context.read<AuthProvider>();

    await employeeVm.loadMyProfile(context);

    final employeeCode = loVm.loginData?.data.first.employeeCode ?? 0;

    if (employeeCode > 0) {
      await ccuVm.fetchDepartments(
        context: context,
        employeeCode: employeeCode.toString(),
      );
    }

    String mapDestination(dynamic value) {
      final v = value.toString().toLowerCase().trim();
      return (v == "0" || v == "domestic")
          ? "Domestic"
          : "International";
    }

    /// EDIT MODE AUTO FILL
    if (widget.travelId != null) {
      final ok = await editVm.fetch(
        travelId: widget.travelId!,
        employeeCode: employeeCode.toString(),
      );

      if (ok) {
        final data = editVm.data;
        if (data == null) return;

        final atVm = context.read<TravelRequisitionTextFieldViewModel>();

        // Dropdown values
        atVm.selectedLevel = data.level;
        atVm.selectedDestination = mapDestination(data.destination);

        // CCU Department autofill
        if (data.departmentName.isNotEmpty &&
            ccuVm.departments.isNotEmpty) {
          try {
            final selectedDept = ccuVm.departments.firstWhere(
                  (e) =>
              e.departmentName.trim().toLowerCase() ==
                  data.departmentName.trim().toLowerCase(),
            );

            ccuVm.setSelectedDepartment(selectedDept);
          } catch (e) {
            debugPrint("Department not found");
          }
        }
        // Text fields
        atVm.travelLocationController.text = data.location;
        atVm.departureDateController.text =
            _formatDate(data.departureDate);
        atVm.returnDateController.text =
            _formatDate(data.returnDate);
        atVm.modeOfTransportationController.text =
            data.modeOfTransportation;
        atVm.durationController.text =
            data.duration.toString();
        atVm.estimatedKmController.text =
            data.estimatedKm;
        atVm.accommodationController.text =
            data.accommodation;
        atVm.purposeOfTravelController.text =
            data.purposeOfTravel;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final atVm = context.watch<TravelRequisitionTextFieldViewModel>();
    final applyVm = context.watch<ApplyTravelRequisitionViewModel>();
    final loVm = context.watch<AuthProvider>();
    final ccuVm = context.watch<CCUDepartmentViewModel>();

    String reverseDate(String date) {
      try {
        final parsed = DateFormat("dd/MM/yyyy").parse(date);
        return DateFormat("yyyy/MM/dd").format(parsed);
      } catch (_) {
        return date;
      }
    }

    void showToast(
        String message, {
          Color backgroundColor = AppColors.success,
          ToastGravity gravity = ToastGravity.BOTTOM,
        }) {
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: gravity,
        backgroundColor: backgroundColor,
        textColor: Colors.white,
        fontSize: 14.sp,
      );
    }


    Future<bool> onSubmit() async {
      FocusScope.of(context).unfocus();

      final form = _formKey.currentState;
      if (form == null || !form.validate()) return false;
      form.save();

      final request = TravelRequisitionRequest(
        company: AppUrls.companyName,
        employeeCode:
        loVm.loginData!.data.first.employeeCode.toString(),
        version: AppUrls.currentVersion,
        level: atVm.selectedLevel ?? '',
        destination:
        atVm.selectedDestination == "Domestic" ? "0" : "1",
        travelLocation: atVm.travelLocation,
        departureDate: reverseDate(atVm.departureDate),
        returnDate: reverseDate(atVm.returnDate),
        modeOfTransportation: atVm.modeOfTransportation,
        duration: atVm.duration,
        estimatedKm: atVm.estimatedKm,
        accommodation: atVm.accommodation,
        purposeOfTravel: atVm.purposeOfTravel,
        crnNumber: atVm.crnController.text.trim(),
        ccuDepartment:
        ccuVm.selectedDepartmentId?.toString() ?? '',
      );

      final ok = await applyVm.submit(
        request: request,
        employeeCode:
        loVm.loginData!.data.first.employeeCode.toString(),
        travelId: widget.travelId ?? "0",
      );

      if (ok) {
        atVm.clearAll();
      }

      return ok;
    }

    return Scaffold(

      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.travelId != null ? "Edit Travel" : "Apply Travel"),
      ),


      bottomNavigationBar: SafeArea(
        top: false,
        bottom: true,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
          child: SizedBox(
            width: double.infinity,
            height: 50.h,
            child: ElevatedButton(
              onPressed: applyVm.isSubmitting
                  ? null
                  : () async {
                FocusScope.of(context).unfocus();

                if (!(_formKey.currentState?.validate() ?? false)) {
                  showToast(
                    'Please complete all required fields.',
                    backgroundColor: AppColors.warning,
                  );
                  return;
                }

                if ((atVm.selectedLevel ?? '').isEmpty) {
                  showToast(
                    'Please select a level.',
                    backgroundColor: AppColors.warning,
                  );
                  return;
                }

                if ((atVm.selectedDestination ?? '').isEmpty) {
                  showToast(
                    'Please select a destination.',
                    backgroundColor: AppColors.warning,
                  );
                  return;
                }

                if (atVm.departureDateController.text.trim().isEmpty) {
                  showToast(
                    'Please select a departure date.',
                    backgroundColor: AppColors.warning,
                  );
                  return;
                }

                if (atVm.returnDateController.text.trim().isEmpty) {
                  showToast(
                    'Please select a return date.',
                    backgroundColor: AppColors.warning,
                  );
                  return;
                }

                if ((ccuVm.selectedDepartmentId?.toString() ?? '').isEmpty) {
                  showToast(
                    'Please select a CCU Department.',
                    backgroundColor: AppColors.warning,
                  );
                  return;
                }

                final success = await onSubmit();

                if (!context.mounted) return;

                if (success) {
                  showToast(
                    widget.travelId != null
                        ? 'Travel updated successfully.'
                        : 'Travel applied successfully.',
                    backgroundColor: AppColors.success,
                  );

                  await Future.delayed(
                    const Duration(milliseconds: 800),
                  );

                  if (context.mounted) {
                    Navigator.pop(context, true);
                  }
                } else {
                  showToast(
                    applyVm.errorMessage ?? 'Something went wrong.',
                    backgroundColor: AppColors.error,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: applyVm.isSubmitting
                  ? SizedBox(
                width: 22.w,
                height: 22.h,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
                  : Text(
                widget.travelId != null
                    ? "Update Travel"
                    : "Apply Travel",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: AppPadding.allSmall,
          child: Form(
            key: _formKey,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: AppRadius.medium,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [

                  CustomInputCard.dropdown(
                    icon: Icons.layers,
                    label: 'Level',
                    hintText: 'Select level',
                    dropdownItems: atVm.levelList,
                    selectedItem: atVm.selectedLevel,
                    onChanged: (val) => atVm.selectedLevel = val,
                    validator: (v) =>
                    (v == null || v.isEmpty)
                        ? 'Level is required'
                        : null,
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10.w),
                        child: Text(
                          "Destination",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textColor,
                          ),
                        ),
                      ),

                      SizedBox(height: 8.h),

                      AppSegmentedToggle(
                        items: atVm.destinationList,
                        selectedIndex: atVm.destinationList.indexOf(
                          atVm.selectedDestination ?? '',
                        ),
                        onChanged: (index) {
                          setState(() {
                            atVm.selectedDestination =
                            atVm.destinationList[index];
                          });
                        },
                      ),
                    ],
                  ),

                  CustomInputCard.dropdown(
                    icon: Icons.apartment,
                    label: 'CCUDepartment',
                    hintText: 'Select CCUDepartment',
                    dropdownItems: ccuVm.departmentNames,
                    selectedItem:
                    ccuVm.selectedDepartment?.departmentName,
                    onChanged: (val) {
                      if (val == null) return;

                      final selected = ccuVm.departments
                          .firstWhere(
                              (e) => e.departmentName == val);

                      ccuVm.setSelectedDepartment(selected);
                    },
                  ),

                  CustomInputCard.textField(
                    icon: Icons.confirmation_number,
                    label: 'CRN Number',
                    hintText: 'Enter CRN Number',
                    controller: atVm.crnController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),

                  CustomInputCard.textField(
                    icon: Icons.location_on,
                    label: 'Travel Location',
                    hintText: 'Enter travel location',
                    controller:
                    atVm.travelLocationController,
                    validator: (v) =>
                    (v == null || v.trim().isEmpty)
                        ? 'Travel location is required'
                        : null,
                  ),

                  CustomInputCard.textField(
                    icon: Icons.calendar_today,
                    label: 'Departure Date',
                    hintText: 'DD/MM/YYYY',
                    controller:
                    atVm.departureDateController,
                    readOnly: true,
                    onTap: () =>
                        atVm.pickDepartureDate(context),
                    validator: (v) =>
                    (v == null || v.trim().isEmpty)
                        ? 'Departure date is required'
                        : null,
                  ),

                  CustomInputCard.textField(
                    icon: Icons.calendar_today,
                    label: 'Return Date',
                    hintText: 'DD/MM/YYYY',
                    controller:
                    atVm.returnDateController,
                    readOnly: true,
                    onTap: () =>
                        atVm.pickReturnDate(context),
                    validator: (v) =>
                    (v == null || v.trim().isEmpty)
                        ? 'Return date is required'
                        : atVm.validateDateOrder(),
                  ),

                  CustomInputCard.dropdown(
                    icon: Icons.directions_bus,
                    label: "Mode of Transportation",
                    hintText: "Select Mode",
                    dropdownItems: atVm.transportationModes,
                    selectedItem: atVm.selectedTransportationMode,
                    onChanged: (value) {
                      atVm.selectedTransportationMode = value;
                      atVm.modeOfTransportationController.text = value ?? '';
                      atVm.notifyListeners();
                    },
                    validator: (value) =>
                    value == null || value.isEmpty
                        ? "Please select a mode of transportation"
                        : null,
                  ),

                  CustomInputCard.textField(
                    icon: Icons.timelapse,
                    label: 'Stay Duration',
                    hintText: 'Enter number of days',
                    controller: atVm.durationController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Required';
                      }

                      if (int.tryParse(v) == null) {
                        return 'Please enter a valid number';
                      }

                      return null;
                    },
                  ),

                  CustomInputCard.textField(
                    icon: Icons.map,
                    label: 'Estimated Km',
                    hintText: 'Enter km',
                    controller: atVm.estimatedKmController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Required';
                      }

                      if (int.tryParse(v) == null) {
                        return 'Please enter a valid number';
                      }

                      return null;
                    },
                  ),

                  CustomInputCard.dropdown(
                    icon: Icons.hotel,
                    label: "Accommodation",
                    hintText: "Select Accommodation",
                    dropdownItems: atVm.accommodationList,
                    selectedItem: atVm.selectedAccommodation,
                    onChanged: (value) {
                      atVm.selectedAccommodation = value;
                      atVm.accommodationController.text = value ?? '';
                      atVm.notifyListeners();
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please select accommodation";
                      }
                      return null;
                    },
                  ),

                  CustomInputCard.textField(
                    icon: Icons.work_outline,
                    label: 'Purpose of Travel',
                    hintText: 'Enter purpose',
                    controller:
                    atVm.purposeOfTravelController,
                    validator: (v) =>
                    (v == null || v.trim().isEmpty)
                        ? 'Required'
                        : null,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}