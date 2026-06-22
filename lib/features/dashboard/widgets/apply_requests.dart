import 'package:clams/constants/app_colors.dart';
import 'package:clams/constants/app_padding.dart';
import 'package:clams/constants/app_styles.dart';
import 'package:clams/features/Authentication/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ApplyRequestsCard extends StatelessWidget {
  const ApplyRequestsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final companyName = context.watch<AuthProvider>().companyName;
    return Container(
      width: double.infinity,
      padding: AppPadding.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Apply Requests', style: AppStyles.heading4),

          SizedBox(height: 20.h),

          Wrap(
            spacing: 22.w,
            runSpacing: 20.h,
            children: [
              ApplyRequestItem(
                title: 'Apply\nLeave',
                icon: Icons.beach_access,
                backgroundColor: Color(0xFFE8F5E9),
                iconColor: Colors.green,
                onTap: () => Navigator.pushNamed(context, 'ApplyLeave'),
              ),
              ApplyRequestItem(
                title: 'Apply\nMovement',
                icon: Icons.directions_walk,
                backgroundColor: Color(0xFFFFEBEE),
                iconColor: Colors.red,
                onTap: () => Navigator.pushNamed(context, 'ApplyMovement'),
              ),
              ApplyRequestItem(
                title: 'Apply\nTravel',
                icon: Icons.flight,
                backgroundColor: Color(0xFFE8F0FE),
                iconColor: AppColors.primaryColor,
              ),
              ApplyRequestItem(
                title: 'Apply\nOvertime',
                icon: Icons.more_time,
                backgroundColor: Color(0xFFE0F7FA),
                iconColor: AppColors.textColor,
              ),
              if (companyName == 'cij')
                ApplyRequestItem(
                  title: 'Work\nRegistration',
                  icon: Icons.work_outline,
                  backgroundColor: Color(0xFFEDE7F6),
                  iconColor: Colors.deepPurple,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class ApplyRequestItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final VoidCallback? onTap;

  const ApplyRequestItem({
    super.key,
    required this.title,
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(50.r),
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 52.h,
            width: 52.w,
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 26.sp),
          ),
          SizedBox(height: 8.h),
          SizedBox(
            width: 60.w,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: AppStyles.bodySmall,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}
