import 'package:clams/constants/app_colors.dart';
import 'package:clams/constants/app_padding.dart';
import 'package:clams/constants/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmploymentDetailsCard extends StatelessWidget {
  const EmploymentDetailsCard({
    super.key,
    required this.designation,
    required this.department,
    required this.location,
    required this.officePhone,
    required this.extension,
    required this.employmentType,
    required this.dateOfJoining,
    required this.reportingTo,
  });

  final String designation;
  final String department;
  final String location;
  final String officePhone;
  final String extension;
  final String employmentType;
  final String dateOfJoining;
  final String reportingTo;

  @override
  Widget build(BuildContext context) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Employment Details",
            style: AppStyles.heading4,
          ),

          SizedBox(height: 18.h),

          _item(
            context,
            Icons.work_outline,
            "Designation",
            designation,
          ),

          _item(
            context,
            Icons.business_outlined,
            "Department",
            department,
          ),

          _item(
            context,
            Icons.location_on_outlined,
            "Location",
            location,
          ),

          _item(
            context,
            Icons.phone_in_talk_outlined,
            "Office Phone",
            officePhone,
            enableCopy: true,
          ),

          _item(
            context,
            Icons.call_outlined,
            "Extension",
            extension,
            enableCopy: true,
          ),

          _item(
            context,
            Icons.badge_outlined,
            "Employment Type",
            employmentType,
          ),

          _item(
            context,
            Icons.calendar_today_outlined,
            "Date of Joining",
            dateOfJoining,
          ),

          _item(
            context,
            Icons.assignment_ind_outlined,
            "Reporting To",
            reportingTo,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _item(
      BuildContext context,
      IconData icon,
      String title,
      String value, {
        bool isLast = false,
        bool enableCopy = false,
      }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 18.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42.w,
            height: 42.w,
            decoration: BoxDecoration(
              color: AppColors.primarySecondary.withOpacity(.5),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppColors.textColor,
              size: 20.sp,
            ),
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

                SizedBox(height: 2.h),

                Row(
                  children: [
                    Expanded(
                      child: Text(
                        value,
                        style: AppStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    if (enableCopy)
                      InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () async {
                          await Clipboard.setData(
                            ClipboardData(text: value),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("$title copied"),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Icon(
                            Icons.copy_rounded,
                            size: 18.sp,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}