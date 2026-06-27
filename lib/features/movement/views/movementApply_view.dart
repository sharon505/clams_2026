import 'package:clams/constants/app_colors.dart';
import 'package:clams/constants/app_padding.dart';
import 'package:clams/constants/app_textfield.dart';
import 'package:clams/features/leaves/providers/leaveType_viewModel.dart';
import 'package:clams/features/leaves/widgets/calendar_range_card.dart';
import 'package:clams/features/movement/widgets/time_line_range_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../viewmodel/applyMovement_viewModel.dart';
import '../viewmodel/movementForm_ViewModel.dart';

class MovementApplyView extends StatefulWidget {
  const MovementApplyView({super.key});

  @override
  State<MovementApplyView> createState() => _MovementApplyViewState();
}

class _MovementApplyViewState extends State<MovementApplyView> {
  late final LeaveTypeProvider _leave;
  bool _initialized = false;

  /// NEW FLAG
  bool _dateFromArgs = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;

    _leave = context.read<LeaveTypeProvider>();
    final vm = context.read<MovementFormViewModel>();

    final args = ModalRoute.of(context)?.settings.arguments;

    if (args is Map && args['date'] is DateTime) {
      final date = args['date'] as DateTime;
      _dateFromArgs = true;
      vm.setFromDate(date);
      vm.setToDate(date);
    }
  }

  @override
  void dispose() {
    _leave.resetForm(notify: false);
    super.dispose();
  }

  // -----------------------------------------------------------
  // SUBMIT HANDLER
  // -----------------------------------------------------------
  Future<void> _handleSubmit(BuildContext context) async {
    final vm = context.read<MovementFormViewModel>();
    final applyVm = context.read<ApplyMovementViewModel>();

    final error = vm.validate();

    if (error != null) {
      Fluttertoast.showToast(
        msg: error,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppColors.warning,
        textColor: Colors.white,
      );
      return;
    }

    final ok = await applyVm.submit(context);

    if (ok) {
      Fluttertoast.showToast(
        msg: applyVm.lastMessage ?? "Movement applied successfully.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppColors.success,
        textColor: Colors.white,
      );

      vm.reset();

      if (context.mounted) {
        Navigator.pop(context, true);
      }
    } else {
      Fluttertoast.showToast(
        msg: applyVm.errorMessage ?? "Failed to apply movement.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppColors.error,
        textColor: Colors.white,
      );
    }
  }

  // -----------------------------------------------------------
  // UI
  // -----------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MovementFormViewModel>();
    final applyVm = context.watch<ApplyMovementViewModel>();

    return PopScope(
      canPop: !applyVm.isLoading,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) {
          vm.reset();
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text("Apply Movement"),centerTitle: true,),

        body: Padding(
          padding: AppPadding.allSmall,
          child: SingleChildScrollView(
            child: Column(
              spacing: 10.h,
              children: [
                CalendarRangeCard(
                  focusedDay: vm.fromDate ?? DateTime.now(),

                  firstAllowedDate: DateTime(
                    DateTime.now().year - 1,
                    DateTime.now().month,
                    DateTime.now().day,
                  ),

                  lastAllowedDate: DateTime.now(),

                  fromDate: vm.fromDate,
                  toDate: vm.toDate,

                  onSelectDay: (selectedDay, focusedDay) {
                    vm.setFromDate(selectedDay);

                    /// Same day movement
                    vm.setToDate(selectedDay);
                  },
                ),
                Consumer<MovementFormViewModel>(
                  builder: (_, vm, __) {
                    return MovementTimePicker(
                      startTime: vm.startTime,
                      durationHour: vm.durationHour,
                      onStartTimeChanged: vm.setStartTime,
                      onDurationChanged: vm.setDuration,
                    );
                  },
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16.r),
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

                      /// FROM DATE
                      // CustomInputCard.textField(
                      //   icon: Icons.calendar_today,
                      //   label: 'Start Date',
                      //   controller: vm.fromDateC,
                      //   readOnly: true,
                      //   hintText: _dateFromArgs
                      //       ? 'Auto selected'
                      //       : 'Select start date',
                      //   onTap: _dateFromArgs
                      //       ? null
                      //       : () => vm.pickFromDate(context),
                      // ),

                      /// FROM TIME
                      // CustomInputCard.textField(
                      //   icon: Icons.schedule,
                      //   label: 'Start Time',
                      //   hintText: 'Select start time',
                      //   controller: vm.fromTimeC,
                      //   readOnly: true,
                      //   onTap: () => vm.pickFromTime(context),
                      // ),

                      /// TO DATE
                      // CustomInputCard.textField(
                      //   icon: Icons.calendar_today,
                      //   label: 'End Date',
                      //   controller: vm.toDateC,
                      //   readOnly: true,
                      //   hintText: _dateFromArgs
                      //       ? 'Auto selected'
                      //       : 'Select end date',
                      //   onTap: _dateFromArgs
                      //       ? null
                      //       : () => vm.pickToDate(context),
                      // ),

                      /// TO TIME
                      // CustomInputCard.textField(
                      //   icon: Icons.schedule,
                      //   label: 'End Time',
                      //   hintText: 'Select end time',
                      //   controller: vm.toTimeC,
                      //   readOnly: true,
                      //   onTap: () => vm.pickToTime(context),
                      // ),

                      /// REASON
                      CustomInputCard.textArea(
                        label: "Reason",
                        hintText: "Reason For Movement",
                        controller: vm.reasonC,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
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
                onPressed: applyVm.isLoading
                    ? null
                    : () => _handleSubmit(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: applyVm.isLoading
                    ? SizedBox(
                  width: 22.w,
                  height: 22.h,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                    : Text(
                  "Apply For Movement",
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
      ),
    );
  }
}
