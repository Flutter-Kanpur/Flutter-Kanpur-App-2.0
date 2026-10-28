import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_knp_mobile_app_v2/app/router/route_names.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_back_button.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_primary_button.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/gradient_background.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_knp_mobile_app_v2/utils/assets_path.dart';
import 'package:go_router/go_router.dart';

import '../../application/contributor_application_provider.dart';

class ContributorApplicationUnderReviewScreen extends ConsumerWidget {
  const ContributorApplicationUnderReviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appData = ref.watch(myContributorApplicationProvider).value;
    String submittedDate = "Apr 12, 2026";
    final rawCreatedAt = appData?['created_at'] as String?;
    if (rawCreatedAt != null) {
      try {
        final parsed = DateTime.parse(rawCreatedAt);
        submittedDate = DateFormat('MMM d, yyyy').format(parsed);
      } catch (_) {}
    }

    return GradientBackground(
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.h20),
          child: Column(
            children: [
              SizedBox(height: AppSpacing.v10),

              /// Top App Bar / Header
              Row(
                children: [
                  const FkBackButton(
                    fallbackPath: RouteNames.profile,
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        "contributor.myContributions".tr(),
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

              Expanded(
                child: RefreshIndicator(
                  color: AppColors.primary500,
                  onRefresh: () async {
                    ref.invalidate(myContributorApplicationProvider);
                    ref.invalidate(myContributorMembershipProvider);
                    await Future.wait([
                      ref.read(myContributorApplicationProvider.future),
                      ref.read(myContributorMembershipProvider.future),
                    ]);
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        SizedBox(height: AppSpacing.v20),

                        Image.asset(
                          AssetsPath.contributorReviewClock,
                          width: 120.w,
                        ),

                        SizedBox(height: AppSpacing.v20),

                        Text(
                          "contributor.applicationUnderReview".tr(),
                          textAlign: TextAlign.center,
                          style: AppTextStyles.titleLarge.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.neutral950,
                          ),
                        ),

                        SizedBox(height: AppSpacing.v10),

                        Text(
                          "contributor.thanksForApplying".tr(),
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.neutral500,
                            height: 1.4,
                          ),
                        ),

                        SizedBox(height: AppSpacing.v20),

                        FkPrimaryButton(
                          label: "contributor.viewApplicationDetails".tr(),
                          icon: null,
                          onPressed: () =>
                              context.push(RouteNames.applicationSummary),
                        ),

                        SizedBox(height: 28.h),

                        /// Status Details Section (Centered stack matching Figma design)
                        _statusBlock(
                          "contributor.status".tr(),
                          "contributor.underReview".tr(),
                        ),
                        SizedBox(height: 16.h),
                        _statusBlock(
                          "contributor.submittedOn".tr(),
                          submittedDate,
                        ),
                        SizedBox(height: 16.h),
                        _statusBlock(
                          "contributor.estimatedResponse".tr(),
                          "contributor.withinFiveToSevenDays".tr(),
                        ),

                        SizedBox(height: 28.h),
                      ],
                    ),
                  ),
                ),
              ),

              /// Bottom Notification Banner
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.h16,
                  vertical: 14.h,
                ),
                decoration: BoxDecoration(
                  color: AppColors.pending50,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: AppColors.pending200.withValues(alpha: 0.6),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      size: 18,
                      color: AppColors.pending700,
                    ),
                    SizedBox(width: AppSpacing.h10),
                    Expanded(
                      child: Text(
                        "contributor.notifyOnUpdate".tr(),
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.pending700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: AppSpacing.v16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusBlock(String label, String value) {
    return Column(
      children: [
        Text(
          label.endsWith(':') ? label : '$label:',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.neutral400,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          value,
          style: AppTextStyles.titleSmall.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.neutral950,
          ),
        ),
      ],
    );
  }
}

