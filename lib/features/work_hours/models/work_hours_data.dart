import 'package:flutter/material.dart';

class WorkHoursData {
  final Duration workedDuration;
  final Duration remainingDuration;
  final Duration overtime;

  final int completedPercentage;

  final String statusText;
  final String checkInTime;

  final Color badgeColor;
  final Color badgeBgColor;

  final IconData badgeIcon;

  const WorkHoursData({
    required this.workedDuration,
    required this.remainingDuration,
    required this.overtime,
    required this.completedPercentage,
    required this.statusText,
    required this.checkInTime,
    required this.badgeColor,
    required this.badgeBgColor,
    required this.badgeIcon,
  });
}