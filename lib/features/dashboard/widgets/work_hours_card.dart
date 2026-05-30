import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../constants/app_colors.dart';
import '../../../../constants/app_styles.dart';

class WorkHoursCard extends StatelessWidget {
  final String location;
  final String workedHours;
  final String remainingHours;
  final String checkInTime;
  final String overtime;
  final int completedPercentage;
  final bool isWorking;

  const WorkHoursCard({
    super.key,
    required this.location,
    required this.workedHours,
    required this.remainingHours,
    required this.checkInTime,
    required this.overtime,
    required this.completedPercentage,
    this.isWorking = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.fromLTRB(
      //   16.w,
      //   0,
      //   16.w,
      //   16.h,
      // ),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Today Work Hours",
                style: AppStyles.heading4,
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                  vertical: 6.h,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xffEDF3FF),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.hourglass_bottom,
                      size: 14.sp,
                      color: AppColors.primaryColor,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      isWorking ? "In Progress" : "Completed",
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.textColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 10.h),

          /// Location
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                color: AppColors.primaryColor,
                size: 18.sp,
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Text(
                  location,
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 13.sp,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 18.h),

          /// Stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _statItem(
                icon: Icons.access_time,
                title: "Worked",
                value: workedHours,
              ),
              Column(
                children: [
                  Text(
                    "$completedPercentage%",
                    style: TextStyle(
                      fontSize: 30.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  Text(
                    "Completed",
                    style: TextStyle(
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
              _statItem(
                icon: Icons.access_time,
                title: "Remaining",
                value: remainingHours,
              ),
            ],
          ),

          SizedBox(height: 16.h),

          /// Progress
          ClipRRect(
            borderRadius: BorderRadius.circular(20.r),
            child: LinearProgressIndicator(
              value: completedPercentage / 100,
              minHeight: 8.h,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation(
                AppColors.primaryColor,
              ),
            ),
          ),

          SizedBox(height: 18.h),

          /// Bottom Cards
          Row(
            children: [
              Expanded(
                child: _bottomCard(
                  backgroundColor: const Color(0xffEFF8F0),
                  icon: Icons.fingerprint,
                  iconColor: Colors.green,
                  title: "Check-In",
                  value: checkInTime,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: _bottomCard(
                  backgroundColor: const Color(0xffEEF4FB),
                  icon: Icons.av_timer,
                  iconColor: Colors.blueGrey,
                  title: "Overtime",
                  value: overtime,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          size: 18.sp,
          color: Colors.grey,
        ),
        SizedBox(height: 4.h),
        Text(
          title,
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _bottomCard({
    required Color backgroundColor,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 14.h,
        horizontal: 12.w,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 28.sp,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey.shade700,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
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