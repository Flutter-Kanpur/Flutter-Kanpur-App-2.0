import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_borders.dart';

class OnboardingAddOtherChip extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSubmitted;

  const OnboardingAddOtherChip({
    super.key,
    required this.controller,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170.w,

      padding: EdgeInsets.symmetric(horizontal: AppSpacing.h16),

      decoration: BoxDecoration(
        borderRadius: AppRadius.all06,

        border: Border.all(color: AppBorders.primary),
      ),

      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,

              decoration: InputDecoration(
                hintText: 'onboarding.addOther'.tr(),

                border: InputBorder.none,

                isDense: true,
              ),
            ),
          ),

          GestureDetector(
            onTap: onSubmitted,

            child: Icon(Icons.check, size: 18.sp),
          ),
        ],
      ),
    );
  }
}
