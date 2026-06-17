import 'package:clams/constants/app_colors.dart';
import 'package:clams/constants/app_padding.dart';
import 'package:clams/constants/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SalaryDetailsCard extends StatelessWidget {
  const SalaryDetailsCard({
    super.key,
    required this.grossSalary,
    required this.basic,
    required this.hra,
    required this.da,
    required this.cityCompensatoryAllowance,
    required this.csa,
    required this.esi,
    required this.swf,
  });

  final double? grossSalary;
  final double? basic;
  final double? hra;
  final double? da;
  final double? cityCompensatoryAllowance;
  final double? csa;
  final bool? esi;
  final bool? swf;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: AppPadding.horizontalMedium.copyWith(top: 12.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: AppColors.primarySecondary,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Salary Details",
            style: AppStyles.heading4,
          ),

          SizedBox(height: 18.h),

          _salaryRow("Gross Salary", grossSalary),
          _salaryRow("Basic", basic),
          _salaryRow("HRA", hra),
          _salaryRow("DA", da),
          _salaryRow(
            "City Compensatory Allowance",
            cityCompensatoryAllowance,
          ),
          _salaryRow("CSA", csa),

          _boolRow(
            "ESI",
            esi,
          ),

          _boolRow(
            "SWF",
            swf,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _salaryRow(
      String title,
      double? value,
      ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 18.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: AppStyles.bodyMedium.copyWith(
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Text(
            value != null
                ? value.toStringAsFixed(2)
                : "-",
            style: AppStyles.bodyLarge,
          ),
        ],
      ),
    );
  }

  Widget _boolRow(
      String title,
      bool? value, {
        bool isLast = false,
      }) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: isLast ? 0 : 18.h,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: AppStyles.bodyMedium.copyWith(
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Text(
            value == null
                ? "-"
                : value
                ? "Yes"
                : "No",
            style: AppStyles.bodyLarge,
          ),
        ],
      ),
    );
  }
}