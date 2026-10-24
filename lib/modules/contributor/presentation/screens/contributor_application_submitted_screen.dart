import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_knp_mobile_app_v2/app/router/route_names.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_borders.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_knp_mobile_app_v2/modules/contributor/application/contributor_application_provider.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_back_button.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_primary_button.dart';
import 'package:flutter_knp_mobile_app_v2/utils/assets_path.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ContributorApplicationSubmittedScreen extends ConsumerWidget {
  const ContributorApplicationSubmittedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(contributorApplicationDraftProvider);
    final appData = ref.watch(myContributorApplicationProvider).value;

    final fullName = (appData?['full_name'] as String?)?.trim().isNotEmpty == true
        ? appData!['full_name'] as String
        : (draft != null && draft.fullName.isNotEmpty
            ? draft.fullName
            : "Angelica Singh");

    final email = (appData?['email'] as String?)?.trim().isNotEmpty == true
        ? appData!['email'] as String
        : (draft != null && draft.email.isNotEmpty
            ? draft.email
            : "angie.work@gmail.com");

    final role = (appData?['job_role'] as String?)?.trim().isNotEmpty == true
        ? appData!['job_role'] as String
        : (draft != null && draft.currentRole.isNotEmpty
            ? draft.currentRole
            : "UI/UX Designer");

    final experience = (appData?['experience_level'] as String?)?.trim().isNotEmpty == true
        ? appData!['experience_level'] as String
        : (draft != null && draft.experienceLevel.isNotEmpty
            ? draft.experienceLevel
            : "2 years");

    final time = (appData?['time_per_week'] as String?)?.trim().isNotEmpty == true
        ? appData!['time_per_week'] as String
        : (draft != null && draft.weeklyHours.isNotEmpty
            ? draft.weeklyHours
            : "2-4 hours");

    return Scaffold(
      backgroundColor: AppColors.whiteBase,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.h20),
          child: Column(
            children: [
              SizedBox(height: AppSpacing.v10),

              /// Top App Bar / Header
              Row(
                children: [
                  const FkBackButton(
                    fallbackPath: RouteNames.joinContributor,
                  ),
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

              Center(
                child: Image.asset(
                  AssetsPath.contributorPaperPlane,
                  width: 120.w,
                ),
              ),

              SizedBox(height: AppSpacing.v20),

              Text(
                "contributor.applicationAlreadySubmitted".tr(),
                textAlign: TextAlign.center,
                style: AppTextStyles.titleLarge.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.neutral950,
                ),
              ),

              SizedBox(height: AppSpacing.v10),

              Text(
                "contributor.applicationReviewMessage".tr(),
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.neutral500,
                  height: 1.4,
                ),
              ),

              SizedBox(height: AppSpacing.v20),

              FkPrimaryButton(
                label: "contributor.viewApplication".tr(),
                icon: Icons.arrow_forward_rounded,
                onPressed: () =>
                    context.push(RouteNames.applicationUnderReview),
              ),

              const Spacer(),

              /// Applicant Details Card
              Container(
                padding: EdgeInsets.all(AppSpacing.h18),
                decoration: BoxDecoration(
                  color: AppColors.whiteBase,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: AppBorders.secondary),
                ),
                child: Column(
                  children: [
                    _row("contributor.fullName".tr(), fullName),
                    const Divider(color: AppBorders.secondary, height: 16),
                    _row("contributor.emailAddress".tr(), email),
                    const Divider(color: AppBorders.secondary, height: 16),
                    _row("contributor.currentRole".tr(), role),
                    const Divider(color: AppBorders.secondary, height: 16),
                    _row("contributor.experienceLevel".tr(), experience),
                    const Divider(color: AppBorders.secondary, height: 16),
                    _row("contributor.time".tr(), time),
                  ],
                ),
              ),

              SizedBox(height: AppSpacing.v20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.v4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.neutral400,
              ),
            ),
          ),
          Text(
            value,
            style: AppTextStyles.titleSmall.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.neutral950,
            ),
          ),
        ],
      ),
    );
  }
}
