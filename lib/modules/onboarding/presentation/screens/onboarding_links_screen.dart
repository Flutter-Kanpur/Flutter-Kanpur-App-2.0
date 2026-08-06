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
  final _githubFocus = FocusNode();
  final _linkedinFocus = FocusNode();
  final _websiteFocus = FocusNode();

  LinkStatus _githubStatus = LinkStatus.empty;
  LinkStatus _linkedinStatus = LinkStatus.empty;
  LinkStatus _websiteStatus = LinkStatus.empty;

  LinkKind? _activeKind;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    final draft = ref.read(onboardingProvider);

    _githubController = TextEditingController(
      text: usernameFromGithubUrl(draft.githubUrl),
    );
    _linkedinController = TextEditingController(
      text: usernameFromLinkedinUrl(draft.linkedinUrl),
    );
    _websiteController = TextEditingController(text: draft.websiteUrl);

    _githubStatus = validateUsername(_githubController.text);
    _linkedinStatus = validateUsername(_linkedinController.text);
    _websiteStatus = validateLink(draft.websiteUrl, LinkKind.website);

    _githubController.addListener(() => _onChanged(LinkKind.github));
    _linkedinController.addListener(() => _onChanged(LinkKind.linkedin));
    _websiteController.addListener(() => _onChanged(LinkKind.website));
    _githubFocus.addListener(() {
      if (!_githubFocus.hasFocus) _validateField(LinkKind.github);
    });
    _linkedinFocus.addListener(() {
      if (!_linkedinFocus.hasFocus) _validateField(LinkKind.linkedin);
    });
    _websiteFocus.addListener(() {
      if (!_websiteFocus.hasFocus) _validateField(LinkKind.website);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _githubController.dispose();
    _linkedinController.dispose();
    _websiteController.dispose();
    _githubFocus.dispose();
    _linkedinFocus.dispose();
    _websiteFocus.dispose();
    super.dispose();
  }

  void _onChanged(LinkKind kind) {
    _activeKind = kind;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () async {
      final githubUser = _githubController.text.trim();
      final linkedinUser = _linkedinController.text.trim();
      final website = _websiteController.text.trim();

      setState(() {
        switch (kind) {
          case LinkKind.github:
            _githubStatus = LinkStatus.empty;
          case LinkKind.linkedin:
            _linkedinStatus = LinkStatus.empty;
          case LinkKind.website:
            _websiteStatus = LinkStatus.empty;
        }
      });

      await ref
          .read(onboardingProvider.notifier)
          .setLinks(
            githubUrl: buildGithubUrl(githubUser),
            linkedinUrl: buildLinkedinUrl(linkedinUser),
            websiteUrl: website,
          );
    });
  }

  void _validateField(LinkKind kind) {
    _activeKind = kind;
    setState(() {
      switch (kind) {
        case LinkKind.github:
          _githubStatus = validateUsername(_githubController.text);
        case LinkKind.linkedin:
          _linkedinStatus = validateUsername(_linkedinController.text);
        case LinkKind.website:
          _websiteStatus = validateLink(
            _websiteController.text,
            LinkKind.website,
          );
      }
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
    final hintTextStyle = AppTextStyles.bodyLarge.copyWith(
      color: AppColors.neutral400,
    );

    return InputDecoration(
      hintText: hint.isEmpty ? null : hint,
      hintStyle: hintTextStyle,
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

  Widget _usernameField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String prefix,
    required LinkStatus status,
  }) {
    final error = status == LinkStatus.invalid;
    final focused = focusNode.hasFocus;
    final borderColor = error
        ? AppColors.warning600
        : focused
        ? AppColors.primary500
        : AppBorders.secondary;
    final prefixStyle = AppTextStyles.bodyLarge.copyWith(
      color: AppColors.neutral400,
    );

    return Container(
      padding: EdgeInsets.only(left: AppSpacing.h16),
      decoration: BoxDecoration(
        color: AppColors.neutral50,
        borderRadius: AppRadius.all03,
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Text(prefix, style: prefixStyle),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode, // must wire this
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.blackBase,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                // ... rest unchanged
              ),
            ),
          ),
        ],
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
          _usernameField(
            controller: _githubController,
            focusNode: _githubFocus,
            prefix: 'github.com/',
            status: _githubStatus,
          ),
          16.verticalSpace,
          _usernameField(
            controller: _linkedinController,
            focusNode: _linkedinFocus,
            prefix: 'linkedin.com/in/',
            status: _linkedinStatus,
          ),
          16.verticalSpace,
          TextField(
            controller: _websiteController,
            focusNode: _websiteFocus,
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
          24.verticalSpace,
        ],
      ),
    );
  }
}
