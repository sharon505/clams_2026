import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/dashboard_banner.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/work_hours_card.dart';
import '../widgets/approval_center.dart';
import '../widgets/apply_requests.dart';
import '../widgets/reports_documents.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

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

              WorkHoursCard(
                location: "Thrissur, Kerala, India",
                workedHours: "05:53",
                remainingHours: "02:31",
                checkInTime: "09:23 AM",
                overtime: "00:00 HRS",
                completedPercentage: 70,
                isWorking: true,
              ),
              //
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