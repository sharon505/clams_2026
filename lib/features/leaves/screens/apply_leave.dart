import 'package:clams/constants/app_colors.dart';
import 'package:clams/constants/app_padding.dart';
import 'package:clams/constants/app_radius.dart';
import 'package:clams/constants/app_styles.dart';
import 'package:clams/constants/app_textfield.dart';
import 'package:clams/features/leaves/providers/leaveApply_viewModel.dart';
import 'package:clams/features/leaves/providers/leaveType_viewModel.dart';
import 'package:clams/features/leaves/widgets/calendar_range_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../services/leave_service.dart';

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
      } else {
        // ✅ Default to yesterday
        final yesterday = DateTime.now().subtract(const Duration(days: 1));
        _leaveProvider!.setInitialDate(yesterday);
      }
    });
  }



  @override
  void dispose() {
    _scrollController.dispose();
    _leaveProvider?.resetForm(notify: false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final leaveService = LeaveService();

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        context.read<LeaveTypeProvider>().resetForm();
        context.read<LeaveApplyProvider>().reset();

        Navigator.pop(context, result);
      },
      child: Scaffold(
        appBar: AppBar(title: Text('Apply Leave'),centerTitle: true),
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
                              // _showDialog(
                              //   'INFO',
                              //   'Some fields are missing.',
                              //   'Please complete all required fields.',
                              //   DialogType.warning,
                              // );
                              // return;
                            }

                            final leaveP = context.read<LeaveTypeProvider>();

                            if (leaveP.fromDate == null) {
                              // _showDialog(
                              //   'INFO',
                              //   'Date not selected',
                              //   'Please select a date.',
                              //   DialogType.warning,
                              // );
                              // return;
                            }

                            if (leaveP.selectedLeaveType == null) {
                              // _showDialog(
                              //   'INFO',
                              //   'Leave type not selected',
                              //   'Please choose a leave type.',
                              //   DialogType.warning,
                              // );
                              // return;
                            }

                            final res = await applyP.submit(context);

                            if (res != null && res.result.isNotEmpty) {
                              final r = res.result.first;
                              if (r.statusId == 200) {
                                // _showDialog(
                                //   'Success',
                                //   'Leave Applied Successfully',
                                //   'Your leave request has been submitted.',
                                //   DialogType.success,
                                //   onOk: () {
                                //     Navigator.pushReplacementNamed(
                                //         context, 'BottomNavView');
                                //   },
                                // );
                              } else {
                                // _showDialog(
                                //   'Failed',
                                //   'Leave Application Failed',
                                //   r.msg,
                                //   DialogType.error,
                                // );
                              }
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
          child: Column(
            children: [
              _dropdownSection(),
              _textFields(),
            ],
          ),
        ),

        SizedBox(height: 16.h),

        const CustomCalendarPage(), // Calendar outside the container
      ],
    );
  }

  Widget _dropdownSection() {
    return Consumer<LeaveTypeProvider>(
      builder: (_, leaveP, __) {

        if (leaveP.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final leaveTypes =
        leaveP.leaveTypes.map((e) => e.leaveType).toList();

        return Column(
          children: [
            CustomInputCard.dropdown(
              icon: Icons.category,
              label: 'Leave Type',
              hintText: 'Choose type',
              dropdownItems: leaveTypes,
              selectedItem: leaveP.selectedLeaveType?.leaveType,
              onChanged: (val) {
                final selected = leaveP.leaveTypes.firstWhere(
                      (e) => e.leaveType == val,
                );
                leaveP.setSelectedLeaveType(selected);
              },
              validator: (v) =>
              v == null || v.isEmpty
                  ? 'Select leave type'
                  : null,
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
            SizedBox(height: 10.h,)
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
            shape: RoundedRectangleBorder(
              borderRadius: AppRadius.medium,
            ),
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
