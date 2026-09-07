import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';

import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback? onTap;

  const CategoryCard({
    super.key,
    required this.title,
    required this.description,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200.w,
        padding: AppSpacing.all(AppSpacing.h16),
        decoration: BoxDecoration(
          color: AppColors.primary50,
          borderRadius: AppRadius.all04,
        ),
       child: Column(
  mainAxisSize: MainAxisSize.min,
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
      title,
      style: AppTextStyles.titleMedium.copyWith(
        color: AppColors.blackBase,
      ),
    ),
    SizedBox(height: AppSpacing.v6),
    Text(
      description,
      style: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.neutral400,
      ),
    ),
  ],
),
      ),
    );
  }
}
