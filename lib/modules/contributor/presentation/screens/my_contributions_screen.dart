import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/router/route_names.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_borders.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_knp_mobile_app_v2/modules/contributor/presentation/widgets/contributor_action_card.dart';
import 'package:flutter_knp_mobile_app_v2/modules/contributor/presentation/widgets/contributor_summary_card.dart';
import 'package:flutter_knp_mobile_app_v2/modules/profile/application/profile_provider.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_back_button.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../widgets/contributor_help_bottom_sheet.dart';
import '../../application/contributor_application_provider.dart';
import 'contributor_application_submitted_screen.dart';
import 'contributor_application_under_review_screen.dart';
import 'contributor_rejected_screen.dart';
import 'no_contributions_screen.dart';

class MyContributionsScreen extends ConsumerWidget {
  const MyContributionsScreen({super.key});

  void _showHelpBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.whiteBase,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.r06),
        ),
      ),
      builder: (_) => const ContributorHelpBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusAsync = ref.watch(contributorStatusProvider);

    return statusAsync.when(
      loading: () => const Scaffold(
        backgroundColor: AppColors.whiteBase,
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => _buildDashboard(context, ref),
      data: (status) {
        switch (status) {
          case ContributorStatus.notApplied:
            return const NoContributionsScreen(isOnboarded: false);
          case ContributorStatus.pending:
            return const ContributorApplicationSubmittedScreen();
          case ContributorStatus.underReview:
            return const ContributorApplicationUnderReviewScreen();
          case ContributorStatus.rejected:
            return const ContributorRejectedScreen();
          case ContributorStatus.approved:
            return _buildDashboard(context, ref);
        }
      },
    );
  }

  Widget _buildDashboard(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(myProfileProvider);
    final user = profileAsync.value;

    final userName = user?.displayLabel ?? "Angelica Singh";
    final userRole = (user != null && user.skills.isNotEmpty)
        ? user.skills.first
        : "Design";

    return Scaffold(
      backgroundColor: AppColors.whiteBase,
      body: FkScreen(
        children: [
          SizedBox(height: AppSpacing.v10),

          /// Top App Bar / Header
          Row(
            children: [
              const FkBackButton(fallbackPath: RouteNames.profile),
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

          SizedBox(height: AppSpacing.v20),

          /// Status Badge
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.h12,
                vertical: AppSpacing.v6,
              ),
              decoration: BoxDecoration(
                color: AppColors.success100,
                borderRadius: BorderRadius.circular(100.r),
              ),
              child: Text(
                "contributor.activeContributor".tr(),
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.success800,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          SizedBox(height: AppSpacing.v16),

          Text(
            "contributor.greeting".tr(namedArgs: {"name": userName}),
            style: AppTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.neutral950,
            ),
          ),

          SizedBox(height: AppSpacing.v6),

          Text(
            "contributor.contributorRole".tr(namedArgs: {"role": userRole}),
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.neutral400,
            ),
          ),

          SizedBox(height: 2.h),

          Text(
            "contributor.contributorSince".tr(namedArgs: {"date": "Mar 2026"}),
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.neutral400,
            ),
          ),

          SizedBox(height: 24.h),

          /// Action Cards Section Header
          Text(
            "contributor.heresWhatYouCanDo".tr(),
            style: AppTextStyles.titleSmall.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.neutral950,
            ),
          ),

          SizedBox(height: 14.h),

          /// 2x2 Action Cards Grid (matching Figma Dashboard)
          Row(
            children: [
              Expanded(
                child: ContributorActionCard(
                  icon: Icons.assignment_outlined,
                  title: "contributor.viewAssignments".tr(),
                  subtitle: "contributor.viewAssignmentsDesc".tr(),
                  onTap: () => context.go(RouteNames.communityProjects),
                ),
              ),
              SizedBox(width: AppSpacing.h12),
              Expanded(
                child: ContributorActionCard(
                  icon: Icons.cloud_upload_outlined,
                  title: "contributor.submitWork".tr(),
                  subtitle: "contributor.submitWorkDesc".tr(),
                  onTap: () => context.push(RouteNames.communityUploadProject),
                ),
              ),
            ],
          ),

          SizedBox(height: AppSpacing.v12),

          Row(
            children: [
              Expanded(
                child: ContributorActionCard(
                  icon: Icons.folder_outlined,
                  title: "contributor.viewResources".tr(),
                  subtitle: "contributor.viewResourcesDesc".tr(),
                  onTap: () => context.push(RouteNames.communityGuidelines),
                ),
              ),
              SizedBox(width: AppSpacing.h12),
              Expanded(
                child: ContributorActionCard(
                  icon: Icons.chat_bubble_outline_rounded,
                  title: "contributor.contactTeam".tr(),
                  subtitle: "contributor.contactTeamDesc".tr(),
                  onTap: () => context.push(RouteNames.contactCommunityTeam),
                ),
              ),
            ],
          ),

          SizedBox(height: 24.h),

          /// Contribution Summary Section Header
          Text(
            "contributor.yourContributionSummary".tr(),
            style: AppTextStyles.titleSmall.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.neutral950,
            ),
          ),

          SizedBox(height: 14.h),

          const ContributorSummaryCard(
            tasksCompleted: "06",
            eventsContributed: "40%",
            activeTasks: "24",
          ),

          SizedBox(height: 24.h),

          /// Current Assignments Section (Figma Column 9)
          Text(
            "contributor.currentAssignments".tr(),
            style: AppTextStyles.titleSmall.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.neutral950,
            ),
          ),

          SizedBox(height: AppSpacing.v12),

          Container(
            width: double.infinity,
            padding: EdgeInsets.all(AppSpacing.h16),
            decoration: BoxDecoration(
              color: AppColors.whiteBase,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: AppBorders.secondary),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    color: AppColors.primary50,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: const Icon(
                    Icons.task_alt_rounded,
                    color: AppColors.primary500,
                    size: 22,
                  ),
                ),
                SizedBox(width: AppSpacing.h12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Mobile App UI Implementation",
                        style: AppTextStyles.titleSmall.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.neutral950,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        "Due in 3 days • Flutter Kanpur App 2.0",
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.neutral400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 24.h),

          /// Need help? action
          Center(
            child: GestureDetector(
              onTap: () => _showHelpBottomSheet(context),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 4.h),
                child: Text(
                  "contributor.needHelp".tr(),
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primary500,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: AppSpacing.v20),
        ],
      ),
    );
  }
}
