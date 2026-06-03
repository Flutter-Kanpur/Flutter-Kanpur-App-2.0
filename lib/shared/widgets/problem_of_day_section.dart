import 'package:flutter/material.dart';
import '../../../utils/translate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/colors.dart';
import '../../../utils/text_styles.dart';

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
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF4167F2),
            Color(0xFF6B8EFF),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                translate(context, "profile.problemOfDay"),
                style: textStyle_18BoldBlack().copyWith(
                  color: Colors.white,
                  fontSize: 18.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Text(
                '${translate(context, "profile.lv")} $level',
                style: textStyle_14RegularBlack().copyWith(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                '${(progress * 100).toInt()}%',
                style: textStyle_14RegularBlack().copyWith(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white.withOpacity(0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              minHeight: 10.h,
            ),
          ),
          SizedBox(height: 16.h),
          ElevatedButton(
            onPressed: onViewProgress,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.selectedNavBarIconColor,
              elevation: 0,
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20.w),
              minimumSize: Size(0, 36.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            child: Text(
              translate(context, "profile.viewProgress"),
              style: textStyle_14RegularBlack().copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.selectedNavBarIconColor,
                fontSize: 12.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
