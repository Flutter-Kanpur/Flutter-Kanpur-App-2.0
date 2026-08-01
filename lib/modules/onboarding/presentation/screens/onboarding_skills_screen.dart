import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kanpur_ui_kit/flutter_kanpur_ui_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_borders.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_knp_mobile_app_v2/core/constants/app_assets.dart';
import 'package:flutter_knp_mobile_app_v2/modules/onboarding/application/onboarding_provider.dart';
import 'package:flutter_knp_mobile_app_v2/modules/onboarding/presentation/widgets/onboarding_add_other_chip.dart';
import 'package:flutter_knp_mobile_app_v2/modules/onboarding/presentation/widgets/onboarding_chip.dart';
import 'package:flutter_knp_mobile_app_v2/modules/onboarding/presentation/widgets/onboarding_experience_dropdown.dart';

class OnboardingSkillsScreen extends ConsumerStatefulWidget {
  const OnboardingSkillsScreen({super.key, required this.onNext});

  final VoidCallback onNext;

  @override
  ConsumerState<OnboardingSkillsScreen> createState() =>
      _OnboardingSkillsScreenState();
}

class _OnboardingSkillsScreenState
    extends ConsumerState<OnboardingSkillsScreen> {
  static const _defaultSkills = [
    'Flutter',
    'Firebase',
    'Dart',
    'UI Design',
    'Git',
    'Supabase',
  ];

  static const _yearOptions = [1, 2, 3, 4];

  final _searchController = TextEditingController();
  final _otherController = TextEditingController();
  final List<String> _allSkills = [..._defaultSkills];
  bool _showAddOther = false;

  @override
  void initState() {
    super.initState();
    final draft = ref.read(onboardingProvider);
    for (final skill in draft.selectedSkills) {
      if (!_allSkills.contains(skill)) _allSkills.add(skill);
    }
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    _otherController.dispose();
    super.dispose();
  }

  List<String> get _filtered {
    final q = _searchController.text.trim().toLowerCase();
    if (q.isEmpty) return _allSkills;
    return _allSkills.where((s) => s.toLowerCase().contains(q)).toList();
  }

  String _yearsLabel(int? years) {
    if (years == null) return '';
    if (years == 1) return 'onboarding.experience1Year'.tr();
    return 'onboarding.experience${years}Years'.tr();
  }

  Future<void> _pickYears() async {
    final selected = await showModalBottomSheet<int>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _yearOptions.map((y) {
              return ListTile(
                title: Text(_yearsLabel(y)),
                onTap: () => Navigator.pop(context, y),
              );
            }).toList(),
          ),
        );
      },
    );
    if (selected != null) {
      await ref
          .read(onboardingProvider.notifier)
          .setYearsOfExperience(selected);
    }
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
    if (!_allSkills.contains(value)) {
      setState(() => _allSkills.add(value));
    }
    final selected = [...ref.read(onboardingProvider).selectedSkills];
    if (!selected.contains(value)) selected.add(value);
    await ref.read(onboardingProvider.notifier).setSkills(selected);
    setState(() {
      _showAddOther = false;
      _otherController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final draft = ref.watch(onboardingProvider);
    final selected = draft.selectedSkills;
    final filtered = _filtered;
    final isSearching = _searchController.text.trim().isNotEmpty;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.h16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OnboardingExperienceDropdown(
            selectedValue: _yearsLabel(draft.yearsOfExperience),
            onTap: _pickYears,
          ),
          16.verticalSpace,
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'onboarding.searchRolesHint'.tr(),
              hintStyle: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.neutral400,
              ),
              suffixIcon: Padding(
                padding: EdgeInsets.all(12.r),
                child: SvgPicture.asset(
                  AppAssets.searchIcon,
                  width: 16.w,
                  height: 16.h,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: AppRadius.all09,
                borderSide: BorderSide(color: AppBorders.secondary),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: AppRadius.all09,
                borderSide: const BorderSide(color: AppColors.primary500),
              ),
            ),
          ),
          if (isSearching) ...[
            12.verticalSpace,
            Text(
              filtered.isEmpty
                  ? 'onboarding.noMatchingResultsFound'.tr()
                  : 'onboarding.resultsFound'.tr(args: ['${filtered.length}']),
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.neutral400,
              ),
            ),
          ],
          16.verticalSpace,
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: AppSpacing.h10,
                    runSpacing: AppSpacing.v10,
                    children: filtered.map((skill) {
                      return OnboardingChip(
                        title: skill,
                        isSelected: selected.contains(skill),
                        onTap: () => _toggle(skill),
                      );
                    }).toList(),
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
                      onTap: () => setState(() => _showAddOther = true),
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
