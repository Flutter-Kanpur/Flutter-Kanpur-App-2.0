import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kanpur_ui_kit/flutter_kanpur_ui_kit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';

class OnboardingLinksScreen extends StatelessWidget {
  final VoidCallback onNext;

  const OnboardingLinksScreen({
    super.key,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,

      resizeToAvoidBottomInset: false,

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.h16),

          child: Column(
            children: [

              TextField(
                decoration: InputDecoration(
                  hintText: 'onboarding.githubLink'.tr(),

                  border: OutlineInputBorder(
                    borderRadius: AppRadius.all03,
                  ),
                ),
              ),

              16.verticalSpace,

              TextField(
                decoration: InputDecoration(
                  hintText: 'onboarding.linkedinLink'.tr(),

                  border: OutlineInputBorder(
                    borderRadius: AppRadius.all03,
                  ),
                ),
              ),

              16.verticalSpace,

              TextField(
                decoration: InputDecoration(
                  hintText: 'onboarding.portfolioLink'.tr(),

                  border: OutlineInputBorder(
                    borderRadius: AppRadius.all03,
                  ),
                ),
              ),

              12.verticalSpace,

              Align(
                alignment: Alignment.centerLeft,

                child: Text(
                  'onboarding.editAnytime'.tr(),

                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.pending400),
                ),
              ),

              const Spacer(),

              GradientButton(
                text: 'onboarding.finishSetup'.tr(),
                onTap: onNext,
                height: 48.h,
                width: double.infinity,
              ),

              16.verticalSpace,

              Center(
                child: Text(
                  'onboarding.skipForNow'.tr(),
                ),
              ),

              24.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}