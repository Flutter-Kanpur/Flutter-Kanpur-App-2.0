import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';

class OnboardingResultsText extends StatelessWidget {
  final bool hasResults;
  final int resultsCount;

  const OnboardingResultsText({
    super.key,
    required this.hasResults,
    required this.resultsCount,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      hasResults
          ? '$resultsCount ${'onboarding.resultsFound'.tr()}'
          : 'onboarding.noRolesFound'.tr(),

      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.neutral500),
    );
  }
}
