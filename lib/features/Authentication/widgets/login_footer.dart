import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_string.dart';
import '../../../constants/app_styles.dart';

class LoginFooter extends StatelessWidget {
  const LoginFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12.w,
        vertical: 18.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .55),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: .40),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: FooterItem(
              icon: 'assets/icons/login/secureData.svg',
              title: AppStrings.secureData,
            ),
          ),
          Expanded(
            child: FooterItem(
              icon: 'assets/icons/login/roleBased.svg',
              title: AppStrings.roleBasedAccess,
            ),
          ),
          Expanded(
            child: FooterItem(
              icon: 'assets/icons/login/anyWhere.svg',
              title: AppStrings.anywhereAccess,
            ),
          ),
          Expanded(
            child: FooterItem(
              icon: 'assets/icons/login/workForce.svg',
              title: AppStrings.smarterWorkforce,
            ),
          ),
        ],
      ),
    );
  }
}

class FooterItem extends StatelessWidget {
  final String icon;
  final String title;

  const FooterItem({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset(
          icon,
          width: 26.w,
          height: 26.h,
          colorFilter: const ColorFilter.mode(
            AppColors.primaryColor,
            BlendMode.srcIn,
          ),
        ),

        SizedBox(height: 10.h),

        Text(
          title,
          textAlign: TextAlign.center,
          style: AppStyles.bodySmall.copyWith(
            color: AppColors.textColor,
            fontSize: 10.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}