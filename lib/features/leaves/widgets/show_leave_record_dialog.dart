import 'package:clams/constants/app_colors.dart';
import 'package:clams/constants/app_padding.dart';
import 'package:clams/constants/app_styles.dart';
import 'package:clams/features/leaves/models/model_leaveSummery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


Future<void> showLeaveRecordDialog({
  required BuildContext context,
  required LeaveRecord data,
}) {
  final fromDate = data.fromDate;
  final toDate = data.toDate;
  final leaveType = data.leaveType;
  final status = data.status;
  final appliedTo = data.appliedTo;
  final isHalfDay = data.isHalfDay;

  final leaveSection =
  (data.leaveSection.isNotEmpty)
      ? data.leaveSection
      : (isHalfDay ? 'Half Day' : 'Full Day');

  final noOfDays = (data.noOfDays as num?)?.toDouble() ?? 0.0;

  final updatedDate = data.updatedDate.toString();
  final appliedDate = data.appliedDate.toString();
  final leaveReason = data.leaveReason.trim();
  final rejectedReason = data.rejectedReason;

  return showDialog(
    context: context,
    builder: (_) => Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
              Row(
                spacing: 10.w,
                children: [
                  Card(
                    color: AppColors.primaryBg,
                    child: Padding(
                      padding: AppPadding.allSmall,
                      child: Icon(Icons.event_note, color: AppColors.white),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Leave Details'.toUpperCase(),
                      style: AppStyles.heading3
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Padding(
                      padding: AppPadding.allSmall,
                      child: Icon(Icons.close, color: AppColors.error),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // CHIPS
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _chip(leaveType, AppColors.primaryColor, Colors.black87),
                  _chip(status, _statusBg(status), _statusText(status)),
                  _chip(
                    isHalfDay ? 'Half Day' : 'Full Day',
                    isHalfDay ? AppColors.textColor : AppColors.success,
                    Colors.white,
                  ),
                ],
              ),

              const SizedBox(height: 12),
              Divider(color: AppColors.textColor),

              // FIELDS
              _row(icon: Icons.calendar_today, label: 'From', value: fromDate),
              _row(icon: Icons.calendar_today, label: 'To', value: toDate),
              _row(icon: Icons.timelapse, label: 'Days', value: noOfDays.toString()),
              _row(icon: Icons.access_time, label: 'Section', value: leaveSection),
              _row(icon: Icons.send, label: 'Applied To', value: appliedTo),
              _row(icon: Icons.edit_calendar, label: 'Applied Date', value: appliedDate),
              if(updatedDate!="null")
                _row(icon: Icons.update, label: 'Approved Date', value: updatedDate),

              if (leaveReason.isNotEmpty)
                _row(icon: Icons.notes, label: 'Reason', value: leaveReason),

              if (rejectedReason.isNotEmpty)
                _row(icon: Icons.error_outline, label: 'Rejected Reason', value: rejectedReason),

              const SizedBox(height: 16),

              // ACTION BUTTONS
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.black,
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Text('CLOSE'),
                  ),
                  SizedBox(width: 8.w),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Card(
                      color: AppColors.primaryBg,
                      child: Padding(
                        padding: AppPadding.allSmall,
                        child: Text(
                          'OK',
                          style: AppStyles.heading1.copyWith(
                            fontSize: 15.sp,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

// --------------------------------------------------------------------------
// HELPERS
// --------------------------------------------------------------------------

Widget _chip(String text, Color bg, Color fg) {
  return Card(
    color: bg,
    child: Padding(
      padding: AppPadding.allSmall,
      child: Text(
        text.toUpperCase(),
        style: AppStyles.heading2.copyWith(color: fg, fontSize: 10.sp),
      ),
    ),
  );
}

Color _statusBg(String status) {
  switch (status.toLowerCase()) {
    case 'approved':
      return AppColors.success;
    case 'rejected':
      return AppColors.error;
    default:
      return AppColors.warning;
  }
}

Color _statusText(String status) {
  switch (status.toLowerCase()) {
    case 'approved':
      return Colors.green.shade900;
    case 'rejected':
      return Colors.red.shade900;
    default:
      return Colors.orange.shade900;
  }
}

Widget _row({
  required IconData icon,
  required String label,
  required String value,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 6.h),
    child: Row(
      spacing: 5.w,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Card(
          color: AppColors.primaryBg,
          child: Padding(
            padding: AppPadding.allSmall,
            child: Icon(icon, size: 18.sp, color: AppColors.white),
          ),
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(fontSize: 14.sp, color: Colors.black87),
              children: [
                TextSpan(
                  text: '${label.toUpperCase()}:  ',
                  style: AppStyles.heading1.copyWith(
                    fontSize: 15.sp,
                    color: AppColors.black,
                  ),
                ),
                TextSpan(
                  text: value.toUpperCase(),
                  style: AppStyles.bodyLarge.copyWith(fontSize: 15.sp),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
