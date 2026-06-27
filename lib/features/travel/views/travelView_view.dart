import 'package:clams/features/travel/widgets/travel_card_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../constants/app_colors.dart';
import '../../../main.dart';
import '../widgets/travel_card.dart';
import '../viewModels/myTravelRequisitionViewModel.dart';

/// FORMAT DATE FOR UI
String formatTravelDate(String dateString) {
  try {
    final date = DateTime.parse(dateString);
    return DateFormat('dd MMM yyyy').format(date);
  } catch (e) {
    return dateString;
  }
}

class TravelViewView extends StatefulWidget {
  const TravelViewView({super.key});

  @override
  State<TravelViewView> createState() => _TravelViewViewState();
}

class _TravelViewViewState extends State<TravelViewView> with RouteAware {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MyTravelRequisitionViewModel>().fetch(context);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void didPopNext() =>
      context.read<MyTravelRequisitionViewModel>().fetch(context);

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  Future<void> _pickDateRange(BuildContext context) async {
    final vm = context.read<MyTravelRequisitionViewModel>();

    final picked = await showDateRangePicker(
      context: context,

      initialDateRange: vm.fromDate != null && vm.toDate != null
          ? DateTimeRange(start: vm.fromDate!, end: vm.toDate!)
          : null,

      firstDate: DateTime(2020),
      lastDate: DateTime(2100),

      helpText: vm.fromDate != null && vm.toDate != null
          ? "${DateFormat('dd MMM yyyy').format(vm.fromDate!)}"
                " - "
                "${DateFormat('dd MMM yyyy').format(vm.toDate!)}"
          : "Select Date Range",

      saveText: "APPLY",
      cancelText: "CANCEL",
      fieldStartHintText: "From",
      fieldEndHintText: "To",
    );

    if (picked != null) {
      vm.setDateRange(picked);
      await vm.fetch(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MyTravelRequisitionViewModel>();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Travel Report"),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.h),
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 12.h),
            child: SizedBox(
              height: 42.h,
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search location",
                  hintStyle: TextStyle(fontSize: 14.sp, color: Colors.grey),
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      context
                          .read<MyTravelRequisitionViewModel>()
                          .clearSearch();
                      FocusScope.of(context).unfocus();
                    },
                  ),
                  filled: true,
                  fillColor: AppColors.white,
                  contentPadding: EdgeInsets.zero,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.r),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.r),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.r),
                    borderSide: const BorderSide(color: AppColors.primaryColor),
                  ),
                ),
                onChanged: (value) =>
                    context.read<MyTravelRequisitionViewModel>().search(value),
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _pickDateRange(context),
            icon: const Icon(
              Icons.calendar_month_outlined,
              color: Colors.black,
            ),
            tooltip: "Select Date Range",
          ),
          SizedBox(width: 9.w),
        ],
      ),

      body: Column(
        children: [
          Expanded(
            child: Consumer<MyTravelRequisitionViewModel>(
              builder: (_, vm, __) {
                // ---------------- LOADING ----------------
                if (vm.isLoading) {
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 6,
                    itemBuilder: (_, __) => const TravelCardShimmer(),
                  );
                }

                // ---------------- ERROR ----------------
                if (vm.error != null) {
                  return RefreshIndicator(
                    onRefresh: () => vm.fetch(context),
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.18,
                        ),

                        Icon(
                          Icons.travel_explore_rounded,
                          size: 72.sp,
                          color: Colors.redAccent.withOpacity(.9),
                        ),

                        SizedBox(height: 14.h),

                        Center(
                          child: Text(
                            "Unable to load travel requests",
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textColor,
                            ),
                          ),
                        ),

                        SizedBox(height: 8.h),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30.w),
                          child: Text(
                            vm.error!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: Colors.red.shade300,
                            ),
                          ),
                        ),

                        SizedBox(height: 22.h),

                        Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.swipe_down_rounded,
                                size: 22.sp,
                                color: Colors.grey.withOpacity(.6),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                "Pull down to retry",
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.grey.withOpacity(.8),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // ---------------- EMPTY ----------------
                if (!vm.hasData) {
                  return Center(
                    child: Text(
                      'No travel requisitions found.',
                      style: TextStyle(fontSize: 14.sp),
                    ),
                  );
                }

                // ---------------- LIST ----------------
                return RefreshIndicator(
                  onRefresh: () => vm.fetch(context),
                  child: vm.rows.isEmpty
                      ? ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            SizedBox(height: 120.h),
                            Icon(
                              Icons.search_off_rounded,
                              size: 60.sp,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16.h),
                            Center(
                              child: Text(
                                "No travel requisitions found",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(height: 6.h),
                            Center(
                              child: Text(
                                "Try a different search keyword.",
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        )
                      : ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.only(bottom: 16.h),
                          itemCount: vm.rows.length,
                          itemBuilder: (ctx, i) {
                            final row = vm.rows[i];
                            final status = row.trStatus.trim().toLowerCase();

                            return TravelCard(
                              row: row,
                              isPending: status == "pending",
                            );
                          },
                        ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
