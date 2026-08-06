import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kanpur_ui_kit/flutter_kanpur_ui_kit.dart';
import 'package:flutter_knp_mobile_app_v2/core/constants/app_assets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_knp_mobile_app_v2/app/router/route_names.dart';

class OnboardingSuccessScreen extends StatelessWidget {
  const OnboardingSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteBase,

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.h16),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              SvgPicture.asset(
                AppAssets.successIcon,
                width: 220.w,
                height: 220.h,
              ),

              32.verticalSpace,

              Text(
                'onboarding.successTitle'.tr(),

                textAlign: TextAlign.center,

                style: AppTextStyles.headlineSmall.copyWith(
                  color: AppColors.blackBase,
                  fontWeight: FontWeight.w700,
                ),
              ),

              12.verticalSpace,

              Text(
                'onboarding.successSubTitle'.tr(),

                textAlign: TextAlign.center,

                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.neutral500,
                  height: 1.5,
                ),
              ),

              48.verticalSpace,

              GradientButton(
                text: 'onboarding.redirectToHome'.tr(),
                onTap: () => context.go(RouteNames.home),
                height: 48.h,
                width: double.infinity,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
