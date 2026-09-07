import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';

class HomeEmptyState extends StatelessWidget {
  const HomeEmptyState({
    super.key,
    this.title = 'No upcoming events right now',
    this.description = 'Check back soon for upcoming meetups and sessions.',
    this.buttonText = 'Browse past events',
    this.onButtonPressed,
  });

  final String title;
  final String description;
  final String buttonText;
  final VoidCallback? onButtonPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.h22,
        vertical: AppSpacing.v4,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72.w,
            height: 72.h,
            decoration: BoxDecoration(
              color: AppColors.primary50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.event_busy_outlined,
              size: 32.sp,
              color: AppColors.primary500,
            ),
          ),

          SizedBox(height: 20.h),

          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.blackBase,
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 8.h),

          Text(
            description,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.neutral500,
            ),
          ),

          SizedBox(height: 20.h),

          SizedBox(
            height: 44.h,
            child: OutlinedButton(
              onPressed: onButtonPressed,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary500,
                side: BorderSide(color: AppColors.primary500),
                shape: RoundedRectangleBorder(borderRadius: AppRadius.all03),
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.h20),
              ),
              child: Text(
                buttonText,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.primary500,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
