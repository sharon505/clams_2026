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
      await context.read<LeaveSummaryProvider>().load(context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LeaveFilterProvider>();
    final filter = provider.filter;
    final filterProvider = context.watch<LeaveFilterProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primaryBg,
        foregroundColor: Colors.white,
        centerTitle: false,

        title: Text(
          "Leaves",
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),

        actions: [
          IconButton(
            tooltip: "Date Filter",
            onPressed: () async {
              final now = DateTime.now();

              final picked = await showDateRangePicker(
                context: context,
                firstDate: DateTime(now.year - 5),
                lastDate: DateTime(now.year + 5),
                initialDateRange:
                filterProvider.dateRange ??
                    DateTimeRange(
                      start: now.subtract(const Duration(days: 7)),
                      end: now,
                    ),
              );

              if (picked != null) {
                filterProvider.setDateRange(picked);
              }
            },
            icon: const Icon(Icons.calendar_month_outlined),
          ),

          /// Leave Type
          IconButton(
            tooltip: "Leave Type",
            onPressed: () {
              _showLeaveTypeFilterSheet(context, filterProvider);
            },
            icon: const Icon(Icons.filter_alt_outlined),
          ),

        ],
      ),
      body: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeOutCubic,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.primaryBg,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24.r),
                bottomRight: Radius.circular(24.r),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 18.h),
              child: TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 400),
                tween: Tween(begin: 0, end: 1),
                curve: Curves.easeOut,
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(0, (1 - value) * 20),
                      child: child,
                    ),
                  );
                },
                child: LeaveFilterBar(
                  value: filter,
                  onChanged: provider.setFilter,
                  onDateSelected: provider.setDateRange,
                  selectedRange: provider.dateRange,
                  onSortPressed: () =>
                      _showLeaveTypeFilterSheet(context, provider),
                ),
              )
            ),
          ),

          SizedBox(height: 10.h),

          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              child: RefreshIndicator(
                key: ValueKey(filter),
                onRefresh: () async {
                  await context.read<LeaveSummaryProvider>().load(
                    context: context,
                  );
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.only(bottom: 20.h),
                  child: leaveSummeryWidget(
                    context: context,
                    enableEmptyText: true,
                    disableTitle: true,
                  ),
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
  BuildContext context,
  LeaveFilterProvider provider,
) {
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
