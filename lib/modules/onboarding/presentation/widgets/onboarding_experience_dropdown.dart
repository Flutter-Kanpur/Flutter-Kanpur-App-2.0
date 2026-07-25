import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_borders.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';

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
          horizontal: AppSpacing.h16,
          vertical: AppSpacing.v16,
        ),

        decoration: BoxDecoration(
          borderRadius: AppRadius.all03,

          border: Border.all(
            color: AppBorders.secondary,
          ),
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [

            Text(
              selectedValue.isEmpty
                  ? 'onboarding.yearsOfExperience'.tr()
                  : selectedValue,

              style: AppTextStyles.titleSmall.copyWith(color: AppColors.blackBase),
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