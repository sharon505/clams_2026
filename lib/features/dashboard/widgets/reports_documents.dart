import 'package:clams/constants/app_colors.dart';
import 'package:clams/constants/app_padding.dart';
import 'package:clams/constants/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReportsDocumentsCard extends StatelessWidget {
  const ReportsDocumentsCard({super.key});

  @override
  Widget build(BuildContext context) {
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
          Text('Reports & Documents', style: AppStyles.heading4),

          SizedBox(height: 20.h),

          Wrap(
            spacing: 22.w,
            runSpacing: 20.h,
            children: [
              ReportDocumentItem(
                title: 'Leave\nReport',
                icon: Icons.beach_access,
                backgroundColor: Color(0xFFE8F5E9),
                iconColor: Colors.green,
                onTap: () => Navigator.pushNamed(context, 'LeavesView'),
              ),
              ReportDocumentItem(
                title: 'Movement\nReport',
                icon: Icons.directions_walk,
                backgroundColor: Color(0xFFFFEBEE),
                iconColor: Colors.red,
              ),
              ReportDocumentItem(
                title: 'Travel\nReport',
                icon: Icons.flight,
                backgroundColor: Color(0xFFE8F0FE),
                iconColor: AppColors.primaryColor,
                onTap: () => Navigator.pushNamed(context, 'TravelView'),
              ),
              ReportDocumentItem(
                title: 'Overtime\nReport',
                icon: Icons.more_time,
                backgroundColor: Color(0xFFE0F7FA),
                iconColor: AppColors.textColor,
              ),
              ReportDocumentItem(
                title: 'Punching\nReport',
                icon: Icons.fingerprint,
                backgroundColor: Color(0xFFF3F4F6),
                iconColor: Colors.grey,
              ),
              ReportDocumentItem(
                title: 'Work\nRegistration',
                icon: Icons.work_outline,
                backgroundColor: Color(0xFFEDE7F6),
                iconColor: Colors.deepPurple,
              ),
              ReportDocumentItem(
                title: 'Salary Slip',
                icon: Icons.payments_outlined,
                backgroundColor: Color(0xFFFFF3E0),
                iconColor: Colors.deepOrange,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ReportDocumentItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final VoidCallback? onTap;

  const ReportDocumentItem({
    super.key,
    required this.title,
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60.w,
      child: InkWell(
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
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppStyles.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
