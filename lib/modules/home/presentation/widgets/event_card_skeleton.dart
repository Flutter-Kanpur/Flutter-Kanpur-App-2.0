import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';

class EventCardSkeleton extends StatelessWidget {
  const EventCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.h10),
      decoration: BoxDecoration(
        color: AppColors.primary50,
        borderRadius: AppRadius.all06,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image skeleton
          Container(
            width: double.infinity,
            height: 115.h,
            decoration: BoxDecoration(
              color: AppColors.primary100,
              borderRadius: AppRadius.all05,
            ),
          ),

          SizedBox(height: 16.h),

          // Title skeleton
          Container(
            width: double.infinity,
            height: 16.h,
            decoration: BoxDecoration(
              color: AppColors.primary100,
              borderRadius: AppRadius.all02,
            ),
          ),

          SizedBox(height: 8.h),

          // Second text line
          Container(
            width: double.infinity,
            height: 16.h,
            decoration: BoxDecoration(
              color: AppColors.primary100,
              borderRadius: AppRadius.all02,
            ),
          ),

          SizedBox(height: 8.h),

          // Description skeleton
          Container(
            width: double.infinity,
            height: 45.h,
            decoration: BoxDecoration(
              color: AppColors.primary100,
              borderRadius: AppRadius.all02,
            ),
          ),

          SizedBox(height: 8.h),

          // Bottom row
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 28.h,
                  decoration: BoxDecoration(
                    color: AppColors.primary100,
                    borderRadius: AppRadius.all09,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                width: 28.w,
                height: 28.h,
                decoration: BoxDecoration(
                  color: AppColors.primary100,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
