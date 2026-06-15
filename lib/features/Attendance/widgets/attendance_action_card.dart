// //attendance_action_card
// import 'package:clams/constants/app_colors.dart';
// import 'package:clams/constants/app_padding.dart';
// import 'package:clams/constants/app_styles.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// class AttendanceActionCard extends StatelessWidget {
//   final bool showMovementButton;
//   final bool showOtButton;
//   final bool canShowActions;
//   final int lateMinutes;
//   final DateTime? selectedDay;
//
//
//   const AttendanceActionCard({
//     super.key,
//     required this.showMovementButton,
//     required this.showOtButton,
//     required this.canShowActions,
//     required this.lateMinutes,
//     required this.selectedDay,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     if (!canShowActions ||
//         (!showMovementButton && !showOtButton)) {
//       return const SizedBox.shrink();
//     }
//
//     return Card(
//       elevation: 0,
//       color: AppColors.white,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16.r),
//         side: BorderSide(
//           color: AppColors.primarySecondary,
//         ),
//       ),
//       child: Padding(
//         padding: AppPadding.cardPadding,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           spacing: 7.h,
//           children: [
//             Text(
//               'Available Actions',
//               style: AppStyles.heading4,
//             ),
//
//             Row(
//               children: [
//                 if (showOtButton)
//                   Expanded(
//                     child: ElevatedButton.icon(
//                       onPressed: () {
//                         Navigator.pushNamed(
//                           context,
//                           'ApplyOvertimeView',
//                           arguments: {
//                             'date': selectedDay,
//                           },
//                         );
//                       },
//                       icon: const Icon(Icons.timer_outlined),
//                       label: const Text('Apply OT'),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: AppColors.overtime,
//                         foregroundColor: AppColors.white,
//                         minimumSize: Size.fromHeight(46.h),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12.r),
//                         ),
//                       ),
//                     ),
//                   ),
//
//                 if (showOtButton && showMovementButton)
//                   SizedBox(width: 12.w),
//
//                 if (showMovementButton)
//                   Expanded(
//                     child: ElevatedButton.icon(
//                       onPressed: () {
//                         Navigator.pushNamed(
//                           context,
//                           'MovementApplyView',
//                           arguments: {
//                             'date': selectedDay,
//                             'lateMinutes': lateMinutes,
//                           },
//                         );
//                       },
//                       icon: const Icon(Icons.directions_walk),
//                       label: const Text('Movement'),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: AppColors.warning,
//                         foregroundColor: AppColors.white,
//                         minimumSize: Size.fromHeight(46.h),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12.r),
//                         ),
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//             SizedBox(
//               width: double.infinity,
//               child: OutlinedButton.icon(
//                 onPressed: () {
//                   Navigator.pushNamed(
//                     context,
//                     'ApplyLeave',
//                     arguments: {
//                       'date': selectedDay,
//                       'lateMinutes': lateMinutes,
//                     },
//                   );
//                 },
//                 icon: Icon(
//                   Icons.event_busy_outlined,
//                   color: AppColors.primaryColor,
//                 ),
//                 label: Text(
//                   'Apply Leave',
//                   style: AppStyles.bodyMedium.copyWith(
//                     color: AppColors.primaryColor,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 style: OutlinedButton.styleFrom(
//                   minimumSize: Size.fromHeight(46.h),
//                   side: BorderSide(
//                     color: AppColors.primaryColor,
//                   ),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12.r),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
