import 'package:clams/constants/app_colors.dart';
import 'package:clams/constants/app_padding.dart';
import 'package:clams/constants/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ApprovalCenterCard extends StatelessWidget {
  const ApprovalCenterCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPadding.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Approval Center',
                style: AppStyles.heading4,
              ),
              const Spacer(),
              Container(
                height: 24.h,
                width: 24.w,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFEBEE),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '10',
                  style: AppStyles.bodySmall.copyWith(
                    color: AppColors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 20.h),

          Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceAround,
            children: const [
              ApprovalMenuItem(
                title: 'Leave',
                icon: Icons.beach_access,
                backgroundColor: Color(0xFFE8F5E9),
                iconColor: Colors.green,
                showNotification: true,
              ),
              ApprovalMenuItem(
                title: 'Movement',
                icon: Icons.directions_walk,
                backgroundColor: Color(0xFFFFEBEE),
                iconColor: Colors.red,
                showNotification: true,
              ),
              ApprovalMenuItem(
                title: 'Travel',
                icon: Icons.flight,
                backgroundColor: Color(0xFFE8F0FE),
                iconColor: AppColors.primaryColor,
                showNotification: true,
              ),
              ApprovalMenuItem(
                count: 10,
                title: 'Overtime',
                icon: Icons.more_time,
                backgroundColor: Color(0xFFE0F7FA),
                iconColor: AppColors.textColor,
                showNotification: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ApprovalMenuItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final bool showNotification;
  final int count;

  const ApprovalMenuItem({
    super.key,
    required this.title,
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
    this.showNotification = false,
    this.count = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: 52.h,
              width: 52.w,
              decoration: BoxDecoration(
                color: backgroundColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 26.sp,
              ),
            ),
            if (showNotification && count > 0)
              Positioned(
                right: -4,
                top: -4,
                child: Container(
                  constraints: BoxConstraints(
                    minWidth: 18.w,
                    minHeight: 18.h,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 4.w,
                  ),
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    count > 99 ? '99+' : count.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: 8.h),
        Text(
          title,
          style: AppStyles.bodySmall,
        ),
      ],
    );
  }
}