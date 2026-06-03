import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:clams/constants/app_colors.dart';
import 'package:clams/constants/app_radius.dart';
import 'package:clams/constants/app_styles.dart';

class CustomInputCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String hintText;
  final Widget child;

  const CustomInputCard._({
    super.key,
    required this.icon,
    required this.label,
    required this.hintText,
    required this.child,
  });

  //----------------------------------------------------------------------------
  // TEXT FIELD
  //----------------------------------------------------------------------------
  factory CustomInputCard.textField({
    required IconData icon,
    required String label,
    required String hintText,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    bool readOnly = false,
    VoidCallback? onTap,
    String? Function(String?)? validator,
    int maxLines = 1,
    TextStyle? style,
    EdgeInsetsGeometry? contentPadding,
    Widget? suffixIcon,
  }) {
    return CustomInputCard._(
      icon: icon,
      label: label,
      hintText: hintText,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator,
        readOnly: readOnly,
        onTap: onTap,
        inputFormatters: inputFormatters,
        style: style ?? AppStyles.bodyMedium,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: AppStyles.bodyMedium.copyWith(
            color: AppColors.textColor.withOpacity(.5),
          ),
          isDense: true,
          suffixIcon: suffixIcon,
          contentPadding:
          contentPadding ??
              EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 12.h,
              ),
          filled: true,
          fillColor: AppColors.primarySecondary.withOpacity(.25),
          border: OutlineInputBorder(
            borderRadius: AppRadius.medium,
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppRadius.medium,
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppRadius.medium,
            borderSide: BorderSide(
              color: AppColors.primaryColor,
              width: 1,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: AppRadius.medium,
            borderSide: BorderSide(
              color: AppColors.error,
              width: 1,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: AppRadius.medium,
            borderSide: BorderSide(
              color: AppColors.error,
              width: 1,
            ),
          ),
        ),
      ),
    );
  }

  //----------------------------------------------------------------------------
  // DROPDOWN
  //----------------------------------------------------------------------------
  factory CustomInputCard.dropdown({
    required IconData icon,
    required String label,
    required String hintText,
    required List<String> dropdownItems,
    required String? selectedItem,
    required Function(String?) onChanged,
    String? Function(String?)? validator,
  }) {
    return CustomInputCard._(
      icon: icon,
      label: label,
      hintText: hintText,
      child: DropdownButtonFormField<String>(
        value: selectedItem,
        isExpanded: true,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: validator,
        style: AppStyles.bodyMedium,
        hint: Text(
          hintText,
          style: AppStyles.bodyMedium.copyWith(
            color: AppColors.textColor.withOpacity(.5),
          ),
        ),
        items: dropdownItems
            .map(
              (item) => DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: AppStyles.bodyMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        )
            .toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 12.w,
            vertical: 12.h,
          ),
          filled: true,
          fillColor: AppColors.primarySecondary.withOpacity(.25),
          border: OutlineInputBorder(
            borderRadius: AppRadius.medium,
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppRadius.medium,
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppRadius.medium,
            borderSide: BorderSide(
              color: AppColors.primaryColor,
              width: 1,
            ),
          ),
        ),
      ),
    );
  }

  //----------------------------------------------------------------------------
  // UI
  //----------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: AppRadius.medium,
        // border: Border.all(
        //   color: AppColors.primarySecondary,
        // ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ICON
          Container(
            width: 38.w,
            height: 38.h,
            decoration: BoxDecoration(
              color: AppColors.primarySecondary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                icon,
                color: AppColors.primaryColor,
                size: 16.r,
              ),
            ),
          ),

          SizedBox(width: 12.w),

          // CONTENT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppStyles.bodySmall.copyWith(
                    color: AppColors.textColor.withOpacity(.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8.h),
                child,
              ],
            ),
          ),
        ],
      ),
    );
  }
}