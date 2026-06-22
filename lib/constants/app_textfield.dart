import 'package:clams/constants/app_colors.dart';
import 'package:clams/constants/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomInputCard extends StatelessWidget {
  final IconData? icon;
  final String label;
  final Widget child;
  final bool isTextArea;

  const CustomInputCard._({
    super.key,
    this.icon,
    required this.label,
    required this.child,
    this.isTextArea = false,
  });

  //----------------------------------------------------------------------------
  // TEXT FIELD
  //----------------------------------------------------------------------------
  factory CustomInputCard.textField({
    Key? key,
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
    Widget? suffixIcon,
    TextStyle? style,
  }) {
    return CustomInputCard._(
      key: key,
      icon: icon,
      label: label,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        readOnly: readOnly,
        onTap: onTap,
        validator: validator,
        inputFormatters: inputFormatters,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        style: style ??
            AppStyles.bodyMedium.copyWith(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
            ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: AppStyles.bodyMedium.copyWith(
            fontSize: 15.sp,
            color: AppColors.textColor.withOpacity(.45),
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          isDense: true,
          filled: false,
          contentPadding: EdgeInsets.zero,
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }

  //----------------------------------------------------------------------------
  // DROPDOWN
  //----------------------------------------------------------------------------
  factory CustomInputCard.dropdown({
    Key? key,
    required IconData icon,
    required String label,
    required String hintText,
    required List<String> dropdownItems,
    required String? selectedItem,
    required Function(String?) onChanged,
    String? Function(String?)? validator,
  }) {
    return CustomInputCard._(
      key: key,
      icon: icon,
      label: label,
      child: DropdownButtonFormField<String>(
        value: selectedItem,
        isExpanded: true,
        validator: validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        style: AppStyles.bodyMedium.copyWith(
          fontSize: 15.sp,
          color: AppColors.textColor,
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        hint: Text(
          hintText,
          style: AppStyles.bodyMedium.copyWith(
            fontSize: 15.sp,
            color: AppColors.textColor.withOpacity(.45),
          ),
        ),
        items: dropdownItems
            .map(
              (item) => DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        )
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  //----------------------------------------------------------------------------
  // TEXT AREA
  //----------------------------------------------------------------------------
  factory CustomInputCard.textArea({
    Key? key,
    required String label,
    required String hintText,
    required TextEditingController controller,
    String? Function(String?)? validator,
    int maxLines = 5,
  }) {
    return CustomInputCard._(
      key: key,
      label: label,
      isTextArea: true,
      child: TextFormField(
        controller: controller,
        validator: validator,
        maxLines: maxLines,
        minLines: maxLines,
        textAlignVertical: TextAlignVertical.top,
        style: AppStyles.bodyMedium.copyWith(
          fontSize: 15.sp,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: AppStyles.bodyMedium.copyWith(
            fontSize: 15.sp,
            color: AppColors.textColor.withOpacity(.45),
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }

  //----------------------------------------------------------------------------
  // UI
  //----------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 10.w),
            child: Text(
              label,
              style: AppStyles.bodySmall.copyWith(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textColor,
              ),
            ),
          ),
          SizedBox(height: 6.h),
          Container(
            height: isTextArea ? 120.h : 56.h,
            padding: EdgeInsets.symmetric(
              horizontal: isTextArea ? 16.w : 8.w,
              vertical: isTextArea ? 16.h : 0,
            ),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(
                isTextArea ? 22.r : 30.r,
              ),
              border: Border.all(
                color: AppColors.primarySecondary,
                width: 1.2,
              ),
            ),
            child: isTextArea
                ? child
                : Row(
              children: [
                Container(
                  width: 38.w,
                  height: 38.h,
                  decoration: const BoxDecoration(
                    color: AppColors.primarySecondary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: AppColors.primaryColor,
                    size: 18.sp,
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(child: child),
              ],
            ),
          ),
        ],
      ),
    );
  }
}