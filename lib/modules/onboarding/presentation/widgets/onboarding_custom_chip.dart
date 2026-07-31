import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';

class OnboardingCustomChip extends StatelessWidget {
  final String title;
  final VoidCallback onRemove;

  const OnboardingCustomChip({
    super.key,
    required this.title,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.h16,
        vertical: AppSpacing.v10,
      ),

      decoration: BoxDecoration(
        color: AppColors.blackBase,

        borderRadius: AppRadius.all06,
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,

        children: [
          Text(
            title,

            style: AppTextStyles.labelLarge.copyWith(
              color: AppColors.whiteBase,
            ),
          ),

          8.horizontalSpace,

          GestureDetector(
            onTap: onRemove,

            child: Icon(Icons.close, color: AppColors.whiteBase, size: 18.sp),
          ),
        ],
      ),
    );
  }
}
