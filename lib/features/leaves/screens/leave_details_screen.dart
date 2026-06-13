import 'package:clams/constants/app_colors.dart';
import 'package:clams/constants/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/model_leaveSummery.dart';

class LeaveDetailsScreen extends StatelessWidget {
  const LeaveDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
    ModalRoute.of(context)!.settings.arguments
    as Map<String, dynamic>;

    final LeaveRecord leave = args["leave"] as LeaveRecord;

    Color statusColor;

    switch (leave.status.toLowerCase()) {
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

    return Scaffold(
      backgroundColor: const Color(0xffF8F9FC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primaryBg,
        foregroundColor: Colors.white,
        title: Text(
          "Leave Details",
          // style: AppStyles.heading4.copyWith(
          //   color: Colors.white,
          // ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(18.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: AppColors.primarySecondary,
                ),
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
                  CircleAvatar(
                    radius: 34.r,
                    backgroundColor: statusColor.withOpacity(.12),
                    child: Icon(
                      Icons.event_available_rounded,
                      color: statusColor,
                      size: 32.sp,
                    ),
                  ),

                  SizedBox(height: 14.h),

                  Text(
                    leave.leaveType,
                    style: AppStyles.heading3.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  SizedBox(height: 10.h),

                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(.12),
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    child: Text(
                      leave.status.toUpperCase(),
                      style: AppStyles.bodySmall.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  SizedBox(height: 12.h),

                  Text(
                    "${leave.noOfDays} Day(s)",
                    style: AppStyles.heading4.copyWith(
                      color: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20.h),

            /// DATE CARD
            Container(
              padding: EdgeInsets.all(18.w),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          "FROM",
                          style: AppStyles.bodySmall.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          leave.fromDate,
                          textAlign: TextAlign.center,
                          style: AppStyles.bodyLarge.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 28.sp,
                  ),

                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          "TO",
                          style: AppStyles.bodySmall.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          leave.toDate,
                          textAlign: TextAlign.center,
                          style: AppStyles.bodyLarge.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20.h),

            buildInfoCard(
              icon: Icons.calendar_today_outlined,
              title: "Applied Date",
              value: leave.appliedDate,
            ),

            SizedBox(height: 12.h),

            buildInfoCard(
              icon: Icons.update_outlined,
              title: "Updated Date",
              value: leave.updatedDate ?? "-",
            ),

            SizedBox(height: 12.h),

            buildInfoCard(
              icon: Icons.person_outline,
              title: "Applied To",
              value: leave.appliedTo,
            ),

            SizedBox(height: 12.h),

            buildInfoCard(
              icon: Icons.schedule_outlined,
              title: "Leave Section",
              value: leave.leaveSection,
            ),

            SizedBox(height: 12.h),

            buildInfoCard(
              icon: Icons.badge_outlined,
              title: "Employee Code",
              value: leave.employeeCode,
            ),

            SizedBox(height: 12.h),

            buildInfoCard(
              icon: Icons.confirmation_number_outlined,
              title: "Leave ID",
              value: leave.leaveId.toString(),
            ),

            SizedBox(height: 12.h),

            buildInfoCard(
              icon: Icons.timelapse_outlined,
              title: "Half Day",
              value: leave.isHalfDay ? "Yes" : "No",
            ),

            SizedBox(height: 12.h),

            buildInfoCard(
              icon: Icons.settings_backup_restore_outlined,
              title: "Processed",
              value: leave.processed == 1 ? "Yes" : "No",
            ),

            SizedBox(height: 24.h),

            Text(
              "Reason",
              style: AppStyles.heading4,
            ),

            SizedBox(height: 10.h),

            if (leave.rejectedReason.trim().isNotEmpty) ...[
              Text(
                "Rejected Reason",
                style: AppStyles.heading4,
              ),

              SizedBox(height: 10.h),

              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(18.r),
                  border: Border.all(
                    color: Colors.red.shade200,
                  ),
                ),
                child: Text(
                  leave.rejectedReason,
                  style: AppStyles.bodyMedium.copyWith(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              SizedBox(height: 24.h),
            ],


            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18.r),
                border: Border.all(
                  color: AppColors.primarySecondary,
                ),
              ),
              child: Text(
                leave.leaveReason.isEmpty
                    ? "-"
                    : leave.leaveReason,
                style: AppStyles.bodyMedium.copyWith(
                  height: 1.6,
                ),
              ),
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  Widget buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: AppColors.primarySecondary,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22.r,
            backgroundColor: AppColors.primarySecondary,
            child: Icon(
              icon,
              color: AppColors.primaryColor,
              size: 22.sp,
            ),
          ),

          SizedBox(width: 14.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppStyles.bodySmall.copyWith(
                    color: Colors.grey,
                  ),
                ),

                SizedBox(height: 4.h),

                Text(
                  value.isEmpty ? "-" : value,
                  style: AppStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}