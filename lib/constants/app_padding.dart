import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppPadding {
  AppPadding._();

  // Horizontal
  static final horizontal8 = 8.w;
  static final horizontal12 = 12.w;
  static final horizontal16 = 16.w;
  static final horizontal20 = 20.w;
  static final horizontal24 = 24.w;
  static final horizontal32 = 32.w;

  // Vertical
  static final vertical8 = 8.h;
  static final vertical12 = 12.h;
  static final vertical16 = 16.h;
  static final vertical20 = 20.h;
  static final vertical24 = 24.h;
  static final vertical32 = 32.h;

  // Common EdgeInsets
  static EdgeInsets screenPadding =
  EdgeInsets.symmetric(
    horizontal: 20.w,
    vertical: 20.h,
  );



  static EdgeInsets cardPadding =
  EdgeInsets.all(16.r);

  static EdgeInsets buttonPadding =
  EdgeInsets.symmetric(
    horizontal: 20.w,
    vertical: 12.h,
  );

  static EdgeInsets allSmall = EdgeInsets.all(12.r);

  static EdgeInsets horizontalOnly = EdgeInsets.symmetric(
    horizontal: 12.w,
  );

  static EdgeInsets horizontalMedium = EdgeInsets.symmetric(
    horizontal: 16.w,
  );

  static EdgeInsets verticalOnly = EdgeInsets.symmetric(
    vertical: 12.h,
  );
}