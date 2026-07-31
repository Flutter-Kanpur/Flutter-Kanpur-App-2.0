import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/core/constants/app_assets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';

class OnboardingProfileAvatar extends StatelessWidget {
  const OnboardingProfileAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,

      children: [
        CircleAvatar(
          radius: 50.r,
          backgroundColor: AppColors.neutral50,

          child: Image.asset(AppAssets.dashIcon, width: 40.w),
        ),

        Positioned(
          bottom: 4,
          right: 4,

          child: CircleAvatar(
            radius: 14.r,
            backgroundColor: AppColors.primary500,

            child: Icon(Icons.add, color: AppColors.whiteBase, size: 18.sp),
          ),
        ),
      ],
    );
  }
}
