import 'package:clams/constants/app_colors.dart';
import 'package:clams/constants/app_styles.dart';
import 'package:clams/features/leaves/models/model_leaveSummery.dart';
import 'package:clams/features/leaves/providers/LeaveFilter_viewModel.dart';
import 'package:clams/features/leaves/providers/leaveCancel_viewModel.dart';
import 'package:clams/features/leaves/providers/leaveSummary_viewModel.dart';
import 'package:clams/features/leaves/widgets/leave_summary_card.dart';
import 'package:clams/features/leaves/widgets/show_leave_record_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

///////////////////////////////////////////////////////////////////////////////
/// MAIN WIDGET
///////////////////////////////////////////////////////////////////////////////
Widget leaveSummeryWidget({
  required BuildContext context,
  String? heading,
  bool? disableTitle,
  bool enableEmptyText = false,

  /// HomeView uses pending: true
  bool? pending,
}) {
  return Consumer3<LeaveSummaryProvider, LeaveCancelProvider, LeaveFilterProvider>(
    builder: (context, summaryP, cancelP, filterP, child) {
      if (summaryP.isLoading) return const SizedBox();

      // RAW LIST
      List<LeaveRecord> list = summaryP.response?.table1 ?? [];

      ////////////////////////////////////////////////////////////////////////////
      /// 1. HOME VIEW → Pending Only
      ////////////////////////////////////////////////////////////////////////////
      if (pending == true) {
        list = list.where((item) => item.status.toLowerCase() == 'pending').toList();
      }
      ////////////////////////////////////////////////////////////////////////////
      /// 2. DATE RANGE FILTER
      ////////////////////////////////////////////////////////////////////////////
      DateTimeRange? range = filterP.dateRange;

      if (range != null) {
        list = list.where((item) {
          try {
            final from = DateFormat("dd/MM/yyyy").parse(item.fromDate);
            final to = DateFormat("dd/MM/yyyy").parse(item.toDate);

            final start = DateTime(range.start.year, range.start.month, range.start.day);
            final end = DateTime(range.end.year, range.end.month, range.end.day, 23, 59);

            return (from.isAfter(start) || from.isAtSameMomentAs(start)) &&
                (to.isBefore(end) || to.isAtSameMomentAs(end));
          } catch (_) {
            return false;
          }
        }).toList();
      }

      ////////////////////////////////////////////////////////////////////////////
      /// 3. STATUS FILTER (LeavesView)
      ////////////////////////////////////////////////////////////////////////////
      switch (filterP.filter) {
        case LeaveFilter.pending:
          list = list.where((item) => item.status.toLowerCase() == 'pending').toList();
          break;

        case LeaveFilter.approved:
          list = list.where((item) => item.status.toLowerCase() == 'approved').toList();
          break;

        case LeaveFilter.cancelled:
          list = list.where((item) => item.status.toLowerCase() == 'cancelled').toList();
          break;

        case LeaveFilter.byDate:
          break;

        case LeaveFilter.all:
        default:
          break;
      }

      ////////////////////////////////////////////////////////////////////////////
      /// 4. LEAVE TYPE FILTER (Earned, Sick, Casual…)
      ////////////////////////////////////////////////////////////////////////////
      final typeFilter = filterP.leaveTypeFilter;

      if (typeFilter != null && typeFilter.trim().isNotEmpty) {
        list = list.where((item) {
          final type = (item.leaveType ?? "").trim().toLowerCase();
          return type == typeFilter.trim().toLowerCase();
        }).toList();
      }

      ////////////////////////////////////////////////////////////////////////////
      /// 5. SORTING (Latest, Oldest, Shortest Duration, Longest Duration)
      ////////////////////////////////////////////////////////////////////////////
      switch (filterP.sort) {
        case LeaveSort.latestFirst:
          list.sort((a, b) {
            final da = _parse(a.appliedDate);
            final db = _parse(b.appliedDate);
            return db.compareTo(da); // Newest first
          });
          break;

        case LeaveSort.oldestFirst:
          list.sort((a, b) {
            final da = _parse(a.appliedDate);
            final db = _parse(b.appliedDate);
            return da.compareTo(db); // Oldest first
          });
          break;

        case LeaveSort.shortest:
          list.sort((a, b) {
            return _duration(a).compareTo(_duration(b)); // shortest first
          });
          break;

        case LeaveSort.longest:
          list.sort((a, b) {
            return _duration(b).compareTo(_duration(a)); // longest first
          });
          break;

        case LeaveSort.none:
        default:
          break;
      }

      ////////////////////////////////////////////////////////////////////////////
      /// EMPTY LIST UI
      ////////////////////////////////////////////////////////////////////////////
      if (list.isEmpty) {
        if (!enableEmptyText) return const SizedBox.shrink();

        return Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 100.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.inbox_outlined,
                  size: 60.sp,
                  color: Colors.grey,
                ),
                SizedBox(height: 12.h),
                Text(
                  "No Leave Records Found",
                  style: AppStyles.heading1.copyWith(
                    fontSize: 16.sp,
                    color: Colors.grey.shade700,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  "Your leave requests will appear here",
                  style: AppStyles.bodyLarge.copyWith(
                    fontSize: 13.sp,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        );
      }

      ////////////////////////////////////////////////////////////////////////////
      /// MAIN UI
      ////////////////////////////////////////////////////////////////////////////
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // if (disableTitle != true)
          //   text(text: heading ?? 'My Leave Request'),

          ...List.generate(list.length, (index) {
            final item = list[index];
            final canCancel = item.status.toLowerCase() == 'pending';

            return LeaveSummaryCard(
              leaveType: item.leaveType,
              status: item.status,

              appliedDate: _format(item.appliedDate),

              statusDate: item.updatedDate != null &&
                  item.updatedDate!.isNotEmpty
                  ? _format(item.updatedDate)
                  : "-",

              approvedBy: item.appliedTo,

              days: item.noOfDays == 1
                  ? "1 Day"
                  : "${item.noOfDays.toStringAsFixed(0)} Days",

              showDelete: canCancel,

              deleting: cancelP.isCancelling,

              onDelete: () => _onDelete(
                context,
                cancelP,
                summaryP,
                item,
              ),

              onTap: () => showLeaveRecordDialog(
                context: context,
                data: item,
              ),
            );
          }),

          SizedBox(height: 70.h),
        ],
      );
    },
  );
}

