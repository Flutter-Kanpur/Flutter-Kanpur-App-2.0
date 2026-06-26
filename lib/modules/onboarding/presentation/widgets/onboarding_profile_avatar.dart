import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/core/constants/app_assets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingProfileAvatar extends StatelessWidget {
  const OnboardingProfileAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,

      children: [

        CircleAvatar(
          radius: 50.r,
          backgroundColor: const Color(0xFFF5F5F5),

          child: Image.asset(
            AppAssets.dashIcon,
            width: 40.w,
          ),
        ),

        Positioned(
          bottom: 4,
          right: 4,

          child: CircleAvatar(
            radius: 14.r,
            backgroundColor: const Color(0xFF4167F2),

            child: Icon(
              Icons.add,
              color: Colors.white,
              size: 18.sp,
            ),
          ),
        ),
      ],
    );
  }
}