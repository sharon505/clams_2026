import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_styles.dart';
import '../../Authentication/providers/auth_provider.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    final user = auth.userData;
    final Uint8List? profileImage = auth.profileImageBytes;

    return Row(
      spacing: 7.w,
      children: [
        CircleAvatar(
          radius: 23.r,
          backgroundColor: Colors.white,
          backgroundImage:
          profileImage != null ? MemoryImage(profileImage) : null,
          child: profileImage == null
              ? Padding(
            padding: EdgeInsets.all(10.r),
            child: SvgPicture.asset(
              'assets/icons/dashBord/User.svg',
              width: 24.w,
              height: 24.h,
            ),
          )
              : null,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                (user?.employeeName ?? 'User').split(' ').first,
                style: AppStyles.heading4,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                user?.designation ?? '',
                style: AppStyles.bodyMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),

        CircleAvatar(
          radius: 22.r,
          backgroundColor: Colors.white,
          child: IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(
              'assets/icons/dashBord/calendar.svg',
              width: 22.w,
              height: 22.h,
              colorFilter: const ColorFilter.mode(
                AppColors.primaryColor,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),

        CircleAvatar(
          radius: 22.r,
          backgroundColor: Colors.white,
          child: IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(
              'assets/icons/dashBord/menu.svg',
              width: 22.w,
              height: 22.h,
              colorFilter: const ColorFilter.mode(
                AppColors.primaryColor,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ],
    );
  }
}