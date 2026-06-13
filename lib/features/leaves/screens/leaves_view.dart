import 'package:clams/constants/app_padding.dart';
import 'package:clams/features/leaves/providers/LeaveFilter_viewModel.dart';
import 'package:clams/features/leaves/providers/leaveSummary_viewModel.dart';
import 'package:clams/features/leaves/widgets/leave_summary_card.dart';
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

class _LeavesViewState extends State<LeavesView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 4, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final filterProvider = context.read<LeaveFilterProvider>();

      filterProvider.reset();

      context.read<LeaveSummaryProvider>().reset();

      await context.read<LeaveSummaryProvider>().load(context: context);
    });

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;

      final provider = context.read<LeaveFilterProvider>();

      switch (_tabController.index) {
        case 0:
          provider.setFilter(LeaveFilter.all);
          break;

        case 1:
          provider.setFilter(LeaveFilter.approved);
          break;

        case 2:
          provider.setFilter(LeaveFilter.pending);
          break;

        case 3:
          provider.setFilter(LeaveFilter.cancelled);
          break;
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

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
            icon: const Icon(Icons.calendar_month_outlined),
            onPressed: () async {
              final provider = context.read<LeaveSummaryProvider>();

              final now = DateTime.now();

              final picked = await showDateRangePicker(
                context: context,
                firstDate: DateTime(now.year - 5),
                lastDate: DateTime(now.year + 5),
                initialDateRange:
                    provider.dateRange ??
                    DateTimeRange(
                      start: now.subtract(const Duration(days: 7)),
                      end: now,
                    ),
              );

              if (picked != null) {
                provider.setDateRange(picked);
              }
            },
          ),

          /// Leave Type
          IconButton(
            tooltip: "Leave Type",
            onPressed: () => _showLeaveTypeFilterSheet(context),
            icon: const Icon(Icons.filter_alt_outlined),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 12.w),
            padding: EdgeInsets.all(3.w),
            height: 48.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.primarySecondary, width: 1),
            ),
            child: TabBar(
              controller: _tabController,
              dividerColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.tab,
              labelPadding: EdgeInsets.zero,
              splashBorderRadius: BorderRadius.circular(10.r),
              overlayColor: WidgetStateProperty.all(Colors.transparent),

              indicator: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(10.r),
              ),

              labelColor: Colors.white,
              unselectedLabelColor: AppColors.textColor,

              labelStyle: AppStyles.bodySmall.copyWith(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),

              unselectedLabelStyle: AppStyles.bodySmall.copyWith(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),

              tabs: const [
                Tab(text: "all"),
                Tab(text: "approved"),
                Tab(text: "pending"),
                Tab(text: "cancelled"),
              ],
            ),
          ),

          Consumer<LeaveSummaryProvider>(
            builder: (context, provider, child) {
              if (provider.dateRange == null &&
                  provider.leaveTypeFilter == null) {
                return const SizedBox.shrink();
              }

              return Padding(
                padding: EdgeInsets.fromLTRB(
                  AppPadding.horizontal12,
                  AppPadding.vertical12,
                  AppPadding.horizontal12,
                  0,
                ),
                child: Wrap(
                  direction: Axis.horizontal,
                  spacing: 8.w,
                  runSpacing: 8.h,
                  alignment: WrapAlignment.start,
                  runAlignment: WrapAlignment.start,
                  textDirection: TextDirection.ltr,
                  verticalDirection: VerticalDirection.down,
                  clipBehavior: Clip.none,
                  children: [
                    if (provider.dateRange != null)
                      _buildFilterChip(
                        icon: Icons.calendar_month_rounded,
                        label:
                            "${provider.dateRange!.start.day}/${provider.dateRange!.start.month}/${provider.dateRange!.start.year}"
                            " - "
                            "${provider.dateRange!.end.day}/${provider.dateRange!.end.month}/${provider.dateRange!.end.year}",
                        onDelete: provider.clearDateRange,
                      ),

                    if (provider.leaveTypeFilter != null)
                      _buildFilterChip(
                        icon: Icons.badge_outlined,
                        label: provider.leaveTypeFilter!,
                        onDelete: provider.clearLeaveTypeFilter,
                      ),
                  ],
                ),
              );
            },
          ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildLeavePage(LeaveFilter.all),
                _buildLeavePage(LeaveFilter.approved),
                _buildLeavePage(LeaveFilter.pending),
                _buildLeavePage(LeaveFilter.cancelled),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeavePage(LeaveFilter filter) {
    return Consumer<LeaveSummaryProvider>(
      builder: (context, provider, child) {
        final records = provider.getLeaves(filter);

        if (records.isEmpty) {
          return const Center(child: Text("No Leaves Found"));
        }

        return RefreshIndicator(
          onRefresh: () async {
            await provider.load(context: context);
          },
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.only(bottom: 20.h),
            itemCount: records.length,
            itemBuilder: (context, index) {
              final leave = records[index];

              return LeaveSummaryCard(
                leaveType: leave.leaveType,
                status: leave.status,
                appliedDate: leave.appliedDate,
                statusDate: leave.updatedDate ?? "-",
                approvedBy: leave.appliedTo,
                days: leave.noOfDays.toString(),
                onTap: () => Navigator.pushNamed(
                  context,
                  'LeaveDetailsScreen',
                  arguments: {
                    "leave": leave,
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}

Widget _buildFilterChip({
  required IconData icon,
  required String label,
  required VoidCallback onDelete,
}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
    decoration: BoxDecoration(
      color: AppColors.primarySecondary,
      borderRadius: BorderRadius.circular(30.r),
      border: Border.all(color: AppColors.primaryColor.withOpacity(.15)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16.sp, color: AppColors.primaryColor),
        SizedBox(width: 6.w),
        Text(
          label,
          style: AppStyles.bodySmall.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.primaryColor,
          ),
        ),
        SizedBox(width: 6.w),
        GestureDetector(
          onTap: onDelete,
          child: Container(
            height: 20.r,
            width: 20.r,
            decoration: const BoxDecoration(
              color: AppColors.primaryColor,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.close, size: 12.sp, color: AppColors.white),
          ),
        ),
      ],
    ),
  );
}

void _showLeaveTypeFilterSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
    ),
    builder: (ctx) {
      return Consumer<LeaveSummaryProvider>(
        builder: (context, provider, child) {
          const options = [
            'All Types',
            'Earned Leave',
            'Casual Leave',
            'Official Duty',
            'Sick Leave',
            'Loss of Pay',
            'Compensatory Off',
            'Off Day',
            'Own Marriage Leave',
            'Maternity Leave',
            'Paternity Leave',
            'Bereavement Leave',
            "Child's Marriage Leave",
            "Sterilization Leave",
            "Saturday Off",
          ];

          final selected = provider.leaveTypeFilter;

          return SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                  ),

                  SizedBox(height: 16.h),

                  Text("Filter by Leave Type", style: AppStyles.heading4),

                  SizedBox(height: 16.h),

                  Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: options.length,
                      separatorBuilder: (_, __) =>
                          Divider(height: 1, color: Colors.grey.shade200),
                      itemBuilder: (context, index) {
                        final label = options[index];

                        final isSelected =
                            (selected == null && label == "All Types") ||
                            selected == label;

                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            label,
                            style: AppStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          leading: Icon(
                            isSelected
                                ? Icons.radio_button_checked
                                : Icons.radio_button_off,
                            color: isSelected
                                ? AppColors.primaryColor
                                : Colors.grey,
                          ),
                          onTap: () {
                            provider.setLeaveTypeFilter(label);
                            Navigator.pop(ctx);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
