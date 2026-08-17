import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import '../../utils/translate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';

import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';

class ProblemOfDaySection extends StatelessWidget {
  const ProblemOfDaySection({
    super.key,
    required this.level,
    required this.progress,
    required this.onViewProgress,
  });

  final int level;
  final double progress;
  final VoidCallback onViewProgress;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppSpacing.all(AppSpacing.h20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary500, AppColors.primary400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppRadius.all06,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                translate(context, "profile.problemOfDay"),
                style: AppTextStyles.titleLarge.copyWith(
                  color: AppColors.whiteBase,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.v12),
          Row(
            children: [
              Text(
                '${translate(context, "profile.lv")} $level',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.whiteBase.withOpacity(0.8),
                ),
              ),
              const Spacer(),
              Text(
                '${(progress * 100).toInt()}%',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.whiteBase.withOpacity(0.8),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.v8),
          ClipRRect(
            borderRadius: AppRadius.all02,
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.whiteBase.withOpacity(0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.whiteBase,
              ),
              minHeight: 10.h,
            ),
          ),
          SizedBox(height: AppSpacing.v16),
          ElevatedButton(
            onPressed: onViewProgress,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.whiteBase,
              foregroundColor: AppColors.primary500,
              elevation: 0,
              padding: AppSpacing.symmetric(
                horizontal: AppSpacing.h20,
                vertical: 0,
              ),
              minimumSize: Size(0, 36.h),
              shape: RoundedRectangleBorder(borderRadius: AppRadius.all02),
            ),
            child: Text(
              translate(context, "profile.viewProgress"),
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.primary500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
