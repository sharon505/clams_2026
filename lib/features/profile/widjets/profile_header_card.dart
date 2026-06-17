import 'dart:typed_data';

import 'package:clams/constants/app_colors.dart';
import 'package:clams/constants/app_padding.dart';
import 'package:clams/constants/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileHeaderCard extends StatelessWidget {
  const ProfileHeaderCard({
    super.key,
    required this.name,
    required this.designation,
    required this.employeeCode,
    required this.department,
    required this.email,
    required this.mobile,
    this.image,
  });

  final String name;
  final String designation;
  final String employeeCode;
  final String department;
  final String email;
  final String mobile;
  final Uint8List? image;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: AppPadding.horizontalMedium.copyWith(top: 12.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: AppColors.primarySecondary,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          /// Header
          Row(
            children: [
              Container(
                width: 72.w,
                height: 72.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primarySecondary,
                  border: Border.all(
                    color: AppColors.white,
                    width: 3,
                  ),
                ),
                child: ClipOval(
                  child: image != null
                      ? Image.memory(
                    image!,
                    fit: BoxFit.cover,
                  )
                      : Icon(
                    Icons.person,
                    size: 34.sp,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),

              SizedBox(width: 14.w),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppStyles.heading4.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      designation,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppStyles.bodyMedium.copyWith(
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          Divider(
            color: Colors.grey.shade300,
            height: 1,
          ),

          SizedBox(height: 16.h),

          _infoTile(
            context,
            Icons.badge_outlined,
            "Employee Code",
            employeeCode,
          ),

          SizedBox(height: 12.h),

          _infoTile(
            context,
            Icons.business_outlined,
            "Department",
            department,
          ),

          SizedBox(height: 12.h),

          _infoTile(
            context,
            Icons.email_outlined,
            "Email",
            email,
            enableCopy: true,
          ),

          SizedBox(height: 12.h),

          _infoTile(
            context,
            Icons.phone_outlined,
            "Mobile",
            mobile,
            enableCopy: true,
          ),
        ],
      ),
    );
  }

  Widget _infoTile(
      BuildContext context,
      IconData icon,
      String title,
      String value, {
        bool enableCopy = false,
      }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20.sp,
          color: AppColors.primaryColor,
        ),

        SizedBox(width: 12.w),

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

              // SizedBox(height: 2.h),

              Row(
                children: [
                  Expanded(
                    child: Text(
                      value,
                      style: AppStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  if (enableCopy)
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: Icon(
                        Icons.copy_rounded,
                        size: 18.sp,
                        color: AppColors.primaryColor,
                      ),
                      onPressed: () async {
                        await Clipboard.setData(
                          ClipboardData(text: value),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "$title copied",
                            ),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}