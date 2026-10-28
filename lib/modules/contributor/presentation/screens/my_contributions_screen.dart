import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/router/route_names.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_knp_mobile_app_v2/modules/contributor/presentation/widgets/contributor_action_card.dart';
import 'package:flutter_knp_mobile_app_v2/modules/contributor/presentation/widgets/contributor_summary_card.dart';
import 'package:flutter_knp_mobile_app_v2/modules/profile/application/profile_provider.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_back_button.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_error_view.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_screen.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/gradient_background.dart';
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
      loading: () => GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: AppSpacing.v10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.h20),
                child: Row(
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
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      error: (err, stack) => GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: AppSpacing.v10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.h20),
                child: Row(
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
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: FkErrorView(
                    message: "contributor.loadError".tr(),
                    onRetry: () {
                      ref.invalidate(myContributorApplicationProvider);
                      ref.invalidate(myContributorMembershipProvider);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
    final membershipAsync = ref.watch(myContributorMembershipProvider);
    final membership = membershipAsync.value;
    final appData = ref.watch(myContributorApplicationProvider).value;

    final userName = user?.displayLabel ?? "Angelica Singh";

    // Dynamic role resolution: membership role -> user skills -> application job_role -> fallback
    final userRole = (membership?['role'] as String?)?.trim().isNotEmpty == true
        ? membership!['role'] as String
        : ((user != null && user.skills.isNotEmpty)
            ? user.skills.first
            : ((appData?['job_role'] as String?)?.trim().isNotEmpty == true
                ? appData!['job_role'] as String
                : "Design"));

    // Dynamic joined date resolution
    String contributorSinceDate = "Mar 2026";
    final rawDate = (membership?['joined_at'] as String?) ??
        (appData?['created_at'] as String?);
    if (rawDate != null) {
      try {
        final parsed = DateTime.parse(rawDate);
        contributorSinceDate = DateFormat('MMM yyyy').format(parsed);
      } catch (_) {}
    }

    return GradientBackground(
      child: RefreshIndicator(
        color: AppColors.primary500,
        onRefresh: () async {
          ref.invalidate(myContributorApplicationProvider);
          ref.invalidate(myContributorMembershipProvider);
          ref.invalidate(myProfileProvider);
          await Future.wait([
            ref.read(myContributorApplicationProvider.future),
            ref.read(myContributorMembershipProvider.future),
            ref.read(myProfileProvider.future),
          ]);
        },
        child: FkScreen(
          scrollPhysics: const AlwaysScrollableScrollPhysics(),
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

            /// Status Badge (matching Image 1 Bottom Right)
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.h12,
                  vertical: AppSpacing.v6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFD4F7DC),
                  borderRadius: BorderRadius.circular(100.r),
                ),
                child: Text(
                  "contributor.activeContributor".tr(),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: const Color(0xFF027A48),
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
              "contributor.contributorSince".tr(namedArgs: {"date": contributorSinceDate}),
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
                    icon: Icons.code_rounded,
                    title: "contributor.viewBlogs".tr(),
                    subtitle: "contributor.viewBlogsDescription".tr(),
                    onTap: () => context.push(RouteNames.blogs),
                  ),
                ),
                SizedBox(width: AppSpacing.h12),
                Expanded(
                  child: ContributorActionCard(
                    icon: Icons.code_rounded,
                    title: "contributor.viewProjects".tr(),
                    subtitle: "contributor.viewProjectsDescription".tr(),
                    onTap: () => context.push(RouteNames.communityProjects),
                  ),
                ),
              ],
            ),

            SizedBox(height: AppSpacing.v12),

            Row(
              children: [
                Expanded(
                  child: ContributorActionCard(
                    icon: Icons.code_rounded,
                    title: "contributor.contactTeam".tr(),
                    subtitle: "contributor.contactTeamDesc".tr(),
                    onTap: () => context.push(RouteNames.contactCommunityTeam),
                  ),
                ),
                SizedBox(width: AppSpacing.h12),
                Expanded(
                  child: ContributorActionCard(
                    icon: Icons.code_rounded,
                    title: "contributor.viewResources".tr(),
                    subtitle: "contributor.viewResourcesDesc".tr(),
                    onTap: () => context.push(RouteNames.communityGuidelines),
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
      ),
    );
  }
}


