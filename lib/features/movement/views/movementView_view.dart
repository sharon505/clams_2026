import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../constants/app_colors.dart';
import '../../../../constants/app_styles.dart';
import '../../../constants/app_appBar.dart';
import '../../authentication/views/widgets/awesome_dialogWidget.dart';
import '../models/viewMovement_model.dart';
import '../viewmodel/cancelMovment_viewModel.dart';
import '../viewmodel/movementView_viewModel.dart';


class MovementViewView extends StatefulWidget {
  const MovementViewView({super.key});

  @override
  State<MovementViewView> createState() => _MovementViewViewState();
}

class _MovementViewViewState extends State<MovementViewView> {
  final List<String> statusList = [
    "All",         // Index 0 -> StatusId 0
    "Pending",     // Index 1 -> StatusId 1
    "Approved",    // Index 2 -> StatusId 2
    "Cancelled",   // Index 3 -> StatusId 3
    "Rejected",    // Index 4 -> StatusId 4
    "Recommended", // Index 5 -> StatusId 5
  ];

  Future<void> _pickDateRange(BuildContext context) async {
    final vm = context.read<MovementReportProvider>();

    final picked = await showDateRangePicker(
      context: context,
      initialDateRange: (vm.fromDate != null && vm.toDate != null)
          ? DateTimeRange(start: vm.fromDate!, end: vm.toDate!)
          : null,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      vm.setDateRange(picked);
      // Ensure widget is still mounted before using context across an async gap
      if (!mounted) return;
      await vm.fetchReports(context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MovementReportProvider>();

    return Scaffold(
      // Keep AppBar strictly structural to eliminate constraints and size crashes
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.h),
        child: commonAppBar(context, title: 'Movement Report'),
      ),
      body: Column(
        children: [
          // Filter Panel: Safely placed at the top of the body Column
          Container(
            color: AppColors.primary,
            padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 14.h),
            child: Row(
              children: [
                /// Dropdown takes remaining flexible width safely
                Expanded(
                  child: DropdownButtonFormField<int>(
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.all(Radius.circular(10)).r,
                      ),
                      labelText: "Status",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)).r,
                      ),
                      labelStyle: TextStyle(color: Colors.white, fontSize: 14.sp),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                    ),
                    value: vm.statusIndex ?? 0,
                    dropdownColor: Colors.black87,
                    iconEnabledColor: Colors.white,
                    style: TextStyle(color: Colors.white, fontSize: 14.sp),
                    iconSize: 20.r, // Fixed structural scale
                    items: List.generate(statusList.length, (index) {
                      return DropdownMenuItem<int>(
                        value: index,
                        child: Text(
                          statusList[index],
                          style: TextStyle(fontSize: 14.sp),
                        ),
                      );
                    }).toList(),
                    onChanged: (index) async {
                      if (index == null) return;

                      // 1. Update the filter criteria in the provider
                      vm.setStatusIndex(index);
                      final selectedStatus = statusList[index];
                      vm.setStatus(selectedStatus == "All" ? null : selectedStatus);

                      // 2. Fallback check: If dates haven't been selected yet, apply current month defaults
                      // so switching statuses doesn't pass null dates to the API
                      if (vm.fromDate == null || vm.toDate == null) {
                        final now = DateTime.now();
                        final firstDay = DateTime(now.year, now.month, 1);
                        final lastDay = DateTime(now.year, now.month + 1, 0);
                        vm.setDateRange(DateTimeRange(start: firstDay, end: lastDay));
                      }

                      // 3. Make the API request safely
                      if (!mounted) return;
                      await vm.fetchReports(context: context);
                    },
                  ),
                ),
                SizedBox(width: 10.w),

                /// Round filter button container
                SizedBox(
                  height: 48.r,
                  width: 48.r,
                  child: FloatingActionButton(
                    heroTag: 'movementDateFilter',
                    onPressed: () => _pickDateRange(context),
                    mini: true,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.calendar_month_sharp,
                      size: 24.r, // Fixed structural scale
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Main data list segment
          Expanded(
            child: MovementReportList(
              statusFilter: vm.status,
              autoFetch: false, // Managed manually by our filter hooks above
            ),
          ),
        ],
      ),
    );
  }
}

