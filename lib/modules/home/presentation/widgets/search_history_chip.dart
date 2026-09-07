import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';

class SearchHistoryChip extends StatelessWidget {
  const SearchHistoryChip({
    super.key,
    required this.label,
    this.onTap,
    this.onRemove,
    this.showRemoveIcon = false,
  });

  final String label;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;
  final bool showRemoveIcon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.h10,
          vertical: AppSpacing.v6,
        ),
        decoration: BoxDecoration(
          color: AppColors.neutral100,
          borderRadius: AppRadius.all03,
          border: Border.all(color: AppColors.neutral200),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.history, size: 15.sp, color: AppColors.neutral500),

            SizedBox(width: 5.w),

            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.neutral700,
              ),
            ),

            if (showRemoveIcon) ...[
              SizedBox(width: 5.w),
              GestureDetector(
                onTap: onRemove,
                child: Icon(
                  Icons.close,
                  size: 14.sp,
                  color: AppColors.neutral500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
