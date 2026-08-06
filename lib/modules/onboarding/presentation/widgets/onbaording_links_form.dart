import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_borders.dart';

class OnboardingLinksForm extends StatelessWidget {
  const OnboardingLinksForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            hintText: 'onboarding.githubLink'.tr(),

            filled: true,
            fillColor: AppColors.neutral50,

            contentPadding: EdgeInsets.symmetric(
              horizontal: AppSpacing.h16,
              vertical: AppSpacing.v18,
            ),

            border: OutlineInputBorder(
              borderRadius: AppRadius.all03,
              borderSide: BorderSide.none,
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: AppRadius.all03,
              borderSide: BorderSide.none,
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: AppRadius.all03,

              borderSide: const BorderSide(color: AppBorders.primary),
            ),
          ),
        ),

        16.verticalSpace,

        TextField(
          decoration: InputDecoration(
            hintText: 'onboarding.linkedinLink'.tr(),

            filled: true,
            fillColor: AppColors.neutral50,

            contentPadding: EdgeInsets.symmetric(
              horizontal: AppSpacing.h16,
              vertical: AppSpacing.v18,
            ),

            border: OutlineInputBorder(
              borderRadius: AppRadius.all03,
              borderSide: BorderSide.none,
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: AppRadius.all03,
              borderSide: BorderSide.none,
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: AppRadius.all03,

              borderSide: const BorderSide(color: AppBorders.primary),
            ),
          ),
        ),

        16.verticalSpace,

        TextField(
          decoration: InputDecoration(
            hintText: 'onboarding.portfolioLink'.tr(),

            filled: true,
            fillColor: AppColors.neutral50,

            contentPadding: EdgeInsets.symmetric(
              horizontal: AppSpacing.h16,
              vertical: AppSpacing.v18,
            ),

            border: OutlineInputBorder(
              borderRadius: AppRadius.all03,
              borderSide: BorderSide.none,
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: AppRadius.all03,
              borderSide: BorderSide.none,
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: AppRadius.all03,

              borderSide: const BorderSide(color: AppBorders.primary),
            ),
          ),
        ),

        12.verticalSpace,

        Align(
          alignment: Alignment.centerLeft,

          child: Text(
            'onboarding.editAnytime'.tr(),

            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.pending400,
            ),
          ),
        ),
      ],
    );
  }
}
