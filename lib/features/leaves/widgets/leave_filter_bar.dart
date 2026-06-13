import 'package:clams/constants/app_colors.dart';
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

  Future<void> pickDateRange(BuildContext context) async {
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
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(11.r),
            border: Border.all(
              color: AppColors.primarySecondary,
              width: 1,
            ),
          ),
          child: Row(
            children: _segments.map((segment) {
              final isSelected = value == segment.filter;

              return Expanded(
                child: GestureDetector(
                  onTap: () => onChanged(segment.filter),
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(
                      begin: isSelected ? 0.98 : 1,
                      end: isSelected ? 1 : 0.98,
                    ),
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    builder: (context, scale, child) {
                      return Transform.scale(
                        scale: scale,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOutCubic,
                          height: 42.h,
                          alignment: Alignment.center,
                          margin: EdgeInsets.symmetric(horizontal: 2.w),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primaryColor
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(11.r),
                            boxShadow: isSelected
                                ? [
                              BoxShadow(
                                color: AppColors.primaryColor.withOpacity(.25),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ]
                                : [],
                          ),
                          child: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeOut,
                            style: TextStyle(
                              fontSize: isSelected ? 13.5.sp : 13.sp,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.textColor,
                            ),
                            child: Text(
                              segment.label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            }).toList(),
          ),
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