class MovementReportList extends StatefulWidget {
  const MovementReportList({
    super.key,
    this.statusFilter, // "Pending" / "Cancelled" / "Approved" / null
    this.showPendingCancelAction = true,
    this.autoFetch = true, // auto-fetch on mount
    this.emptyText = 'No reports found.',
    this.hideLoad,
  });

  final String? statusFilter;
  final bool showPendingCancelAction;
  final bool autoFetch;
  final String emptyText;
  final bool? hideLoad;

  @override
  State<MovementReportList> createState() => _MovementReportListState();
}

class _MovementReportListState extends State<MovementReportList> {
  @override
  void initState() {
    super.initState();
    if (widget.autoFetch) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<MovementReportProvider>().fetchReports(context: context);
      });
    }
  }

  Future<void> _refresh() async {
    await context.read<MovementReportProvider>().fetchReports(context: context);
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MovementReportProvider>();
    final vmc = context.watch<MovementCancelProvider>();

    // Loading
    if (vm.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Error
    if (vm.error != null) {
      return _ErrorView(
        message: vm.error!,
        onRetry:
            () => context.read<MovementReportProvider>().fetchReports(
              context: context,
            ),
      );
    }

    // Filter (if provided)
    Iterable<MovementReportItem> data = vm.items;
    final filter = widget.statusFilter?.trim().toLowerCase();
    if (filter != null && filter.isNotEmpty) {
      data = data.where((e) => e.status.trim().toLowerCase() == filter);
    }

    int _statusRank(String status) {
      switch (status.trim().toLowerCase()) {
        case 'pending':
          return 1; // first
        case 'approved':
          return 2;
        case 'cancelled':
          return 3;
        case 'rejected':
          return 4;
        case 'Recommended':
          return 5;
        default:
          return 0;
      }
    }

    // Sort: newest first (by FromDate)
    final items =
        data.toList()..sort((a, b) {
          // 1) Status priority (Pending first)
          final ra = _statusRank(a.status);
          final rb = _statusRank(b.status);
          if (ra != rb) return ra.compareTo(rb);

          // 2) Tie-breaker: newest FromDate first
          final ad = _parseApiDate(a.fromDate);
          final bd = _parseApiDate(b.fromDate);
          if (ad == null && bd == null) return 0;
          if (ad == null) return 1;
          if (bd == null) return -1;
          return bd.compareTo(ad);
        });

    if (items.isEmpty) {
      return widget.hideLoad != true
          ? _EmptyView(
            text: widget.emptyText,
            onLoad:
                () => context.read<MovementReportProvider>().fetchReports(
                  context: context,
                ),
          )
          : SizedBox();
    }

    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView.separated(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (_, i) {
          final it = items[i];
          final canCancel =
              widget.showPendingCancelAction &&
              it.status.trim().toLowerCase() == 'pending';

          return _MovementTile(
            item: it,
            showCancel: canCancel && !vmc.isCancelling,
            onCancel:
                !canCancel || vmc.isCancelling
                    ? null
                    : () async {
                      final ok = await context
                          .read<MovementCancelProvider>()
                          .cancel(
                            context: context,
                            movementId: it.id,
                            reason: 'No longer needed',
                          );

                      if (ok) {
                        dialog(
                          context: context,
                          name: 'SUCCESS',
                          designation: 'Movement cancelled',
                          departmentName:
                              'The movement request has been cancelled successfully.',
                          btnOkOnPress: () {},
                          dialogType: DialogType.success,
                          btnOkColor: AppColors.success,
                        );
                        // auto-close the dialog after 2s
                        Future.delayed(const Duration(seconds: 2), () {
                          final nav = Navigator.of(
                            context,
                            rootNavigator: true,
                          );
                          if (nav.canPop()) nav.pop();
                        });

                        await context
                            .read<MovementReportProvider>()
                            .fetchReports(context: context);
                      } else {
                        final err =
                            context.read<MovementCancelProvider>().error ??
                            'Cancel failed';
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(err)));
                      }
                    },
          );
        },
      ),
    );
  }

  /// Parses "dd/MM/yyyy hh:mm a"
  DateTime? _parseApiDate(String s) {
    try {
      final parts = s.trim().split(' ');
      if (parts.length != 3) return null;
      final d = parts[0].split('/');
      final t = parts[1].split(':');
      if (d.length != 3 || t.length != 2) return null;

      final dd = int.parse(d[0]);
      final mm = int.parse(d[1]);
      final yy = int.parse(d[2]);

      int hh = int.parse(t[0]);
      final m = int.parse(t[1]);

      final ampm = parts[2].toUpperCase();
      if (ampm == 'PM' && hh != 12) hh += 12;
      if (ampm == 'AM' && hh == 12) hh = 0;

      return DateTime(yy, mm, dd, hh, m);
    } catch (_) {
      return null;
    }
  }
}

