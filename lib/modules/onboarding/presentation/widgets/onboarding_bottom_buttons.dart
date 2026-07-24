import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kanpur_ui_kit/flutter_kanpur_ui_kit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';

class OnboardingBottomButtons extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPrimaryTap;
  final VoidCallback? onSecondaryTap;
  final bool showSecondaryButton;

  const OnboardingBottomButtons({
    super.key,
    required this.buttonText,
    required this.onPrimaryTap,
    this.onSecondaryTap,
    this.showSecondaryButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        GradientButton(
          text: buttonText,
          onTap: onPrimaryTap,
          height: 48.h,
          width: double.infinity,
        ),

        if (showSecondaryButton) ...[

          16.verticalSpace,

          GestureDetector(
            onTap: onSecondaryTap,

            child: Center(
              child: Text(
                'onboarding.skipForNow'.tr(),

                style: AppTextStyles.titleSmall.copyWith(color: AppColors.blackBase),
              ),
            ),
          ),
        ],
      ],
    );
  }
}