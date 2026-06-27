import 'package:clams/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppSegmentedToggle extends StatelessWidget {
  const AppSegmentedToggle({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onChanged,
    this.height = 56,
    this.activeColor = const Color(0xFF3F7BF2),
  });

  final List<String> items;
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final double height;
  final Color activeColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height.h,
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(
          color: activeColor.withOpacity(.4),
        ),
      ),
      child: Row(
        children: List.generate(
          items.length,
              (index) {
            final selected = selectedIndex == index;

            return Expanded(
              child: GestureDetector(
                onTap: () => onChanged(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  margin: EdgeInsets.symmetric(horizontal: 2.w),
                  decoration: BoxDecoration(
                    color: selected ? activeColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(24.r),
                    border: Border.all(
                      color: activeColor,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            items[index].toUpperCase(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: selected ? Colors.white : activeColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 11.sp,
                            ),
                          ),
                        ),

                        AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          width: 18.w,
                          height: 18.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: selected ? Colors.white : Colors.transparent,
                            border: Border.all(
                              color: selected ? Colors.white : activeColor,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              width: 13.w,
                              height: 13.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: selected
                                    ? AppColors.primaryColor
                                    : Colors.transparent,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}