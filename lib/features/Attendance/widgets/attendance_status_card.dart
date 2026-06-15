import 'package:clams/constants/app_colors.dart';
import 'package:clams/constants/app_styles.dart';
import 'package:clams/features/Attendance/widgets/action_button.dart';
import 'package:clams/features/Attendance/widgets/apply_leave_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AttendanceStatusCard extends StatelessWidget {
  final String status;
  final Color statusColor;
  final int lateMinutes;
  final bool isAbsent;
  final bool hasPunch;
  final Duration workedDuration;
  final bool canShowActions;
  final String punchInTime;
  final String punchOutTime;
  final VoidCallback? onApplyLeave;
  final String selectedDate;
  final bool showMovementButton;
  final bool showOtButton;
  final DateTime? selectedDay;
  final bool isHoliday;
  final bool isLeave;

  const AttendanceStatusCard({
    super.key,
    required this.status,
    required this.statusColor,
    required this.lateMinutes,
    required this.isAbsent,
    required this.hasPunch,
    required this.workedDuration,
    required this.canShowActions,
    required this.punchInTime,
    required this.selectedDate,
    this.onApplyLeave,
    required this.punchOutTime,
    required this.showMovementButton,
    required this.showOtButton,
    this.selectedDay,
    required this.isHoliday,
    required this.isLeave,
  });

  String _format(Duration d) {
    return '${d.inHours.toString().padLeft(2, '0')}h '
        '${d.inMinutes.remainder(60).toString().padLeft(2, '0')}m';
  }

  IconData _statusIcon(String status) {
    final text = status.toLowerCase();

    if (text.contains('casual')) {
      return Icons.event_available_rounded;
    }

    if (text.contains('sick')) {
      return Icons.local_hospital_rounded;
    }

    if (text.contains('earned')) {
      return Icons.workspace_premium_rounded;
    }

    if (text.contains('official')) {
      return Icons.work_history_rounded;
    }

    if (text.contains('loss') || text.contains('lop')) {
      return Icons.money_off_rounded;
    }

    if (text.contains('compensatory')) {
      return Icons.autorenew_rounded;
    }

    if (text.contains('maternity')) {
      return Icons.child_care_rounded;
    }

    if (text.contains('paternity')) {
      return Icons.family_restroom_rounded;
    }

    if (text.contains('bereavement')) {
      return Icons.favorite_border_rounded;
    }

    if (text.contains('marriage')) {
      return Icons.favorite_rounded;
    }

    if (text.contains('sterilization')) {
      return Icons.health_and_safety_rounded;
    }

    if (text.contains('saturday')) {
      return Icons.weekend_rounded;
    }

    if (text.contains('sunday')) {
      return Icons.beach_access_rounded;
    }

    if (text.contains('off day')) {
      return Icons.hotel_rounded;
    }

    return Icons.event_available_rounded;
  }

  String _statusDescription(String status) {
    final text = status.toLowerCase();

    if (text.contains('saturday')) {
      return 'Weekend holiday';
    }

    if (text.contains('sunday')) {
      return 'Weekend holiday';
    }

    if (text.contains('official')) {
      return 'Official duty assigned';
    }

    if (text.contains('off day')) {
      return 'Scheduled off day';
    }

    return 'Leave has been applied.';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black12,
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22.r),
        side: BorderSide(color: AppColors.primarySecondary),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  selectedDate,
                  style: AppStyles.heading4.copyWith(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),


                if (!isHoliday && !isLeave)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 5.h,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(.12),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 10.w,
                          height: 10.w,
                          decoration: BoxDecoration(
                            color: statusColor,
                            shape: BoxShape.circle,
                          ),
                        ),

                        SizedBox(width: 6.w),

                        Text(
                          status,
                          style: AppStyles.bodyMedium.copyWith(
                            color: statusColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),

            if (isHoliday)
              SizedBox(height: 10.h)
            else if (isLeave)
              SizedBox(height: 10.h)
            else
              SizedBox(height: 10.h),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// LEFT SIDE
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Holiday / Leave
                      if (isHoliday || isLeave) ...[
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 10.h,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(.12),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                _statusIcon(status),
                                color: statusColor,
                                size: 20.sp,
                              ),

                              SizedBox(width: 8.w),

                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      status,
                                      style: AppStyles.bodyLarge.copyWith(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w700,
                                        color: statusColor,
                                      ),
                                    ),

                                    Text(
                                      _statusDescription(status),
                                      // isHoliday
                                      //     ? 'No attendance required for this day.'
                                      //     : 'Leave has been applied.',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppStyles.bodySmall.copyWith(
                                        fontSize: 11.sp,
                                        color: Colors.grey,
                                        height: 1.2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ]

                      /// Present
                      else if (!isAbsent && hasPunch) ...[
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(6.r),
                              decoration: BoxDecoration(
                                color: AppColors.success.withOpacity(.12),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Icon(
                                Icons.login_rounded,
                                color: AppColors.success,
                                size: 16.sp,
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Punch In',
                                  style: AppStyles.bodySmall.copyWith(
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  punchInTime,
                                  style: AppStyles.bodyLarge.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        SizedBox(height: 12.h),

                        if (punchInTime != punchOutTime) ...[
                          SizedBox(height: 12.h),

                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(6.r),
                                decoration: BoxDecoration(
                                  color: AppColors.error.withOpacity(.12),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Icon(
                                  Icons.logout_rounded,
                                  color: AppColors.error,
                                  size: 16.sp,
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Punch Out',
                                    style: AppStyles.bodySmall.copyWith(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    punchOutTime,
                                    style: AppStyles.bodyLarge.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ],

                      if (!isHoliday &&
                          !isLeave &&
                          lateMinutes > 0) ...[
                        SizedBox(height: 14.h),
                        Row(
                          children: [
                            Icon(
                              Icons.warning_amber_rounded,
                              color: AppColors.warning,
                              size: 16.sp,
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              'Late by $lateMinutes min',
                              style: AppStyles.bodySmall.copyWith(
                                color: AppColors.warning,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                SizedBox(width: 16.w),

                /// RIGHT SIDE
                if (isHoliday || isLeave)
                  SizedBox()
                  // Container(
                  //   width: 120.w,
                  //   padding: EdgeInsets.symmetric(
                  //     vertical: 14.h,
                  //     horizontal: 12.w,
                  //   ),
                  //   decoration: BoxDecoration(
                  //     color: statusColor.withOpacity(.12),
                  //     borderRadius: BorderRadius.circular(14.r),
                  //   ),
                  //   child: Column(
                  //     children: [
                  //       Icon(
                  //         isHoliday
                  //             ? Icons.beach_access_rounded
                  //             : Icons.event_available_rounded,
                  //         color: statusColor,
                  //         size: 28.sp,
                  //       ),
                  //       SizedBox(height: 8.h),
                  //       Text(
                  //         isHoliday ? 'Holiday' : 'Leave',
                  //         style: AppStyles.bodySmall.copyWith(
                  //           color: Colors.grey,
                  //         ),
                  //       ),
                  //       SizedBox(height: 4.h),
                  //       Text(
                  //         status,
                  //         textAlign: TextAlign.center,
                  //         style: AppStyles.bodyMedium.copyWith(
                  //           fontWeight: FontWeight.w700,
                  //           color: statusColor,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // )

                else if (isAbsent)
                  SizedBox(
                    width: 130.w,
                    child: canShowActions
                        ? ApplyLeaveButton(
                      onPressed: onApplyLeave ?? () {},
                    )
                        : const SizedBox.shrink(),
                  )

                else
                  Container(
                    width: 120.w,
                    padding: EdgeInsets.symmetric(
                      vertical: 14.h,
                      horizontal: 12.w,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primarySecondary,
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.schedule_rounded,
                          color: AppColors.primaryColor,
                          size: 24.sp,
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Worked Hours',
                          textAlign: TextAlign.center,
                          style: AppStyles.bodySmall.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          hasPunch ? _format(workedDuration) : '--',
                          style: AppStyles.heading4.copyWith(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            if (!isHoliday &&
                !isLeave &&
                !isAbsent &&
                canShowActions &&
                (showMovementButton || showOtButton)) ...[
              SizedBox(height: 14.h),

              Divider(
                color: AppColors.primarySecondary,
              ),

              SizedBox(height: 14.h),

              Row(
                children: [
                  if (showOtButton)
                    Expanded(
                      child: ActionButton(
                        title: 'Apply OT',
                        backgroundColor: AppColors.overtime,
                        icon: Icons.timer_outlined,
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            'ApplyOvertimeView',
                            arguments: {
                              'date': selectedDay,
                            },
                          );
                        },
                      ),
                    ),

                  if (showOtButton && showMovementButton)
                    SizedBox(width: 10.w),

                  if (showMovementButton)
                    Expanded(
                      child: ActionButton(
                        title: 'Movement',
                        backgroundColor: AppColors.warning,
                        icon: Icons.directions_walk,
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            'MovementApplyView',
                            arguments: {
                              'date': selectedDay,
                              'lateMinutes': lateMinutes,
                            },
                          );
                        },
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
