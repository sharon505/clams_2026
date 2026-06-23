import 'package:flutter/material.dart';

/// Owns controllers, picked values, validation, and themed pickers
class MovementFormViewModel extends ChangeNotifier {
  // Controllers
  final TextEditingController fromDateC = TextEditingController();
  final TextEditingController toDateC = TextEditingController();
  final TextEditingController fromTimeC = TextEditingController();
  final TextEditingController toTimeC = TextEditingController();
  final TextEditingController reasonC = TextEditingController();

  // Date
  DateTime? _fromDate;
  DateTime? _toDate;

  DateTime? get fromDate => _fromDate;
  DateTime? get toDate => _toDate;

  // Movement Time
  DateTime _startTime = DateTime.now();
  int _durationHour = 1;

  DateTime get startTime => _startTime;
  int get durationHour => _durationHour;

  DateTime get endTime =>
      _startTime.add(Duration(hours: _durationHour));

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/'
          '${d.month.toString().padLeft(2, '0')}/'
          '${d.year}';

  String _formatTime(DateTime d) {
    final hour = d.hour % 12 == 0 ? 12 : d.hour % 12;

    final minute =
    d.minute.toString().padLeft(2, '0');

    final period =
    d.hour >= 12 ? 'PM' : 'AM';

    return '$hour:$minute $period';
  }

  // Date Selection
  void setFromDate(DateTime date) {
    _fromDate = DateTime(
      date.year,
      date.month,
      date.day,
    );

    _toDate = _fromDate;

    fromDateC.text = _formatDate(_fromDate!);
    toDateC.text = _formatDate(_toDate!);

    notifyListeners();
  }

  void setToDate(DateTime date) {
    _toDate = DateTime(
      date.year,
      date.month,
      date.day,
    );

    toDateC.text = _formatDate(_toDate!);

    notifyListeners();
  }

  // Start Time
  void setStartTime(DateTime value) {
    _startTime = value;

    fromTimeC.text = _formatTime(_startTime);
    toTimeC.text = _formatTime(endTime);

    notifyListeners();
  }

  // Duration
  void setDuration(int value) {
    _durationHour = value;

    toTimeC.text = _formatTime(endTime);

    notifyListeners();
  }

  // Validation
  String? validate() {
    if (_fromDate == null) {
      return 'Date is required';
    }

    if (reasonC.text.trim().isEmpty) {
      return 'Reason is required';
    }

    return null;
  }

  // Reset
  void reset() {
    fromDateC.clear();
    toDateC.clear();
    fromTimeC.clear();
    toTimeC.clear();
    reasonC.clear();

    _fromDate = null;
    _toDate = null;

    _startTime = DateTime.now();
    _durationHour = 1;

    notifyListeners();
  }

  @override
  void dispose() {
    fromDateC.dispose();
    toDateC.dispose();
    fromTimeC.dispose();
    toTimeC.dispose();
    reasonC.dispose();
    super.dispose();
  }
}
