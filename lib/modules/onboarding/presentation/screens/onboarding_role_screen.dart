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
import 'package:flutter_knp_mobile_app_v2/core/constants/app_assets.dart';
import 'package:flutter_knp_mobile_app_v2/core/database/repositories/site_config_repository.dart';
import 'package:flutter_knp_mobile_app_v2/modules/onboarding/application/onboarding_provider.dart';
import 'package:flutter_knp_mobile_app_v2/modules/onboarding/presentation/widgets/onboarding_add_other_chip.dart';
import 'package:flutter_knp_mobile_app_v2/modules/onboarding/presentation/widgets/onboarding_chip.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardingRoleScreen extends ConsumerStatefulWidget {
  const OnboardingRoleScreen({super.key, required this.onNext});

  final VoidCallback onNext;

  @override
  ConsumerState<OnboardingRoleScreen> createState() =>
      _OnboardingRoleScreenState();
}

class _OnboardingRoleScreenState extends ConsumerState<OnboardingRoleScreen> {
  static const _fallbackRoles = [
    'Web Developer',
    'Community Contributor',
    'Student',
    'Flutter Developer',
    'UI / UX Designer',
  ];

  /// ~10 chips visible (≈5 rows × 2), then scroll.
  static double get _chipsMaxHeight => 220.h;

  final _searchController = TextEditingController();
  final _otherController = TextEditingController();
  final _searchFocus = FocusNode();
  final _siteConfig = SiteConfigRepository();

  final List<String> _allRoles = [..._fallbackRoles];
  bool _showAddOther = false;
  bool _loadingCatalog = true;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() {}));
    _searchFocus.addListener(() => setState(() {}));
    Future.microtask(_loadCatalog);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _otherController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  Future<void> _loadCatalog() async {
    final draft = ref.read(onboardingProvider);
    List<String> catalog = _fallbackRoles;

    try {
      final remote = await _siteConfig.fetchStringList(
        SiteConfigRepository.onboardingRolesKey,
      );
      if (remote.isNotEmpty) catalog = remote;
    } catch (_) {}

    if (!mounted) return;
    setState(() {
      _allRoles
        ..clear()
        ..addAll(catalog);
      for (final role in draft.selectedRoles) {
        if (!_allRoles.contains(role)) _allRoles.add(role);
      }
      _loadingCatalog = false;
    });
  }

  List<String> get _filtered {
    final q = _searchController.text.trim().toLowerCase();
    if (q.isEmpty) return _allRoles;
    return _allRoles.where((r) => r.toLowerCase().contains(q)).toList();
  }

  Future<void> _toggle(String role) async {
    final selected = [...ref.read(onboardingProvider).selectedRoles];
    if (selected.contains(role)) {
      selected.remove(role);
    } else {
      selected.add(role);
    }
    await ref.read(onboardingProvider.notifier).setRoles(selected);
  }

  Future<void> _submitOther() async {
    final value = _otherController.text.trim();
    if (value.isEmpty) return;

    if (!_allRoles.any((r) => r.toLowerCase() == value.toLowerCase())) {
      setState(() => _allRoles.add(value));
    }

    try {
      final updated = await _siteConfig.appendToStringList(
        SiteConfigRepository.onboardingRolesKey,
        value,
      );
      if (updated.isNotEmpty && mounted) {
        final selected = ref.read(onboardingProvider).selectedRoles;
        setState(() {
          _allRoles
            ..clear()
            ..addAll(updated);
          for (final role in selected) {
            if (!_allRoles.contains(role)) _allRoles.add(role);
          }
        });
      }
    } catch (_) {}

    final selected = [...ref.read(onboardingProvider).selectedRoles];
    if (!selected.any((r) => r.toLowerCase() == value.toLowerCase())) {
      selected.add(value);
    }
    await ref.read(onboardingProvider.notifier).setRoles(selected);

    if (!mounted) return;
    setState(() {
      _showAddOther = false;
      _otherController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final selected = ref.watch(onboardingProvider).selectedRoles;
    final filtered = _filtered;
    final isSearching = _searchController.text.trim().isNotEmpty;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.h16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _searchController,
            focusNode: _searchFocus,
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

          if (_loadingCatalog)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: _chipsMaxHeight),
                    child: SingleChildScrollView(
                      child: Wrap(
                        spacing: AppSpacing.h10,
                        runSpacing: AppSpacing.v10,
                        children: filtered.map((role) {
                          return OnboardingChip(
                            title: role,
                            isSelected: selected.contains(role),
                            onTap: () => _toggle(role),
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
