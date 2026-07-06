import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/onboarding_progress_bar.dart';
import 'onboarding_links_screen.dart';
import 'onboarding_profile_screen.dart';
import 'onboarding_role_screen.dart';
import 'onboarding_skills_screen.dart';

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
      backgroundColor: Colors.white,

      resizeToAvoidBottomInset: false,

      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),

              child: OnboardingProgressBar(currentStep: _currentStep),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),

              child: Column(
                children: [
                  Text(
                    _titles[_currentStep],

                    textAlign: TextAlign.center,

                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),

                  15.verticalSpace,

                  Text(
                    _subtitles[_currentStep],

                    textAlign: TextAlign.center,

                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF7A7A7A),
                    ),
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
