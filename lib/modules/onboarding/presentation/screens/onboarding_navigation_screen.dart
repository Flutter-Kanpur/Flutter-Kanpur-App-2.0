import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/onboarding_progress_bar.dart';
import 'onboarding_links_screen.dart';
import 'onboarding_profile_screen.dart';
import 'onboarding_role_screen.dart';
import 'onboarding_skills_screen.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';

class OnboardingNavigationScreen extends StatefulWidget {
  const OnboardingNavigationScreen({super.key});

  @override
  State<OnboardingNavigationScreen> createState() =>
      _OnboardingNavigationScreenState();
}

class _OnboardingNavigationScreenState
    extends State<OnboardingNavigationScreen> {
  final PageController _pageController = PageController();

  int _currentStep = 0;

  final List<String> _titles = [
    'onboarding.screen1Title'.tr(),
    'onboarding.screen2Title'.tr(),
    'onboarding.screen3Title'.tr(),
    'onboarding.screen4Title'.tr(),
  ];

  final List<String> _subtitles = [
    'onboarding.screen1SubTitle'.tr(),
    'onboarding.screen2SubTitle'.tr(),
    'onboarding.screen3SubTitle'.tr(),
    'onboarding.screen4SubTitle'.tr(),
  ];

  void _nextStep() {
    if (_currentStep == 3) {
      return;
    }

    setState(() => _currentStep++);

    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteBase,

      resizeToAvoidBottomInset: false,

      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.h16, vertical: AppSpacing.v10),

              child: OnboardingProgressBar(currentStep: _currentStep),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.h16),

              child: Column(
                children: [
                  Text(
                    _titles[_currentStep],

                    textAlign: TextAlign.center,

                    style: AppTextStyles.headlineSmall.copyWith(color: AppColors.blackBase, fontWeight: FontWeight.w700),
                  ),

                  15.verticalSpace,

                  Text(
                    _subtitles[_currentStep],

                    textAlign: TextAlign.center,

                    style: AppTextStyles.bodyLarge.copyWith(color: AppColors.neutral500),
                  ),
                ],
              ),
            ),

            25.verticalSpace,

            Expanded(
              child: PageView(
                controller: _pageController,

                physics: const NeverScrollableScrollPhysics(),

                onPageChanged: (index) {
                  setState(() => _currentStep = index);
                },

                children: [
                  OnboardingProfileScreen(onNext: _nextStep),

                  OnboardingRoleScreen(onNext: _nextStep),

                  OnboardingSkillsScreen(onNext: _nextStep),

                  OnboardingLinksScreen(onNext: _nextStep),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
