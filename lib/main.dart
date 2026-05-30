import 'dart:io';

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
import 'features/dashboard/providers/dateTime_viewModel.dart';
import 'features/dashboard/providers/employee_working_duration_viewModel.dart';
import 'features/dashboard/providers/puncing_viewModel.dart';
import 'features/dashboard/screens/dashboard_screen.dart';

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
];

Map<String, Widget Function(BuildContext)> routes = <String, WidgetBuilder>{
  ///Authentication-------------------------------------------------------------
  '/':                     (context) => SplashScreen(),
  'loginPage':             (context) => LoginPage(),
  ///DashboardScreen------------------------------------------------------------
  'dashboardScreen':       (context) => DashboardScreen(),
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
              ),
          ),
        );
      },
    );
  }
}

