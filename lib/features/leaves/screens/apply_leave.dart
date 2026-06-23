import 'package:clams/constants/app_colors.dart';
import 'package:clams/constants/app_padding.dart';
import 'package:clams/constants/app_radius.dart';
import 'package:clams/constants/app_styles.dart';
import 'package:clams/constants/app_textfield.dart';
import 'package:clams/features/leaves/providers/leaveApply_viewModel.dart';
import 'package:clams/features/leaves/providers/leaveType_viewModel.dart';
import 'package:clams/features/leaves/widgets/calendar_range_card.dart';
import 'package:clams/features/leaves/widgets/drop_down_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class ApplyLeave extends StatefulWidget {
  const ApplyLeave({super.key});

  @override
  State<ApplyLeave> createState() => _ApplyLeaveState();
}

class _ApplyLeaveState extends State<ApplyLeave> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();

  bool _isFabVisible = true;
  LeaveTypeProvider? _leaveProvider;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LeaveTypeProvider>().fetchLeaveTypes(context);
    });

    _scrollController.addListener(() {
      final dir = _scrollController.position.userScrollDirection;

      if (dir == ScrollDirection.reverse && _isFabVisible) {
        setState(() => _isFabVisible = false);
      } else if (dir == ScrollDirection.forward && !_isFabVisible) {
        setState(() => _isFabVisible = true);
      }
    });
  }

  bool _dateInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _leaveProvider ??= context.read<LeaveTypeProvider>();

    if (_dateInitialized) return;
    _dateInitialized = true;

    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (args != null && args['date'] is DateTime) {
        // ✅ Use passed date
        _leaveProvider!.setInitialDate(args['date']);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _leaveProvider?.resetForm(notify: false);
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        context.read<LeaveTypeProvider>().resetForm();
        context.read<LeaveApplyProvider>().reset();

        Navigator.pop(context, result);
      },
      child: Scaffold(
        appBar: AppBar(title: Text('Apply Leave'), centerTitle: true),
        body: SafeArea(
          child: Padding(
            padding: AppPadding.cardPadding,
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _formCard(),
                    SizedBox(height: 20.h),
                    Consumer<LeaveApplyProvider>(
                      builder: (_, applyP, __) {
                        return _submitButton(
                          isLoading: applyP.isSubmitting,
                          onPressed: () async {
                            if (!(_formKey.currentState?.validate() ?? false)) {
                              showToast(
                                'Please complete all required fields.',
                                backgroundColor: AppColors.warning,
                              );
                              return;
                            }

                            final provider = context.read<LeaveTypeProvider>();

                            if (provider.fromDate == null) {
                              showToast(
                                'Please select a leave date.',
                                backgroundColor: AppColors.warning,
                              );
                              return;
                            }

                            if (provider.selectedLeaveType == null) {
                              showToast(
                                'Please choose a leave type.',
                                backgroundColor: AppColors.warning,
                              );
                              return;
                            }

                            if (provider.selectedDayType.isEmpty) {
                              showToast(
                                'Please select a day type.',
                                backgroundColor: AppColors.warning,
                              );
                              return;
                            }

                            if (provider.selectedDayType == 'Half Day' &&
                                provider.selectedLeaveSection.isEmpty) {
                              showToast(
                                'Please select a leave section.',
                                backgroundColor: AppColors.warning,
                              );
                              return;
                            }

                            final res = await applyP.submit(context);

                            if (res != null && res.result.isNotEmpty) {
                              final r = res.result.first;

                              if (r.statusId == 200) {
                                showToast(
                                  'Leave applied successfully',
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
                                  r.msg,
                                  backgroundColor: AppColors.error,
                                );
                              }
                            } else {
                              showToast(
                                'Failed to apply leave.',
                                backgroundColor: AppColors.error,
                              );
                            }
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // FORM CARD
  // ----------------------------------------------------------
  Widget _formCard() {
    return Column(
      children: [
        const CustomCalendarPage(), // Calendar outside the container
        SizedBox(height: 16.h),
        Container(
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
          child: Column(children: [_dropdownSection(), _textFields()]),
        ),
      ],
    );
  }

  Widget _dropdownSection() {
    return Consumer<LeaveTypeProvider>(
      builder: (_, provider, __) {
        if (provider.isLoading) {
          return DropdownShimmer();
        }

        final leaveTypes = provider.leaveTypes.map((e) => e.leaveType).toList();

        return Column(
          children: [
            CustomInputCard.dropdown(
              icon: Icons.category,
              label: 'Leave Type',
              hintText: 'Choose type',
              dropdownItems: leaveTypes,
              selectedItem: provider.selectedLeaveType?.leaveType,
              onChanged: (val) async {
                await HapticFeedback.heavyImpact();
                final selected = provider.leaveTypes.firstWhere(
                  (e) => e.leaveType == val,
                );
                provider.setSelectedLeaveType(selected);
              },
              validator: (v) =>
                  v == null || v.isEmpty ? 'Select leave type' : null,
            ),
          ],
        );
      },
    );
  }

  Widget _textFields() {
    return Consumer<LeaveTypeProvider>(
      builder: (_, provider, __) {
        return Column(
          children: [
            CustomInputCard.dropdown(
              icon: Icons.access_time,
              label: 'Day Type',
              hintText: 'Select Day Type',
              dropdownItems: provider.dayTypes,
              selectedItem: provider.selectedDayType,
              onChanged: (value) {
                if (value != null) {
                  provider.setSelectedDayType(value);
                }
              },
            ),
            if (provider.selectedDayType == 'Half Day')
              CustomInputCard.dropdown(
                icon: Icons.schedule,
                label: 'Leave Section',
                hintText: 'Select Leave Section',
                dropdownItems: provider.leaveSections,
                selectedItem: provider.selectedLeaveSection,
                onChanged: (value) {
                  if (value != null) {
                    provider.setSelectedLeaveSection(value);
                  }
                },
              ),
            // Padding(
            //   padding: AppPadding.horizontalOnly,
            //   child: Divider(color: AppColors.primaryColor),
            // ),
            CustomInputCard.textField(
              icon: Icons.person,
              label: 'CRN',
              hintText: 'Enter your CRN',
              controller: provider.cRNController,
              keyboardType: TextInputType.number,
            ),
            // Padding(
            //   padding: AppPadding.horizontalOnly,
            //   child: Divider(color: AppColors.primaryColor),
            // ),
            CustomInputCard.textArea(
              label: 'Leave Reason',
              hintText: 'Enter your reason',
              controller: provider.reasonController,
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Reason required' : null,
            ),
            SizedBox(height: 10.h),
          ],
        );
      },
    );
  }

  Widget _submitButton({
    required bool isLoading,
    required VoidCallback onPressed,
  }) {
    final days = context.watch<LeaveTypeProvider>().selectedLeaveDays;

    return SafeArea(
      bottom: true,
      child: SizedBox(
        width: double.infinity,
        height: 50.h,
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: AppRadius.medium),
          ),
          child: isLoading
              ? SizedBox(
                  width: 20.w,
                  height: 20.h,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.white,
                  ),
                )
              : Text(
                  days == 0.5
                      ? 'Apply Half Day Leave'
                      : 'Apply $days ${days == 1 ? 'Day' : 'Days'} Leave',
                  textAlign: TextAlign.center,
                  style: AppStyles.buttonText,
                ),
        ),
      ),
    );
  }
}

// ----------------------------------------------------------
// CALENDAR (LOCKED)
// ----------------------------------------------------------
class CustomCalendarPage extends StatelessWidget {
  const CustomCalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LeaveTypeProvider>(
      builder: (_, provider, __) {
        return CalendarRangeCard(
          fromDate: provider.fromDate,
          toDate: provider.toDate,
          focusedDay: provider.focusedDay,
          firstAllowedDate: provider.firstAllowedDate,
          lastAllowedDate: DateTime.now().add(const Duration(days: 365)),
          onSelectDay: provider.selectDay,
          // availableGestures: AvailableGestures.none, // 🔒 LOCK SCROLL
          headerVisible: true,
          // dateFormat: 'EEE, dd MMM yyyy',
        );
      },
    );
  }
}
