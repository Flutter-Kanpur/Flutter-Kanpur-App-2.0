import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingExperienceDropdown extends StatelessWidget {
  final String selectedValue;
  final VoidCallback onTap;

  const OnboardingExperienceDropdown({
    super.key,
    required this.selectedValue,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 16.h,
        ),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.r),

          border: Border.all(
            color: const Color(0xFFE0E0E0),
          ),
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [

            Text(
              selectedValue.isEmpty
                  ? 'onboarding.yearsOfExperience'.tr()
                  : selectedValue,

              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),

            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 24.sp,
            ),
          ],
        ),
      ),
    );
  }
}