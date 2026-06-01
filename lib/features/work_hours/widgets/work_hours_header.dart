import 'package:clams/constants/app_colors.dart';
import 'package:clams/constants/app_string.dart';
import 'package:clams/constants/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WorkHoursHeader extends StatelessWidget {
  final String location;
  final bool isLoading;
  final String statusText;
  final Color badgeColor;
  final Color badgeBgColor;
  final IconData badgeIcon;

  const WorkHoursHeader({
    super.key,
    required this.location,
    required this.isLoading,
    required this.statusText,
    required this.badgeColor,
    required this.badgeBgColor,
    required this.badgeIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.todayWorkHours,
                style: AppStyles.heading4,
              ),
              SizedBox(height: 4.h),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 14.sp,
                    color: AppColors.primaryColor,
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Text(
                      isLoading
                          ? "Fetching location..."
                          : location,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppStyles.bodySmall.copyWith(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(width: 8.w),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 12.w,
            vertical: 6.h,
          ),
          decoration: BoxDecoration(
            color: badgeBgColor,
            borderRadius: BorderRadius.circular(30.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                badgeIcon,
                size: 14.sp,
                color: badgeColor,
              ),
              SizedBox(width: 5.w),
              Text(
                statusText,
                style: AppStyles.bodySmall.copyWith(
                  color: badgeColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}