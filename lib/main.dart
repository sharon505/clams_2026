import 'dart:io';

import 'package:clams/constants/app_styles.dart';
import 'package:clams/features/Attendance/providers/punch_log_viewModel.dart';
import 'package:clams/features/Attendance/views/attendance_calendar_widget.dart';
import 'package:clams/features/dashboard/screens/dashboard_screen.dart';
import 'package:clams/features/leaves/providers/LeaveFilter_viewModel.dart';
import 'package:clams/features/leaves/providers/leaveApply_viewModel.dart';
import 'package:clams/features/leaves/providers/leaveCancel_viewModel.dart';
import 'package:clams/features/leaves/providers/leaveSummary_viewModel.dart';
import 'package:clams/features/leaves/providers/leaveType_viewModel.dart';
import 'package:clams/features/leaves/screens/leave_details_screen.dart';
import 'package:clams/features/leaves/screens/leaves_view.dart';
import 'package:clams/features/work_hours/providers/dateTime_viewModel.dart';
import 'package:clams/features/work_hours/providers/employee_working_duration_viewModel.dart';
import 'package:clams/features/work_hours/providers/location_viewModel.dart';
import 'package:clams/features/work_hours/providers/puncing_viewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'constants/app_colors.dart';

import 'features/Authentication/providers/Image_upload_provider.dart';
import 'features/Authentication/providers/auth_provider.dart';
import 'features/Authentication/screens/login_screen.dart';
import 'features/Authentication/screens/splash_screen.dart';
import 'features/leaves/screens/apply_leave.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
RouteObserver<ModalRoute<void>>();

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  HttpOverrides.global = MyHttpOverrides();
  runApp(Phoenix(child: const MyApp()));
}

List<SingleChildWidget> providers = [
  ///Authentication-------------------------------------------------------------
  ChangeNotifierProvider(create: (_) => AuthProvider()),
  ChangeNotifierProvider(create: (_) => ImageUploadProvider()),
  ///DashboardScreen------------------------------------------------------------
  ChangeNotifierProvider(create: (_) => DateTimeViewModel()),
  ChangeNotifierProvider(create: (_) => EmployeeWorkingDurationViewModel()),
  ChangeNotifierProvider(create: (_) => PunchingProvider()),
  ChangeNotifierProvider(create: (_) => LocationProvider()),
  ///Leaves---------------------------------------------------------------------
  ChangeNotifierProvider(create: (_) => LeaveApplyProvider()),
  ChangeNotifierProvider(create: (_) => LeaveCancelProvider()),
  ChangeNotifierProvider(create: (_) => LeaveFilterProvider()),
  ChangeNotifierProvider(create: (_) => LeaveSummaryProvider()),
  ChangeNotifierProvider(create: (_) => LeaveTypeProvider()),
  ///attendance-----------------------------------------------------------------
  ChangeNotifierProvider(create: (_) => PunchLogViewModel()),
];

Map<String, Widget Function(BuildContext)> routes = <String, WidgetBuilder>{
  ///Authentication-------------------------------------------------------------
  '/':                     (context) => SplashScreen(),
  'loginPage':             (context) => LoginPage(),
  ///DashboardScreen------------------------------------------------------------
  'dashboardScreen':       (context) => DashboardScreen(),
  ///Leaves---------------------------------------------------------------------
  'ApplyLeave':            (context) => ApplyLeave(),
  'LeavesView':            (context) => LeavesView(),
  'LeaveDetailsScreen':    (context) => const LeaveDetailsScreen(),
  ///attendance-----------------------------------------------------------------
  'AttendanceCalendar':    (context) => const AttendanceCalendar(),
};

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Size getDesignSize(BuildContext context) {
      final width = MediaQuery.of(context).size.width;
      return switch (width) {
        /// 10 inch tablet
        >= 900 => const Size(800, 1280),
        /// 7 inch tablet
        >= 600 => const Size(600, 960),
        /// Mobile
        _ => const Size(375, 812),       // Mobile
      };
    }
    return ScreenUtilInit(
      designSize: getDesignSize(context),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiProvider(
          providers: providers,
          child: MaterialApp(
            routes: routes,
            initialRoute: '/',
            // initialRoute: 'loginPage',
            debugShowCheckedModeBanner: false,
            title: 'clams',
              theme: ThemeData(
                scaffoldBackgroundColor: AppColors.primaryBg,
                primaryColor: AppColors.primaryColor,
                colorScheme: ColorScheme.fromSeed(
                  seedColor: AppColors.primaryColor,
                ),
                appBarTheme: AppBarTheme(
                  backgroundColor: AppColors.primaryBg,
                  elevation: 0,
                  centerTitle: false,
                  scrolledUnderElevation: 0,
                  iconTheme: const IconThemeData(
                    color: AppColors.textColor,
                  ),
                  titleTextStyle: AppStyles.heading3.copyWith(
                    color: AppColors.textColor,
                  ),
                ),
              ),
          ),
        );
      },
    );
  }
}

