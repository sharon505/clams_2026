import 'package:clams/constants/app_colors.dart';
import 'package:clams/constants/app_radius.dart';
import 'package:clams/features/leaves/providers/LeaveFilter_viewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LeaveFilterBar extends StatelessWidget {
  const LeaveFilterBar({
    super.key,
    required this.value,
    required this.onChanged,
    required this.onDateSelected,
    required this.selectedRange,
    required this.onSortPressed,
  });

  final LeaveFilter value;
  final ValueChanged<LeaveFilter> onChanged;

  final Function(DateTimeRange range) onDateSelected;
  final DateTimeRange? selectedRange;

  final VoidCallback onSortPressed;

  List<_Segment> get _segments => [
    _Segment(filter: LeaveFilter.all, label: 'All'),
    _Segment(filter: LeaveFilter.approved, label: 'Approved'),
    _Segment(filter: LeaveFilter.pending, label: 'Pending'),
    _Segment(filter: LeaveFilter.cancelled, label: 'Cancelled'),
  ];

  Future<void> _pickDateRange(BuildContext context) async {
    final now = DateTime.now();

    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
      initialDateRange: selectedRange ??
          DateTimeRange(
            start: now.subtract(const Duration(days: 7)),
            end: now,
          ),
    );

    if (picked != null) {
      onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// STATUS FILTER
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: AppRadius.large,
            border: Border.all(
              color: AppColors.primarySecondary,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.05),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: _segments.map((segment) {
              final isSelected = value == segment.filter;

              return Expanded(
                child: GestureDetector(
                  onTap: () => onChanged(segment.filter),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    padding: EdgeInsets.symmetric(
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryColor
                          : Colors.transparent,
                      borderRadius: AppRadius.medium,
                    ),
                    child: Center(
                      child: Text(
                        segment.label,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? AppColors.white
                              : AppColors.textColor,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        SizedBox(height: 12.h),

        /// DATE + FILTER BUTTON
        Row(
          children: [
            Expanded(
              child: InkWell(
                borderRadius: AppRadius.large,
                onTap: () => _pickDateRange(context),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 14.h,
                  ),
                  decoration: BoxDecoration(
                    color: selectedRange != null
                        ? AppColors.primarySecondary
                        : AppColors.white,
                    borderRadius: AppRadius.large,
                    border: Border.all(
                      color: AppColors.primarySecondary,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_month_rounded,
                        color: AppColors.primaryColor,
                        size: 18.sp,
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          selectedRange != null
                              ? "${selectedRange!.start.day}/${selectedRange!.start.month} - ${selectedRange!.end.day}/${selectedRange!.end.month}"
                              : "Select Date Range",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(width: 10.w),

            /// FILTER BUTTON
            InkWell(
              borderRadius: AppRadius.large,
              onTap: onSortPressed,
              child: Container(
                height: 50.h,
                width: 50.h,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: AppRadius.large,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryColor.withOpacity(.25),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.tune_rounded,
                  color: AppColors.white,
                  size: 22.sp,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Segment {
  final LeaveFilter filter;
  final String label;

  const _Segment({
    required this.filter,
    required this.label,
  });
}