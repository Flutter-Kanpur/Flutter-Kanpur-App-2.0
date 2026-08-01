import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_borders.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_knp_mobile_app_v2/core/constants/app_assets.dart';

class OnboardingChip extends StatelessWidget {
  const OnboardingChip({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.h16,
          vertical: AppSpacing.v10,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary500 : AppColors.whiteBase,
          borderRadius: AppRadius.all09,
          border: Border.all(
            color: isSelected ? AppColors.primary500 : AppBorders.secondary,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: AppTextStyles.labelLarge.copyWith(
                color: isSelected ? AppColors.whiteBase : AppColors.blackBase,
              ),
            ),
            if (isSelected) ...[
              SizedBox(width: 8.w),
              SvgPicture.asset(
                AppAssets.crossIcon,
                width: 14.w,
                height: 14.h,
                colorFilter: const ColorFilter.mode(
                  AppColors.whiteBase,
                  BlendMode.srcIn,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
