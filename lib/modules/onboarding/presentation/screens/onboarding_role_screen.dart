import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kanpur_ui_kit/flutter_kanpur_ui_kit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_borders.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';

class OnboardingRoleScreen extends StatelessWidget {
  final VoidCallback onNext;

  const OnboardingRoleScreen({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    final List<String> roles = [
      'Flutter Developer',
      'Backend Developer',
      'Frontend Developer',
      'UI/UX Designer',
      'Android Developer',
      'iOS Developer',
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.s07),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'onboarding.searchRolesHint'.tr(),

              border: OutlineInputBorder(
                borderRadius: AppRadius.all09,
              ),
            ),
          ),

          20.verticalSpace,

          Wrap(
            spacing: AppSpacing.s05,
            runSpacing: AppSpacing.s05,

            children: roles.map((role) {
              return Container(
                padding: AppSpacing.symmetric(horizontal: AppSpacing.s07, vertical: AppSpacing.s05),

                decoration: BoxDecoration(
                  borderRadius: AppRadius.all06,

                  border: Border.all(color: AppBorders.secondary),
                ),

                child: Text(role),
              );
            }).toList(),
          ),

          16.verticalSpace,

          Text(
            'onboarding.addOther'.tr(),

            style: AppTextStyles.bodyLarge.copyWith(color: AppColors.primary500),
          ),

          const Spacer(),

          GradientButton(
            text: 'onboarding.continue'.tr(),
            onTap: onNext,
            height: 48.h,
            width: double.infinity,
          ),

          16.verticalSpace,

          Center(child: Text('onboarding.skipForNow'.tr())),

          24.verticalSpace,
        ],
      ),
    );
  }
}
