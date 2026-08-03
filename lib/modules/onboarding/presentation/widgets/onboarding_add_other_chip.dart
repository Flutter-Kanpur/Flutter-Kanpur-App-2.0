import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_borders.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_knp_mobile_app_v2/core/constants/app_assets.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';

class OnboardingAddOtherChip extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSubmitted;
  final VoidCallback onCancel;

  const OnboardingAddOtherChip({
    super.key,
    required this.controller,
    required this.onSubmitted,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170.w,
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.h16),
      decoration: BoxDecoration(
        borderRadius: AppRadius.all06,
        border: Border.all(color: AppColors.primary500),
      ), // ← closes BoxDecoration
      child: Row(
        // ← belongs to Container
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onSubmitted: (_) => onSubmitted(),
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                hintText: 'onboarding.addOther'.tr(),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          GestureDetector(
            onTap: onCancel,
            child: SvgPicture.asset(
              AppAssets.crossIcon,
              width: 14.w,
              height: 14.h,
            ),
          ),
        ],
      ),
    );
  }
}
