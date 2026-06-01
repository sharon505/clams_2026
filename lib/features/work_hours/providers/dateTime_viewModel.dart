import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeViewModel extends ChangeNotifier{

  DateTime? _selectedDate;

  DateTime? get selectedDate => _selectedDate;

  void setDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  String getTodayServerFormat() {
    final today = DateTime.now();
    return DateFormat('yyyy-MM-dd').format(today);
  }

  String getTodayDateFormattedToPunching() {
    final now = DateTime.now();
    final formatter = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    return formatter.format(now);
  }

  String getTodayDateFormatted() {
    final today = DateTime.now();
    return DateFormat('dd MMMM yyyy').format(today);
  }

  String getFormattedDate() {
    if (_selectedDate == null) return 'No date selected';
    return DateFormat('dd MMMM yyyy').format(_selectedDate!);
  }

}


