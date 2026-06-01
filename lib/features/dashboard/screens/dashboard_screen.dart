import 'package:clams/features/Authentication/providers/auth_provider.dart';
import 'package:clams/features/dashboard/widgets/apply_requests.dart';
import 'package:clams/features/dashboard/widgets/approval_center.dart';
import 'package:clams/features/dashboard/widgets/reports_documents.dart';
import 'package:clams/features/work_hours/screens/work_hours_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../controllers/dashboard_controller.dart';
import '../widgets/dashboard_banner.dart';
import '../widgets/dashboard_header.dart';

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

    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xffF6F4F0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            spacing: 16.h,
            children: [
              const DashboardHeader(),

              const DashboardBanner(),

              WorkHoursCard(),

              if(auth.userData?.isReportingManager==true)
              const ApprovalCenterCard(),

              const ApplyRequestsCard(),

              ReportsDocumentsCard(),

              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}