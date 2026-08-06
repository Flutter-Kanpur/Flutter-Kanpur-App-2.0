import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kanpur_ui_kit/flutter_kanpur_ui_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_borders.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_knp_mobile_app_v2/core/database/repositories/site_config_repository.dart';
import 'package:flutter_knp_mobile_app_v2/modules/onboarding/application/onboarding_provider.dart';
import 'package:flutter_knp_mobile_app_v2/modules/onboarding/presentation/widgets/onboarding_add_other_chip.dart';
import 'package:flutter_knp_mobile_app_v2/modules/onboarding/presentation/widgets/onboarding_chip.dart';

class OnboardingSkillsScreen extends ConsumerStatefulWidget {
  const OnboardingSkillsScreen({super.key, required this.onNext});

  final VoidCallback onNext;

  @override
  ConsumerState<OnboardingSkillsScreen> createState() =>
      _OnboardingSkillsScreenState();
}

class _OnboardingSkillsScreenState
    extends ConsumerState<OnboardingSkillsScreen> {
  static const _fallbackSkills = [
    'Flutter',
    'Firebase',
    'Dart',
    'UI Design',
    'Git',
    'Supabase',
  ];

  static const _yearOptions = [1, 2, 3, 4];

  static double get _chipsMaxHeight => 220.h;

  final _otherController = TextEditingController();
  final _siteConfig = SiteConfigRepository();
  final List<String> _allSkills = [..._fallbackSkills];
  bool _showAddOther = false;
  bool _yearsOpen = false;
  bool _loadingCatalog = true;

  @override
  void initState() {
    super.initState();
    Future.microtask(_loadCatalog);
  }

  @override
  void dispose() {
    _otherController.dispose();
    super.dispose();
  }

  Future<void> _loadCatalog() async {
    final draft = ref.read(onboardingProvider);
    List<String> catalog = _fallbackSkills;

    try {
      final remote = await _siteConfig.fetchStringList(
        SiteConfigRepository.onboardingSkillsKey,
      );
      if (remote.isNotEmpty) catalog = remote;
    } catch (_) {}

    if (!mounted) return;
    setState(() {
      _allSkills
        ..clear()
        ..addAll(catalog);
      for (final skill in draft.selectedSkills) {
        if (!_allSkills.contains(skill)) _allSkills.add(skill);
      }
      _loadingCatalog = false;
    });
  }

  String _yearsLabel(int? years) {
    if (years == null) return '';
    if (years == 1) return 'onboarding.experience1Year'.tr();
    return 'onboarding.experience${years}Years'.tr();
  }

  Future<void> _toggle(String skill) async {
    final selected = [...ref.read(onboardingProvider).selectedSkills];
    if (selected.contains(skill)) {
      selected.remove(skill);
    } else {
      selected.add(skill);
    }
    await ref.read(onboardingProvider.notifier).setSkills(selected);
  }

  Future<void> _submitOther() async {
    final value = _otherController.text.trim();
    if (value.isEmpty) return;

    if (!_allSkills.any((s) => s.toLowerCase() == value.toLowerCase())) {
      setState(() => _allSkills.add(value));
    }

    try {
      final updated = await _siteConfig.appendToStringList(
        SiteConfigRepository.onboardingSkillsKey,
        value,
      );
      if (updated.isNotEmpty && mounted) {
        final selected = ref.read(onboardingProvider).selectedSkills;
        setState(() {
          _allSkills
            ..clear()
            ..addAll(updated);
          for (final skill in selected) {
            if (!_allSkills.contains(skill)) _allSkills.add(skill);
          }
        });
      }
    } catch (_) {}

    final selected = [...ref.read(onboardingProvider).selectedSkills];
    if (!selected.any((s) => s.toLowerCase() == value.toLowerCase())) {
      selected.add(value);
    }
    await ref.read(onboardingProvider.notifier).setSkills(selected);

    if (!mounted) return;
    setState(() {
      _showAddOther = false;
      _otherController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final draft = ref.watch(onboardingProvider);
    final selected = draft.selectedSkills;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.h16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => setState(() => _yearsOpen = !_yearsOpen),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
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
                            Text(
                              _yearsLabel(draft.yearsOfExperience).isEmpty
                                  ? 'onboarding.yearsOfExperience'.tr()
                                  : _yearsLabel(draft.yearsOfExperience),
                              style: AppTextStyles.titleSmall.copyWith(
                                color:
                                    _yearsLabel(draft.yearsOfExperience).isEmpty
                                    ? AppColors.neutral400
                                    : AppColors.blackBase,
                              ),
                            ),
                            Icon(
                              _yearsOpen
                                  ? Icons.keyboard_arrow_up_rounded
                                  : Icons.keyboard_arrow_down_rounded,
                              size: 24.sp,
                            ),
                          ],
                        ),
                      ),
                    ),
                    16.verticalSpace,
                    Text(
                      'onboarding.addSkills'.tr(),
                      style: AppTextStyles.titleSmall.copyWith(
                        color: AppColors.blackBase,
                      ),
                    ),
                    12.verticalSpace,
                    if (_loadingCatalog)
                      const Expanded(
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight: _chipsMaxHeight,
                              ),
                              child: SingleChildScrollView(
                                child: Wrap(
                                  spacing: AppSpacing.h10,
                                  runSpacing: AppSpacing.v10,
                                  children: _allSkills.map((skill) {
                                    return OnboardingChip(
                                      title: skill,
                                      isSelected: selected.contains(skill),
                                      onTap: () => _toggle(skill),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            16.verticalSpace,
                            if (_showAddOther)
                              OnboardingAddOtherChip(
                                controller: _otherController,
                                onSubmitted: _submitOther,
                                onCancel: () {
                                  setState(() {
                                    _showAddOther = false;
                                    _otherController.clear();
                                  });
                                },
                              )
                            else
                              GestureDetector(
                                onTap: () =>
                                    setState(() => _showAddOther = true),
                                child: Text(
                                  'onboarding.addOther'.tr(),
                                  style: AppTextStyles.bodyLarge.copyWith(
                                    color: AppColors.primary500,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                  ],
                ),

                if (_yearsOpen)
                  Positioned(
                    top: 56.h + AppSpacing.v8,
                    right: 0,
                    child: Material(
                      color: Colors.transparent,
                      child: Container(
                        width: 220.w,
                        height: 216.h,
                        padding: EdgeInsets.all(AppSpacing.h8),
                        decoration: BoxDecoration(
                          color: AppColors.whiteBase,
                          borderRadius: AppRadius.all06,
                          border: Border.all(
                            color: AppBorders.secondary,
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.blackBase.withValues(
                                alpha: 0.12,
                              ),
                              blurRadius: 15,
                              offset: Offset.zero,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            for (var i = 0; i < _yearOptions.length; i++) ...[
                              if (i > 0) SizedBox(height: AppSpacing.v8),
                              Expanded(
                                child: InkWell(
                                  borderRadius: AppRadius.all02,
                                  onTap: () async {
                                    await ref
                                        .read(onboardingProvider.notifier)
                                        .setYearsOfExperience(_yearOptions[i]);
                                    setState(() => _yearsOpen = false);
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: AppSpacing.h12,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          draft.yearsOfExperience ==
                                              _yearOptions[i]
                                          ? AppColors.primary50
                                          : AppColors.whiteBase,
                                      borderRadius: AppRadius.all02,
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            _yearsLabel(_yearOptions[i]),
                                            style: AppTextStyles.bodyLarge
                                                .copyWith(
                                                  color: AppColors.blackBase,
                                                ),
                                          ),
                                        ),
                                        if (draft.yearsOfExperience ==
                                            _yearOptions[i])
                                          Icon(
                                            Icons.check,
                                            color: AppColors.blackBase,
                                            size: 18.sp,
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          GradientButton(
            text: 'onboarding.continue'.tr(),
            onTap: widget.onNext,
            height: 48.h,
            width: double.infinity,
          ),
          16.verticalSpace,
          Center(
            child: GestureDetector(
              onTap: widget.onNext,
              child: Text('onboarding.skipForNow'.tr()),
            ),
          ),
          24.verticalSpace,
        ],
      ),
    );
  }
}
