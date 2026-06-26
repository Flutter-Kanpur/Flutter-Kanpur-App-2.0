import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF7A7A7A),
      ),
    );
  }
}