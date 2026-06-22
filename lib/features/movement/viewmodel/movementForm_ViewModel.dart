
import 'package:clams/constants/app_colors.dart';
import 'package:flutter/material.dart';

/// Owns controllers, picked values, validation, and themed pickers
class MovementFormViewModel extends ChangeNotifier {
  // ---------------- Controllers ----------------
  final TextEditingController fromDateC = TextEditingController();
  final TextEditingController toDateC   = TextEditingController();
  final TextEditingController fromTimeC = TextEditingController();
  final TextEditingController toTimeC   = TextEditingController();
  final TextEditingController reasonC   = TextEditingController();
  final TextEditingController locationC = TextEditingController();

  // ---------------- Values ----------------
  DateTime? _fromDate;
  DateTime? _toDate;
  TimeOfDay? _fromTime;
  TimeOfDay? _toTime;

  DateTime? get fromDate => _fromDate;
  DateTime? get toDate => _toDate;
  TimeOfDay? get fromTime => _fromTime;
  TimeOfDay? get toTime => _toTime;

  // ---------------- Picker Theme ----------------
  Theme _pickerTheme(BuildContext context, Widget child) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bg = isDark
        ? const Color(0xFF121212)
        : AppColors.white;

    final surface = isDark
        ? const Color(0xFF1E1E1E)
        : AppColors.primarySecondary;

    final text = isDark
        ? Colors.white
        : AppColors.textColor;

    return Theme(
      data: Theme.of(context).copyWith(
        dialogBackgroundColor: bg,
        colorScheme: isDark
            ? ColorScheme.dark(
          primary: AppColors.primaryColor,
          onPrimary: Colors.white,
          onSurface: Colors.white,
          surface: bg,
        )
            : ColorScheme.light(
          primary: AppColors.primaryColor,
          onPrimary: Colors.white,
          onSurface: text,
          surface: bg,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primaryColor,
          ),
        ),
        timePickerTheme: TimePickerThemeData(
          backgroundColor: bg,
          hourMinuteColor: surface,
          hourMinuteTextColor: text,
          dialBackgroundColor: surface,
          dialHandColor: AppColors.primaryColor,
          entryModeIconColor: AppColors.primaryColor,
          dayPeriodTextColor: text,
          dayPeriodColor: surface,
        ),
        datePickerTheme: DatePickerThemeData(
          backgroundColor: bg,
          headerBackgroundColor: AppColors.primaryColor,
          headerForegroundColor: Colors.white,

          dayStyle: TextStyle(
            color: text,
            fontWeight: FontWeight.w500,
          ),

          dayForegroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
            if (states.contains(WidgetState.selected)) {
              return Colors.white; // Selected date text
            }

            if (states.contains(WidgetState.disabled)) {
              return Colors.grey;
            }

            return text;
          }),

          dayBackgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.primaryColor;
            }

            return Colors.transparent;
          }),

          todayForegroundColor: WidgetStateProperty.all(
            AppColors.primaryColor,
          ),

          todayBorder: BorderSide(
            color: AppColors.primaryColor,
          ),
        ),
      ),
      child: child,
    );
  }

  // ---------------- Helpers ----------------
  String _fmtDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  /// 12-hour AM/PM format
  String _fmtTime(TimeOfDay t) {
    final hour = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final minute = t.minute.toString().padLeft(2, '0');
    final period = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  int _toMinutes(TimeOfDay t) => t.hour * 60 + t.minute;

  // ---------------- Setters ----------------
  void setFromDate(DateTime d) {
    _fromDate = DateTime(d.year, d.month, d.day);
    fromDateC.text = _fmtDate(_fromDate!);

    if (_toDate != null && _toDate!.isBefore(_fromDate!)) {
      setToDate(_fromDate!);
    }
    notifyListeners();
  }

  void setToDate(DateTime d) {
    _toDate = DateTime(d.year, d.month, d.day);
    toDateC.text = _fmtDate(_toDate!);
    notifyListeners();
  }

  void setFromTime(TimeOfDay t) {
    _fromTime = t;
    fromTimeC.text = _fmtTime(t);

    if (_toTime != null && _fromDate != null && _toDate != null) {
      if (_isSameDay(_fromDate!, _toDate!) &&
          _toMinutes(_toTime!) <= _toMinutes(_fromTime!)) {
        _toTime = null;
        toTimeC.clear();
      }
    }
    notifyListeners();
  }

  void setToTime(TimeOfDay t) {
    _toTime = t;
    toTimeC.text = _fmtTime(t);
    notifyListeners();
  }

  // ---------------- Date Pickers ----------------
  Future<void> pickFromDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _fromDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) => _pickerTheme(context, child!),
    );
    if (picked != null) setFromDate(picked);
  }

  Future<void> pickToDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _toDate ?? _fromDate ?? DateTime.now(),
      firstDate: _fromDate ?? DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) => _pickerTheme(context, child!),
    );
    if (picked != null) setToDate(picked);
  }

  // ---------------- Time Pickers (AM / PM) ----------------
  Future<void> pickFromTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _fromTime ?? TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.dial,
      builder: (context, child) {
        return MediaQuery(
          data:
          MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: _pickerTheme(context, child!),
        );
      },
    );
    if (picked != null) setFromTime(picked);
  }

  Future<void> pickToTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _toTime ?? _fromTime ?? TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.dial,
      builder: (context, child) {
        return MediaQuery(
          data:
          MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: _pickerTheme(context, child!),
        );
      },
    );
    if (picked != null) setToTime(picked);
  }

  // ---------------- Validation (MAX 2 HOURS) ----------------
  String? validate() {
    if (_fromDate == null) return 'From Date is required';
    if (_toDate == null) return 'To Date is required';
    if (_fromTime == null) return 'From Time is required';
    if (_toTime == null) return 'To Time is required';
    if (reasonC.text.trim().isEmpty) return 'Reason is required';

    if (_toDate!.isBefore(_fromDate!)) {
      return 'To Date must be after From Date';
    }

    if (_isSameDay(_fromDate!, _toDate!)) {
      final diff =
          _toMinutes(_toTime!) - _toMinutes(_fromTime!);

      if (diff <= 0) {
        return 'To Time must be after From Time';
      }

      if (diff > 120) {
        return 'Movement time cannot exceed 2 hours';
      }
    }

    return null;
  }

  // ---------------- Reset & Dispose ----------------
  void reset() {
    fromDateC.clear();
    toDateC.clear();
    fromTimeC.clear();
    toTimeC.clear();
    reasonC.clear();
    locationC.clear();
    _fromDate = null;
    _toDate = null;
    _fromTime = null;
    _toTime = null;
    notifyListeners();
  }

  @override
  void dispose() {
    fromDateC.dispose();
    toDateC.dispose();
    fromTimeC.dispose();
    toTimeC.dispose();
    reasonC.dispose();
    locationC.dispose();
    super.dispose();
  }
}
