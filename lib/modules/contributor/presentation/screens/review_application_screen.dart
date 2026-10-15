import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_knp_mobile_app_v2/app/router/route_names.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_borders.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_knp_mobile_app_v2/common_widgets/fk_screen.dart';
import 'package:flutter_knp_mobile_app_v2/modules/contributor/application/contributor_application_provider.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_back_button.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_primary_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../widgets/contributor_application_review_body.dart';
import '../widgets/contributor_info_banner.dart';

class ReviewApplicationScreen extends ConsumerStatefulWidget {
  const ReviewApplicationScreen({super.key});

  @override
  ConsumerState<ReviewApplicationScreen> createState() =>
      _ReviewApplicationScreenState();
}

class _ReviewApplicationScreenState
    extends ConsumerState<ReviewApplicationScreen> {
  bool _isSubmitting = false;

  Future<void> _handleSubmit() async {
    if (_isSubmitting) return;

    setState(() => _isSubmitting = true);

    try {
      await ref.read(contributorApplicationDraftProvider.notifier).submit();
      if (!mounted) return;
      context.push(RouteNames.applicationSubmitted);
    } catch (e) {
      if (!mounted) return;
      final message = e.toString().replaceFirst('Exception: ', '');
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message.isNotEmpty
                ? message
                : 'Failed to submit application. Please try again.',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.whiteBase),
          ),
          backgroundColor: AppColors.neutral950,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final draft = ref.watch(contributorApplicationDraftProvider);

    if (draft == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) context.go(RouteNames.contributorApplication);
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: AppColors.whiteBase,
      body: FkScreen(
        children: [
          Row(
            children: [
              const FkBackButton(
                fallbackPath: RouteNames.contributorApplication,
              ),
              Expanded(
                child: Center(
                  child: Text(
                    'contributor.reviewYourApplication'.tr(),
                    style: AppTextStyles.titleLarge.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.neutral950,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 48), // Balances the 48px IconButton
            ],
          ),
          SizedBox(height: AppSpacing.v22),
          ContributorInfoBanner(
            text: 'contributor.reviewApplicationBanner'.tr(),
          ),
          SizedBox(height: AppSpacing.v22),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.h18,
              vertical: AppSpacing.v20,
            ),
            decoration: BoxDecoration(
              color: AppColors.whiteBase,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: AppBorders.secondary),
            ),
            child: ContributorApplicationReviewBody(draft: draft),
          ),
          SizedBox(height: AppSpacing.v22),
          FkPrimaryButton(
            label: 'contributor.submitApplication'.tr(),
            isLoading: _isSubmitting,
            onPressed: _isSubmitting ? null : _handleSubmit,
          ),
          SizedBox(height: AppSpacing.v12),
          Center(
            child: TextButton(
              onPressed: _isSubmitting
                  ? null
                  : () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        context.go(RouteNames.contributorApplication);
                      }
                    },
              child: Text(
                'contributor.editDetails'.tr(),
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.neutral950,
                ),
              ),
            ),
          ),
          SizedBox(height: AppSpacing.v22),
        ],
      ),
    );
  }
}
