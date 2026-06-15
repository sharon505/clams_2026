import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_padding.dart';
import '../../../constants/app_styles.dart';

class AttendanceMonthDetailsCard extends StatelessWidget {
  final List<AttendanceMonthDetail> details;

  const AttendanceMonthDetailsCard({
    super.key,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    if (details.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 0,
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.r),
        side: BorderSide(
          color: AppColors.primarySecondary,
        ),
      ),
      child: Padding(
        padding: AppPadding.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This Month Details',
              style: AppStyles.heading4.copyWith(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(height: 18.h),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: details.length,
              separatorBuilder: (_, __) => SizedBox(height: 18.h),
              itemBuilder: (context, index) {
                final item = details[index];

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 4.h),
                      width: 16.w,
                      height: 16.w,
                      decoration: BoxDecoration(
                        color: item.color,
                        shape: BoxShape.circle,
                        border: item.isBorder
                            ? Border.all(
                          color: AppColors.black,
                          width: 1.2,
                        )
                            : null,
                      ),
                    ),

                    SizedBox(width: 12.w),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: AppStyles.bodyMedium.copyWith(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          if (item.subtitle != null) ...[
                            SizedBox(height: 2.h),
                            Text(
                              item.subtitle!,
                              style: AppStyles.bodySmall.copyWith(
                                fontSize: 11.sp,
                                color: Colors.grey.shade600,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],

                          SizedBox(height: 4.h),

                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today_rounded,
                                size: 12.sp,
                                color: AppColors.primaryColor,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                item.date,
                                style: AppStyles.bodySmall.copyWith(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class AttendanceMonthDetail {
  final String title;
  final String? subtitle;
  final String date;
  final Color color;
  final bool isBorder;

  AttendanceMonthDetail({
    required this.title,
    this.subtitle,
    required this.date,
    required this.color,
    this.isBorder = false,
  });
}