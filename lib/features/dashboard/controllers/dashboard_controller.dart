import 'package:clams/features/Authentication/providers/auth_provider.dart';
import 'package:clams/features/work_hours/providers/dateTime_viewModel.dart';
import 'package:clams/features/work_hours/providers/employee_working_duration_viewModel.dart';
import 'package:clams/features/work_hours/providers/location_viewModel.dart';
import 'package:clams/features/work_hours/providers/puncing_viewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardController {
  DashboardController._();

  static Future<void> loadInitialData(
      BuildContext context,
      ) async {
    final authProvider =
    context.read<AuthProvider>();

    final dateTimeVm =
    context.read<DateTimeViewModel>();

    final locationVm =
    context.read<LocationProvider>();

    final punchingVm =
    context.read<PunchingProvider>();

    final workingDurationVm =
    context.read<EmployeeWorkingDurationViewModel>();

    try {
      dateTimeVm.setDate(DateTime.now());

      final employee =
          authProvider.userData;

      if (employee != null) {
        workingDurationVm.setEmployee(
          employee,
        );
      }

      await Future.wait([
        locationVm.refresh(force: true),

        punchingVm.fetchTodayPunchingDetails(
          context,
        ),
      ]);
    } catch (e) {
      debugPrint(
        '❌ Dashboard Load Error: $e',
      );
    }
  }
}