import 'package:clams/constants/app_colors.dart';
import 'package:clams/constants/app_padding.dart';
import 'package:clams/constants/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LeaveSummaryCard extends StatelessWidget {
  final String leaveType;
  final String status;
  final String appliedDate;
  final String statusDate;
  final String approvedBy;
  final String days;

  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  final bool showDelete;
  final bool deleting;

  const LeaveSummaryCard({
    super.key,
    required this.leaveType,
    required this.status,
    required this.appliedDate,
    required this.statusDate,
    required this.approvedBy,
    required this.days,
    this.onTap,
    this.onDelete,
    this.showDelete = false,
    this.deleting = false,
  });

  @override
  Widget build(BuildContext context) {
    final s = status.toLowerCase();

    Color statusColor;

    switch (s) {
      case "approved":
        statusColor = Colors.green;
        break;

      case "cancelled":
      case "rejected":
        statusColor = Colors.red;
        break;

      default:
        statusColor = Colors.orange;
    }

    final canDelete = s == "pending";

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: AppPadding.cardPadding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: AppColors.primarySecondary),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        children: [
          /// HEADER
          Row(
            spacing: 10.w,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _leaveIcon(statusColor),

              Expanded(
                child: Column(
                  spacing: 3.h,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      leaveType,
                      style: AppStyles.heading2.copyWith(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    Row(
                      spacing: 6.w,
                      children: [
                        _statusChip(status, statusColor),
                        _dateChip(statusDate, statusColor),
                      ],
                    ),
                  ],
                ),
              ),

              Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 10.h,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (showDelete && canDelete)
                    _deleteButton(onDelete),
                  _arrowButton(onTap),
                ],
              ),
            ],
          ),

          Divider(color: Colors.grey.shade200),

          /// BODY
          Row(
            spacing: 7.w,
            children: [
              Expanded(
                child: Column(
                  spacing: 7.h,
                  children: [
                    _infoTile(
                      Icons.calendar_today_outlined,
                      "Applied Date",
                      appliedDate,
                    ),

                    _infoTile(
                      Icons.person_outline,
                      status == "Cancelled" ? "Cancelled By" : "Approved By",
                      approvedBy,
                    ),
                  ],
                ),
              ),

              Container(width: 1, height: 120.h, color: Colors.grey.shade200),

              Expanded(
                child: Column(
                  spacing: 7.h,
                  children: [
                    _infoTile(
                      Icons.description_outlined,
                      status == "Approved"
                          ? "Approved Date"
                          : status == "Cancelled"
                          ? "Cancelled Date"
                          : "Approved Date",
                      status == "Pending" ? "-" : statusDate,
                    ),

                    _infoTile(Icons.schedule, "Days", days),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _leaveIcon(Color color) {
    return Container(
      width: 44.w,
      height: 44.w,
      decoration: BoxDecoration(
        color: color.withOpacity(.12),
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.task_alt_rounded, color: color, size: 22.sp),
    );
  }

  Widget _statusChip(String status, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: color.withOpacity(.12),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        status.toUpperCase(),
        style: AppStyles.bodySmall.copyWith(
          color: color,
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
          height: 1,
        ),
      ),
    );
  }

  Widget _dateChip(String date, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: color.withOpacity(.10),
        borderRadius: BorderRadius.circular(5.r),
      ),
      child: Text(
        date,
        style: AppStyles.bodySmall.copyWith(
          color: color,
          fontSize: 9.sp,
          fontWeight: FontWeight.w600,
          height: 1,
        ),
      ),
    );
  }

  Widget _deleteButton(VoidCallback? onDelete) {
    return InkWell(
      borderRadius: BorderRadius.circular(18.r),
      onTap: onDelete,
      child: Container(
        width: 30.w,
        height: 30.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.red, width: 1),
        ),
        child: Icon(
          Icons.delete_outline_rounded,
          color: Colors.red,
          size: 16.sp,
        ),
      ),
    );
  }

  Widget _arrowButton(VoidCallback? onTap) {
    return InkWell(
      borderRadius: BorderRadius.circular(18.r),
      onTap: onTap,
      child: Container(
        width: 30.w,
        height: 30.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.primaryColor, width: 1),
        ),
        child: Icon(
          Icons.chevron_right_rounded,
          color: AppColors.primaryColor,
          size: 16.sp,
        ),
      ),
    );
  }

  Widget _infoTile(IconData icon, String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            color: const Color(0xffEEF3FB),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: const Color(0xff6C7F95), size: 20.sp),
        ),

        SizedBox(width: 10.w),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppStyles.bodySmall.copyWith(
                  color: Colors.grey.shade600,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),

              SizedBox(height: 2.h),

              Text(
                value,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppStyles.bodyMedium.copyWith(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
