import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_knp_mobile_app_v2/app/router/route_names.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_knp_mobile_app_v2/modules/onboarding/application/onboarding_provider.dart';
import '../widgets/onboarding_progress_bar.dart';
import 'onboarding_links_screen.dart';
import 'onboarding_profile_screen.dart';
import 'onboarding_role_screen.dart';
import 'onboarding_skills_screen.dart';

class OnboardingNavigationScreen extends ConsumerStatefulWidget {
  const OnboardingNavigationScreen({super.key});

  @override
  ConsumerState<OnboardingNavigationScreen> createState() =>
      _OnboardingNavigationScreenState();
}

class _OnboardingNavigationScreenState
    extends ConsumerState<OnboardingNavigationScreen> {
  PageController? _pageController;
  bool _restored = false;

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

  @override
  void initState() {
    super.initState();
    Future.microtask(_restore);
  }

  Future<void> _restore() async {
    await ref.read(onboardingProvider.notifier).restoreFromPrefs();
    if (!mounted) return;

    final step = ref.read(onboardingProvider).currentStep.clamp(0, 3);
    _pageController = PageController(initialPage: step);
    setState(() => _restored = true);
  }

  Future<void> _nextStep() async {
    final notifier = ref.read(onboardingProvider.notifier);
    final step = ref.read(onboardingProvider).currentStep;

    if (step == 3) {
      final ok = await notifier.finish();
      if (!mounted) return;
      if (ok) {
        context.go(RouteNames.onboardingSuccess);
      } else {
        final err = ref.read(onboardingProvider).error;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(err ?? 'onboarding.saveFailed'.tr())),
        );
      }
      return;
    }

    final next = step + 1;
    await notifier.setStep(next);
    if (!mounted) return;
    await _pageController!.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final draft = ref.watch(onboardingProvider);
    final step = draft.currentStep.clamp(0, 3);

    if (!_restored || _pageController == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.whiteBase,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.h16,
                vertical: AppSpacing.v22,
              ),
              child: OnboardingProgressBar(currentStep: step),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.h16),
              child: Column(
                children: [
                  Text(
                    _titles[step],
                    textAlign: TextAlign.center,
                    style: AppTextStyles.headlineSmall.copyWith(
                      color: AppColors.blackBase,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  10.verticalSpace,
                  Text(
                    _subtitles[step],
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.neutral500,
                    ),
                  ),
                ],
              ),
            ),
            25.verticalSpace,
            Expanded(
              child: PageView(
                controller: _pageController!,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  ref.read(onboardingProvider.notifier).setStep(index);
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