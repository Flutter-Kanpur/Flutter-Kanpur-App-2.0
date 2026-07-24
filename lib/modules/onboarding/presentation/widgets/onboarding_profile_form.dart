import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_borders.dart';

class OnboardingProfileForm extends StatelessWidget {
  const OnboardingProfileForm({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'onboarding.fullName'.tr(),

        filled: true,
        fillColor: AppColors.neutral50,

        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSpacing.s07,
          vertical: AppSpacing.s08,
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

          borderSide: const BorderSide(
            color: AppBorders.primary,
          ),
        ),
      ),
    );
  }
}