class _MovementTile extends StatelessWidget {
  const _MovementTile({
    required this.item,
    this.showCancel = true,
    this.onCancel,
  });

  final MovementReportItem item;
  final bool showCancel;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: EdgeInsets.all(12.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // -------- LEFT CONTENT --------
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.description.trim().isEmpty
                          ? '(No description)'
                          : item.description,
                      style: AppStyle.heading1.copyWith(fontSize: 14.sp),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      '${item.fromDate} →\n${item.toDate} ${item.id}',
                      style: AppStyle.bodyText.copyWith(fontSize: 13.sp),
                    ),
                  ],
                ),
              ),

              // -------- STATUS BADGE --------
              Row(
                spacing: 10.w,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: _statusColor(item.status),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      item.status.toUpperCase(),
                      style: AppStyle.bodyText.copyWith(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  if (showCancel)
                    InkWell(
                      onTap: onCancel,
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        padding: EdgeInsets.all(7.r),
                        decoration: BoxDecoration(
                          color: AppColors.errorLite,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.delete,
                          size: 16.r,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),

        // -------- DELETE FLOATING BUTTON --------
        // if (showCancel)
        //   Positioned(
        //     right: 8,
        //     bottom: -10,
        //     child: InkWell(
        //       onTap: onCancel,
        //       borderRadius: BorderRadius.circular(30),
        //       child: Container(
        //         padding: EdgeInsets.all(10.r),
        //         decoration: BoxDecoration(
        //           color: AppColors.errorLite,
        //           shape: BoxShape.circle,
        //           boxShadow: [
        //             BoxShadow(
        //               color: Colors.black.withOpacity(0.15),
        //               blurRadius: 6,
        //             ),
        //           ],
        //         ),
        //         child: Icon(
        //           Icons.delete,
        //           size: 16.r,
        //           color: Colors.white,
        //         ),
        //       ),
        //     ),
        //   ),
      ],
    );
  }

  Color _statusColor(String status) {
    final s = status.trim().toLowerCase();

    if (s.contains('pending')) return AppColors.warningLite;
    if (s.contains('approve')) return AppColors.successLite;
    if (s.contains('cancel') || s.contains('reject')) {
      return AppColors.errorLite;
    }
    return AppColors.info;
  }
}


class _EmptyView extends StatefulWidget {
  const _EmptyView({super.key, required this.onLoad, required this.text});

  final VoidCallback onLoad;
  final String text;

  @override
  State<_EmptyView> createState() => _EmptyViewState();
}

class _EmptyViewState extends State<_EmptyView> {
  Timer? _periodicTimer;

  @override
  void initState() {
    super.initState();

    // 1. Run immediately on initial load after the frame renders
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onLoad();
    });

    // 2. Set up the 4-second recurring loop
    _periodicTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      // Safety check: makes sure the widget is still attached to the UI tree
      if (mounted) {
        widget.onLoad();
      }
    });
  }

  @override
  void dispose() {
    // 3. CRITICAL: Stop the timer when the widget leaves the screen
    _periodicTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        // Direct call without PostFrameCallback to let the indicator track the execution lifecycle
        widget.onLoad();
      },
      child: ListView(
        // Forces the scroll physics to respond even when the content is smaller than the viewport screen height
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            // Dynamically takes up full height minus safe heights to perfectly center layout elements
            height: MediaQuery.of(context).size.height * 0.6,
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.insert_drive_file_outlined,
                      size: 48.r,
                      color: Colors.grey[400],
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      widget.text,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Failed to load reports:\n$message',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
