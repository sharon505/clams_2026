import 'package:clams/constants/app_styles.dart';
import 'package:clams/features/Authentication/providers/auth_provider.dart';
import 'package:clams/features/profile/provider/employee_viewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../constants/app_colors.dart';
import '../models/travelRequisitionModel.dart';
import '../viewModels/apply_travel_requisition_viewModel.dart';
import '../viewModels/cancelTravelRequestViewModel.dart';
import '../viewModels/ccu_department_view_model.dart';
import '../viewModels/edit_ta_view_model.dart';
import '../viewModels/myTravelRequisitionViewModel.dart';
import '../viewModels/ta_details_view_model.dart';
import '../viewModels/travel_emp_details_view_model.dart';
import '../viewModels/travel_requisition_textfield_view_model.dart';
import '../viewModels/update_TA_view_model.dart';
import '../views/applyTravel_view.dart';
import '../views/travelView_view.dart';
import '../views/travel_details_page.dart';
import '../views/travel_extend_page.dart';

class TravelCard extends StatelessWidget {
  final TravelRequisitionRow row;
  final bool isPending;

  const TravelCard({super.key, required this.row, required this.isPending});

  /// 🎨 STATUS COLOR
  Color getStatusColor(String status) {
    final s = status.trim().toLowerCase();

    switch (s) {
      case "pending":
      case "pending crn":
      case "pending(extended)":
        return Colors.orange;

      case "completed":
      case "recommended to the ceo":
        return Colors.green;

      case "rejected by hod":
      case "rejected by ccu":
      case "work extend rejected":
        return Colors.red;

      case "deleted":
        return Colors.grey;

      case "ccu transfer":
        return Colors.blue;

      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = row.trStatus.trim().toLowerCase();
    final statusColor = getStatusColor(row.trStatus);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: AppColors.primarySecondary),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header
            Row(
              children: [
                Expanded(
                  child: Text(
                    row.employeeName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 15.sp,
                    ),
                  ),
                ),

                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(.1),
                    borderRadius: BorderRadius.circular(25.r),
                    border: Border.all(color: AppColors.success),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.verified,
                        size: 14.sp,
                        color: AppColors.success,
                      ),

                      SizedBox(width: 4.w),

                      Text(
                        row.trStatus,
                        style: AppStyles.bodySmall.copyWith(
                          color: AppColors.success,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // SizedBox(height: 12.h),

            /// Location
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 18.sp,
                  color: AppColors.textColor,
                ),

                SizedBox(width: 8.w),

                Expanded(
                  child: Text(row.trLocation, style: AppStyles.bodyMedium),
                ),
              ],
            ),

            SizedBox(height: 8.h),

            /// Date
            Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 17.sp,
                  color: AppColors.textColor,
                ),

                SizedBox(width: 8.w),

                Expanded(
                  child: Text(
                    "${formatTravelDate(row.trDepartureDate)}  →  ${formatTravelDate(row.trReturnDate)}",
                    style: AppStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 14.h),

            /// Actions
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: [
                _miniButton(
                  icon: Icons.add_circle_outline,
                  title: "Extension",
                  bg: const Color(0xffF4E8FF),
                  color: AppColors.officialDuty,
                    onTap: ()  {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (_) => TravelExtendPage(
                      //       travelId: row.trId.toString(),
                      //     ),
                      //   ),
                      // );
                    }
                ),

                _miniButton(
                  icon: Icons.description_outlined,
                  title: "View Details",
                  bg: Colors.grey.shade100,
                  color: Colors.grey.shade700,
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 🔵 EXTEND
  Widget _miniButton({
    required IconData icon,
    required String title,
    required Color bg,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(14.r),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: color.withOpacity(.25)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16.sp, color: color),

            SizedBox(width: 6.w),

            Text(
              title,
              style: AppStyles.bodySmall.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 👁 VIEW
  Widget _viewChip() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.description_outlined,
            size: 18.sp,
            color: Colors.grey.shade700,
          ),

          SizedBox(width: 6.w),

          Text(
            "View Details",
            style: TextStyle(
              color: Colors.grey.shade800,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
