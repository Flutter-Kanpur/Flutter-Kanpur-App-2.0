import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_knp_mobile_app_v2/app/router/route_names.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_knp_mobile_app_v2/common_widgets/fk_primary_button.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_back_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../application/contributor_application_provider.dart';
import 'already_contributor_screen.dart';
import 'contributor_application_submitted_screen.dart';
import 'contributor_application_under_review_screen.dart';

class JoinAsContributorScreen extends ConsumerWidget {
  const JoinAsContributorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusAsync = ref.watch(contributorStatusProvider);

    return statusAsync.maybeWhen(
      data: (status) {
        if (status == ContributorStatus.approved) {
          return const AlreadyContributorScreen();
        }
        if (status == ContributorStatus.pending) {
          return const ContributorApplicationSubmittedScreen();
        }
        if (status == ContributorStatus.underReview) {
          return const ContributorApplicationUnderReviewScreen();
        }
        return _buildJoinContent(context);
      },
      orElse: () => _buildJoinContent(context),
    );
  }

  Widget _buildJoinContent(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteBase,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.h20),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: AppSpacing.v10),

                      /// Top App Bar / Header
                      Row(
                        children: [
                          const FkBackButton(fallbackPath: RouteNames.profile),
                          Expanded(
                            child: Center(
                              child: Text(
                                "contributor.joinAsContributor".tr(),
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

                      SizedBox(height: AppSpacing.v20),

                      /// Information Card
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 22.w,
                          vertical: 24.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary50,
                          borderRadius: BorderRadius.circular(24.r),
                        ),
                        child: Text(
                          "contributor.joinDescription".tr(),
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.neutral950,
                            height: 1.45,
                          ),
                        ),
                      ),

                      SizedBox(height: AppSpacing.v16),

                      /// Green Callout Card
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 18.w,
                          vertical: 16.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.success100,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          "contributor.noExperienceRequired".tr(),
                          textAlign: TextAlign.start,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.success800,
                            height: 1.35,
                          ),
                        ),
                      ),

                      const Spacer(),

                      SizedBox(height: AppSpacing.v20),

                      /// CTA Button
                      FkPrimaryButton(
                        label: "contributor.applyToContribute".tr(),
                        icon: Icons.arrow_forward_rounded,
                        onPressed: () =>
                            context.push(RouteNames.contributorApplication),
                      ),

                      SizedBox(height: AppSpacing.v16),

                      /// Learn More Link
                      Center(
                        child: GestureDetector(
                          onTap: () =>
                              context.push(RouteNames.communityGuidelines),
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 4.h),
                            child: Text(
                              "contributor.learnMore".tr(),
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.neutral950,
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: AppSpacing.v16),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
