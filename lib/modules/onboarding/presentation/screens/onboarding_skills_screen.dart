import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kanpur_ui_kit/flutter_kanpur_ui_kit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_borders.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';

class OnboardingSkillsScreen extends StatelessWidget {
  final VoidCallback onNext;

  const OnboardingSkillsScreen({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    final List<String> skills = [
      'Flutter',
      'Firebase',
      'Dart',
      'UI Design',
      'Git',
      'Supabase',
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,

      resizeToAvoidBottomInset: false,

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.h16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Container(
                padding: AppSpacing.symmetric(
                  horizontal: AppSpacing.h16,
                  vertical: AppSpacing.v16,
                ),

                decoration: BoxDecoration(
                  borderRadius: AppRadius.all03,

                  border: Border.all(color: AppBorders.secondary),
                ),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    Text('onboarding.yearsOfExperience'.tr()),

                    const Icon(Icons.keyboard_arrow_down_rounded),
                  ],
                ),
              ),

              20.verticalSpace,

              Wrap(
                spacing: AppSpacing.h10,
                runSpacing: AppSpacing.v10,

                children: skills.map((skill) {
                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.h16,
                      vertical: AppSpacing.v10,
                    ),

                    decoration: BoxDecoration(
                      borderRadius: AppRadius.all06,

                      border: Border.all(color: AppBorders.secondary),
                    ),

                    child: Text(skill),
                  );
                }).toList(),
              ),

              16.verticalSpace,

              Text(
                'onboarding.addOther'.tr(),

                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.primary500,
                ),
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
        ),
      ),
    );
  }
}
