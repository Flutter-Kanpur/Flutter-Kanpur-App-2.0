import 'dart:async';

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
import 'package:flutter_knp_mobile_app_v2/core/utils/link_validators.dart';
import 'package:flutter_knp_mobile_app_v2/modules/onboarding/application/onboarding_provider.dart';

class OnboardingLinksScreen extends ConsumerStatefulWidget {
  const OnboardingLinksScreen({super.key, required this.onNext});

  final VoidCallback onNext;

  @override
  ConsumerState<OnboardingLinksScreen> createState() =>
      _OnboardingLinksScreenState();
}

class _OnboardingLinksScreenState extends ConsumerState<OnboardingLinksScreen> {
  late final TextEditingController _githubController;
  late final TextEditingController _linkedinController;
  late final TextEditingController _websiteController;

  LinkStatus _githubStatus = LinkStatus.empty;
  LinkStatus _linkedinStatus = LinkStatus.empty;
  LinkStatus _websiteStatus = LinkStatus.empty;

  LinkKind? _activeKind;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    final draft = ref.read(onboardingProvider);
    _githubController = TextEditingController(text: draft.githubUrl);
    _linkedinController = TextEditingController(text: draft.linkedinUrl);
    _websiteController = TextEditingController(text: draft.websiteUrl);

    _githubStatus = validateLink(draft.githubUrl, LinkKind.github);
    _linkedinStatus = validateLink(draft.linkedinUrl, LinkKind.linkedin);
    _websiteStatus = validateLink(draft.websiteUrl, LinkKind.website);

    _githubController.addListener(() => _onChanged(LinkKind.github));
    _linkedinController.addListener(() => _onChanged(LinkKind.linkedin));
    _websiteController.addListener(() => _onChanged(LinkKind.website));
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _githubController.dispose();
    _linkedinController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  void _onChanged(LinkKind kind) {
    _activeKind = kind;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () async {
      final github = _githubController.text.trim();
      final linkedin = _linkedinController.text.trim();
      final website = _websiteController.text.trim();

      setState(() {
        _githubStatus = validateLink(github, LinkKind.github);
        _linkedinStatus = validateLink(linkedin, LinkKind.linkedin);
        _websiteStatus = validateLink(website, LinkKind.website);
      });

      await ref
          .read(onboardingProvider.notifier)
          .setLinks(
            githubUrl: github,
            linkedinUrl: linkedin,
            websiteUrl: website,
          );
    });
  }

  LinkStatus get _bannerStatus {
    switch (_activeKind) {
      case LinkKind.github:
        return _githubStatus;
      case LinkKind.linkedin:
        return _linkedinStatus;
      case LinkKind.website:
        return _websiteStatus;
      case null:
        return LinkStatus.empty;
    }
  }

  String? get _bannerText {
    final status = _bannerStatus;
    if (status == LinkStatus.valid) {
      switch (_activeKind) {
        case LinkKind.github:
          return 'onboarding.githubLinkDetected'.tr();
        case LinkKind.linkedin:
          return 'onboarding.linkedinLinkDetected'.tr();
        case LinkKind.website:
          return 'onboarding.websiteLinkDetected'.tr();
        case null:
          return null;
      }
    }
    if (status == LinkStatus.invalid) {
      return 'onboarding.invalidLink'.tr();
    }
    return null;
  }

  InputDecoration _decoration({
    required String hint,
    required LinkStatus status,
  }) {
    final error = status == LinkStatus.invalid;
    final borderColor = error ? AppColors.warning600 : AppBorders.secondary;
    final focusedColor = error ? AppColors.warning600 : AppColors.primary500;

    return InputDecoration(
      hintText: hint,
      hintStyle: AppTextStyles.bodyLarge.copyWith(color: AppColors.neutral400),
      filled: true,
      fillColor: AppColors.neutral50,
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppSpacing.h16,
        vertical: AppSpacing.v18,
      ),
      suffixIcon: status == LinkStatus.valid
          ? Padding(
              padding: EdgeInsets.all(12.r),
              child: SvgPicture.asset(
                AppAssets.greenTickIcon,
                width: 20.w,
                height: 20.h,
              ),
            )
          : null,
      enabledBorder: OutlineInputBorder(
        borderRadius: AppRadius.all03,
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppRadius.all03,
        borderSide: BorderSide(color: focusedColor),
      ),
    );
  }

  Widget _banner() {
    final text = _bannerText;
    if (text == null) return const SizedBox.shrink();

    final isValid = _bannerStatus == LinkStatus.valid;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.h16,
        vertical: AppSpacing.v12,
      ),
      decoration: BoxDecoration(
        color: isValid ? AppColors.success50 : AppColors.warning50,
        borderRadius: AppRadius.all03,
      ),
      child: Row(
        children: [
          Icon(
            isValid ? Icons.check_circle : Icons.warning_rounded,
            color: isValid ? AppColors.success600 : AppColors.warning600,
            size: 20.sp,
          ),
          8.horizontalSpace,
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodyMedium.copyWith(
                color: isValid ? AppColors.success700 : AppColors.warning700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.h16),
      child: Column(
        children: [
          TextField(
            controller: _githubController,
            decoration: _decoration(
              hint: 'onboarding.githubLink'.tr(),
              status: _githubStatus,
            ),
          ),
          16.verticalSpace,
          TextField(
            controller: _linkedinController,
            decoration: _decoration(
              hint: 'onboarding.linkedinLink'.tr(),
              status: _linkedinStatus,
            ),
          ),
          16.verticalSpace,
          TextField(
            controller: _websiteController,
            decoration: _decoration(
              hint: 'onboarding.portfolioLink'.tr(),
              status: _websiteStatus,
            ),
          ),
          12.verticalSpace,
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'onboarding.editAnytime'.tr(),
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.pending400,
              ),
            ),
          ),
          const Spacer(),
          _banner(),
          12.verticalSpace,
          GradientButton(
            text: 'onboarding.finishSetup'.tr(),
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
