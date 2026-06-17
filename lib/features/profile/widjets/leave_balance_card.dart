import 'package:clams/constants/app_colors.dart';
import 'package:clams/constants/app_padding.dart';
import 'package:clams/constants/app_styles.dart';
import 'package:clams/features/profile/models/model_leaveBalance.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LeaveBalanceCard extends StatelessWidget {
  const LeaveBalanceCard({
    super.key,
    required this.leaveBalances,
  });

  final List<LeaveBalanceData> leaveBalances;


  @override
  Widget build(BuildContext context) {
    Color _color(String type) {
      switch (type.toLowerCase()) {
        case "eligiblecasual":
          return AppColors.casualLeave;

        case "eligiblesick":
          return AppColors.sickLeave;

        case "eligibleearned":
          return AppColors.earnedLeave;

        case "eligiblecompensatory":
          return AppColors.compensatoryOff;

        case "saturdayoff":
          return AppColors.saturdayOff;

        default:
          return AppColors.primaryColor;
      }
    }
    void showLeaveBalanceDialog(
        BuildContext context,
        List<LeaveBalanceData> leaveBalances,
        ) {
      showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text(
              "Leave Balance",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: leaveBalances.length,
                itemBuilder: (_, index) {
                  final leave = leaveBalances[index];
                  final color = _color(leave.leaveType);

                  return ListTile(
                    dense: true,

                    leading: CircleAvatar(
                      radius: 10,
                      backgroundColor: color,
                    ),

                    title: Text(
                      leave.leaveType,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Employee Code : ${leave.employeeCode}",
                          style: const TextStyle(fontSize: 11),
                        )
                      ],
                    ),

                    trailing: Text(
                      leave.leaveBalance.toStringAsFixed(2),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Close"),
              ),
            ],
          );
        },
      );
    }
    final visibleLeaves = leaveBalances
        .where((leave) => leave.leaveBalance > 0)
        .toList();
    return Container(
      margin: AppPadding.horizontalMedium.copyWith(top: 12.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: AppColors.primarySecondary,
        ),
      ),
      child: Stack(
        alignment: AlignmentGeometry.topRight,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Leave Balance",
                style: AppStyles.heading4,
              ),

              SizedBox(height: 18.h),

              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: visibleLeaves.length,
                separatorBuilder: (_, __) => SizedBox(height: 12.h),
                itemBuilder: (_, index) {
                  final visibleLeaves = leaveBalances
                      .where((leave) => leave.leaveBalance > 0)
                      .toList();
                  return _LeaveTile(
                    leave: visibleLeaves[index],
                  );
                },
              ),
            ],
          ),
          InkWell(
            borderRadius: BorderRadius.circular(8.r),
            onTap: () => showLeaveBalanceDialog(context,leaveBalances),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 6.w,
                vertical: 4.h,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 16.sp,
                    color: AppColors.primaryColor,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    'More',
                    style: AppStyles.bodyMedium.copyWith(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LeaveTile extends StatelessWidget {
  const _LeaveTile({
    required this.leave,
  });

  final LeaveBalanceData leave;

  @override
  Widget build(BuildContext context) {
    final color = _color(leave.leaveType);

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: color.withOpacity(.08),
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: color.withOpacity(.35),
              width: 1.2,
            ),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 4.h,
            ),

            leading: CircleAvatar(
              radius: 20.r,
              backgroundColor: color.withOpacity(.15),
              child: Icon(
                _icon(leave.leaveType),
                color: color,
                size: 20.sp,
              ),
            ),

            title: Text(
              leave.leaveType,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),

            subtitle: Text(
              "Available Balance",
              style: AppStyles.bodySmall.copyWith(
                color: Colors.grey,
              ),
            ),

            trailing: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  leave.leaveBalance.toStringAsFixed(0),
                  style: AppStyles.heading4.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Days",
                  style: AppStyles.bodySmall.copyWith(
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }


  IconData _icon(String type) {
    switch (type.toLowerCase()) {
      case "eligiblecasual":
        return Icons.beach_access_rounded;

      case "eligiblesick":
        return Icons.medical_services_rounded;

      case "eligibleearned":
        return Icons.star_rounded;

      case "eligiblecompensatory":
        return Icons.event_available_rounded;

      case "saturdayoff":
        return Icons.calendar_month_rounded;

      default:
        return Icons.event_available_rounded;
    }
  }

  Color _color(String type) {
    switch (type.toLowerCase()) {
      case "eligiblecasual":
        return AppColors.casualLeave;

      case "eligiblesick":
        return AppColors.sickLeave;

      case "eligibleearned":
        return AppColors.earnedLeave;

      case "eligiblecompensatory":
        return AppColors.compensatoryOff;

      case "saturdayoff":
        return AppColors.saturdayOff;

      default:
        return AppColors.primaryColor;
    }
  }

}