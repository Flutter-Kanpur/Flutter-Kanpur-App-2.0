import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';

class FilterTabsSkeleton extends StatelessWidget {
  const FilterTabsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.h16),
      child: Row(
        children: [
          _SkeletonChip(width: 42.w),
          SizedBox(width: 6.w),
          _SkeletonChip(width: 64.w),
          SizedBox(width: 6.w),
          _SkeletonChip(width: 82.w),
          SizedBox(width: 6.w),
          Expanded(child: _SkeletonChip(width: double.infinity)),
        ],
      ),
    );
  }
}

class _SkeletonChip extends StatelessWidget {
  const _SkeletonChip({required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 20.h,
      decoration: BoxDecoration(
        color: AppColors.primary50,
        borderRadius: AppRadius.all02,
      ),
    );
  }
}
