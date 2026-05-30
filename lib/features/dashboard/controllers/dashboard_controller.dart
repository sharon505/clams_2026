import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/dateTime_viewModel.dart';
import '../providers/employee_working_duration_viewModel.dart';
import '../providers/puncing_viewModel.dart';

class DashboardController {
  DashboardController._();

  static Future<void> loadInitialData(
      BuildContext context,
      ) async {
    final dateTimeVm = context.read<DateTimeViewModel>();
    final workingDurationVm =
    context.read<EmployeeWorkingDurationViewModel>();
    final punchingVm =
    context.read<PunchingProvider>();

    try {
      dateTimeVm.setDate(DateTime.now());

      await Future.wait([
        workingDurationVm.fetchTodayWorkingDuration(
          context: context,
        ),
        punchingVm.fetchTodayPunchingDetails(
          context,
        ),
      ]);
    } catch (e) {
      debugPrint('❌ Dashboard Load Error: $e');
    }
  }
}