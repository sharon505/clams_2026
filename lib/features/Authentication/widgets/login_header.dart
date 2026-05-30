import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_string.dart';
import '../../../constants/app_styles.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 60.h),

        SvgPicture.asset(
          'assets/icons/login/appIcon.svg',
          height: 90.h,
          fit: BoxFit.contain,
        ),

        SizedBox(height: 12.h),

        Text(
          'CLAMS',
          style: AppStyles.heading1.copyWith(
            fontSize: 42.sp,
            color: AppColors.primaryColor,
            fontWeight: FontWeight.w700,
          ),
        ),

        SizedBox(height: 6.h),

        Text(
          AppStrings.makingAttendanceEffortless,
          style: AppStyles.bodySmall.copyWith(
            color: AppColors.textColor,
          ),
        ),

        SizedBox(height: 28.h),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const [
            _HeaderMenuItem(
              icon: 'assets/icons/login/attendance.svg',
              title: AppStrings.attendance,
            ),
            _HeaderMenuItem(
              icon: 'assets/icons/login/reports.svg',
              title: AppStrings.reports,
            ),
            _HeaderMenuItem(
              icon: 'assets/icons/login/performance.svg',
              title: AppStrings.performance,
            ),
            _HeaderMenuItem(
              icon: 'assets/icons/login/payroll.svg',
              title: AppStrings.payroll,
            ),
          ],
        ),

        SizedBox(height: 30.h),
      ],
    );
  }
}

class _HeaderMenuItem extends StatelessWidget {
  final String icon;
  final String title;

  const _HeaderMenuItem({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 58.w,
          height: 58.w,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .9),
            shape: BoxShape.circle,
          ),
          child: Padding(
            padding: EdgeInsets.all(15.r),
            child: SvgPicture.asset(
              icon,
              colorFilter: const ColorFilter.mode(
                AppColors.primaryColor,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          title,
          style: TextStyle(
            fontSize: 9.sp,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}