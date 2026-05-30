import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../controllers/dashboard_controller.dart';
import '../widgets/dashboard_banner.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/work_hours_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      DashboardController.loadInitialData(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F4F0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              const DashboardHeader(),

              SizedBox(height: 16.h),

              const DashboardBanner(),

              SizedBox(height: 16.h),

              WorkHoursCard(),

              // SizedBox(height: 16.h),
              //
              // const ApprovalCenter(),
              //
              // SizedBox(height: 16.h),
              //
              // const ApplyRequests(),
              //
              // SizedBox(height: 16.h),
              //
              // const ReportsDocuments(),
            ],
          ),
        ),
      ),
    );
  }
}