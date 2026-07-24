import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_borders.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';

class OnboardingChip extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const OnboardingChip({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),

        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.s07,
          vertical: AppSpacing.s05,
        ),

        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.blackBase
              : AppColors.whiteBase,

          borderRadius: AppRadius.all06,

          border: Border.all(
            color: isSelected
                ? AppColors.blackBase
                : AppBorders.secondary,
          ),
        ),

        child: Text(
          title,

          style: AppTextStyles.labelLarge.copyWith(
            color: isSelected ? AppColors.whiteBase : AppColors.blackBase,
          ),
        ),
      ),
    );
  }
}