///////////////////////////////////////////////////////////////////////////////
/// DELETE HANDLER
///////////////////////////////////////////////////////////////////////////////
Future<void> _onDelete(
    BuildContext context,
    LeaveCancelProvider cancelP,
    LeaveSummaryProvider summaryP,
    LeaveRecord item) async {

  // dialog(
  //   context: context,
  //   name: "Confirm Leave Cancellation",
  //   designation: "Are you sure?",
  //   departmentName: "This will cancel your leave request.",
  //   btnOkColor: Colors.orange,
  //   dialogType: DialogType.warning,
  //   btnOkOnPress: () async {
  //     final ok = await cancelP.cancel(context: context, leaveId: item.leaveId);
  //
  //     final msg = cancelP.lastResponse?.result.first.msg ??
  //         (ok ? "Leave cancelled successfully" : "Please try again.");
  //
  //     // dialog(
  //     //   context: context,
  //     //   name: ok ? "Leave Cancelled" : "Failed",
  //     //   designation: msg,
  //     //   departmentName: ok
  //     //       ? "Your leave was cancelled."
  //     //       : "Something went wrong.",
  //     //   btnOkColor: ok ? Colors.green : Colors.red,
  //     //   dialogType: ok ? DialogType.success : DialogType.error,
  //     //   btnOkOnPress: () => summaryP.load(context: context),
  //     // );
  //   },
  // );
}

///////////////////////////////////////////////////////////////////////////////
/// SUMMARY CARD
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
/// HELPERS
///////////////////////////////////////////////////////////////////////////////
DateTime _parse(String? d) {
  try {
    return DateFormat("dd/MM/yyyy").parse(d ?? "");
  } catch (_) {
    return DateTime(2000);
  }
}

int _duration(LeaveRecord r) {
  try {
    final f = DateFormat("dd/MM/yyyy").parse(r.fromDate);
    final t = DateFormat("dd/MM/yyyy").parse(r.toDate);
    return t.difference(f).inDays + 1;
  } catch (_) {
    return 1;
  }
}

String _format(String? date) {
  try {
    final parsed = DateFormat('dd/MM/yyyy').parse(date ?? "");
    return DateFormat('MMMM d, yyyy').format(parsed);
  } catch (_) {
    return date ?? "";
  }
}

Widget _statusPill(String status) {
  late Color bg;
  late Color fg;

  switch (status) {
    case 'approved':
      bg = Colors.greenAccent.withOpacity(0.35);
      fg = Colors.green.shade800;
      break;
    case 'cancelled':
    case 'rejected':
      bg = Colors.redAccent.withOpacity(0.25);
      fg = Colors.red.shade700;
      break;
    default: // pending
      bg = AppColors.primaryColor.withOpacity(0.25);
      fg = AppColors.textColor;
  }

  return Container(
    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
    decoration: BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      status.toUpperCase(),
      style: TextStyle(
        color: fg,
        fontSize: 11.sp,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.6,
      ),
    ),
  );
}

Widget _deleteIcon({
  required bool disabled,
  required bool loading,
  VoidCallback? onTap,
}) {
  return Opacity(
    opacity: disabled ? 0.4 : 1,
    child: InkWell(
      onTap: disabled || loading ? null : onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: Colors.redAccent.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: loading
            ? SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.red,
          ),
        )
            : Icon(Icons.delete, size: 18.sp, color: Colors.red),
      ),
    ),
  );
}

Widget _arrowIcon(VoidCallback? onTap) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(12),
    child: Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        Icons.arrow_forward_ios,
        size: 16.sp,
        color: Colors.black87,
      ),
    ),
  );
}



class CustomIconButton extends StatelessWidget {
  final VoidCallback? onTap;
  final IconData icon;
  final Color? color;
  final double? size;
  final EdgeInsetsGeometry? padding;

  const CustomIconButton({
    super.key,
    this.onTap,
    required this.icon,
    this.color,
    this.size,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? () {},
      borderRadius: BorderRadius.circular(5),
      child: Container(
        padding: padding ?? EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: color ?? Colors.black12,
        ),
        child: Icon(icon, size: size ?? 15.sp, color: AppColors.black),
      ),
    );
  }
}
