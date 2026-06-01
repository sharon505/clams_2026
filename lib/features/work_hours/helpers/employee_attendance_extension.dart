import 'package:clams/features/Authentication/models/model_login.dart';
import 'package:intl/intl.dart';

extension EmployeeAttendanceExtension on EmployeeData {
  DateTime _parseTime(String value) {
    final parsed =
    DateFormat('hh:mm:ss a').parse(value);

    final now = DateTime.now();

    return DateTime(
      now.year,
      now.month,
      now.day,
      parsed.hour,
      parsed.minute,
      parsed.second,
    );
  }

  Duration get workedDuration {
    final now = DateTime.now();

    final mrIn = _parseTime(attMrIn);
    final mrOut = _parseTime(attMrOut);
    final evLimit = _parseTime(attEvLimit);

    if (now.isBefore(mrIn)) {
      return Duration.zero;
    }

    if (now.isBefore(mrOut)) {
      return now.difference(mrIn);
    }

    if (now.isBefore(evLimit)) {
      final morningWorked =
      mrOut.difference(mrIn);

      final eveningWorked =
      now.difference(mrOut);

      return morningWorked + eveningWorked;
    }

    return evLimit.difference(mrIn);
  }
}