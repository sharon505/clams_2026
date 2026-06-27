import 'package:clams/constants/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppDialog {
  AppDialog._();

  static Future<bool?> confirmation({
    required BuildContext context,
    required String title,
    required String message,
    required VoidCallback onConfirm,
    String confirmText = "Accept",
    String cancelText = "Cancel",
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          width: 340.w,
          padding: EdgeInsets.symmetric(
            horizontal: 24.w,
            vertical: 26.h,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 10.h,
            children: [

              /// Icon
              Container(
                width: 42.w,
                height: 42.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xff4A5568),
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  Icons.priority_high_rounded,
                  size: 24.sp,
                  color: const Color(0xff4A5568),
                ),
              ),

              Text(
                title,
                textAlign: TextAlign.center,
                style: AppStyles.heading3.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),

              Text(
                message,
                textAlign: TextAlign.center,
                style: AppStyles.bodySmall.copyWith(
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
              ),


              Row(
                spacing: 10.w,
                children: [

                  Expanded(
                    child: _DialogButton(
                      title: cancelText,
                      icon: Icons.close,
                      color: Colors.red,
                      onTap: () {
                        Navigator.pop(context, false);
                      },
                    ),
                  ),

                  Expanded(
                    child: _DialogButton(
                      title: confirmText,
                      icon: Icons.check,
                      color: Colors.green,
                      filled: true,
                      onTap: () {
                        Navigator.pop(context, true);
                        onConfirm();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DialogButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final bool filled;
  final VoidCallback onTap;

  const _DialogButton({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42.h,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(
          icon,
          size: 17.sp,
          color: filled ? Colors.white : color,
        ),
        label: Text(
          title,
          style: TextStyle(
            color: filled ? Colors.white : color,
            fontWeight: FontWeight.w600,
            fontSize: 14.sp,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: filled ? color : Colors.white,
          elevation: 0,
          shape: StadiumBorder(
            side: BorderSide(color: color),
          ),
        ),
      ),
    );
  }
}