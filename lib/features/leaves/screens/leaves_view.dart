import 'package:clams/features/leaves/providers/LeaveFilter_viewModel.dart';
import 'package:clams/features/leaves/providers/leaveSummary_viewModel.dart';
import 'package:clams/features/leaves/widgets/leave_filter_bar.dart';
import 'package:clams/features/leaves/widgets/leave_summery_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_styles.dart';

class LeavesView extends StatefulWidget {
  const LeavesView({super.key});

  @override
  State<LeavesView> createState() => _LeavesViewState();
}

class _LeavesViewState extends State<LeavesView> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {

      /// Reset Filters
      context.read<LeaveFilterProvider>().reset();

      /// Reset Previous Data
      context.read<LeaveSummaryProvider>().reset();

      /// Load Fresh Data
      await context
          .read<LeaveSummaryProvider>()
          .load(context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LeaveFilterProvider>();
    final filter = provider.filter;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),

      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        backgroundColor: AppColors.primaryBg,
        foregroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "My Leaves",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Track and manage leave requests",
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.primaryBg,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24.r),
                bottomRight: Radius.circular(24.r),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                12.w,
                0,
                12.w,
                18.h,
              ),
              child: LeaveFilterBar(
                // backgroundColor: Colors.white,
                // selectedColor: AppColors.primaryBg,
                // textColor: Colors.white,
                // height: 43.h,
                value: filter,
                // padding: EdgeInsets.zero,
                onChanged: provider.setFilter,
                onDateSelected: provider.setDateRange,
                selectedRange: provider.dateRange,
                onSortPressed: () =>
                    _showLeaveTypeFilterSheet(
                      context,
                      provider,
                    ),
              ),
            ),
          ),

          SizedBox(height: 10.h),

          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {},
              child: SingleChildScrollView(
                physics:
                const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.only(
                  bottom: 20.h,
                ),
                child: leaveSummeryWidget(
                  context: context,
                  enableEmptyText: true,
                  disableTitle: true,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void _showLeaveTypeFilterSheet(
    BuildContext context, LeaveFilterProvider provider) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (ctx) {
      final options = provider.leaveTypeOptions;
      final selected = provider.leaveTypeFilter;

      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 8.h),
            Text(
              'Filter by Leave Type',
              style: AppStyles.heading1.copyWith(fontSize: 16.sp),
            ),
            const Divider(),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (_, index) {
                  final label = options[index];
                  final isSelected =
                      (selected == null && label == 'All Types') ||
                          (selected != null && selected == label);

                  return ListTile(
                    title: Text(label),
                    trailing: isSelected
                        ? const Icon(Icons.check, color: Colors.green)
                        : null,
                    onTap: () {
                      provider.setLeaveTypeFilter(label);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}

