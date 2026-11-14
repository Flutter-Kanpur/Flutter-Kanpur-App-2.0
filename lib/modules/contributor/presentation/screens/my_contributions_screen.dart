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
    final assignmentsAsync = ref.watch(myContributorAssignmentsProvider);
    final assignments = assignmentsAsync.value ?? [];
    final metricsAsync = ref.watch(myContributorMetricsProvider);
    final metrics = metricsAsync.value ?? {
      'tasks_completed': '06',
      'events_contributed': '40%',
      'active_tasks': '24',
    };

    final userName = user?.displayLabel ?? "Angelica Singh";

    // Dynamic role resolution: membership role -> user skills -> application job_role -> fallback
    final userRole = (membership?['role'] as String?)?.trim().isNotEmpty == true
        ? membership!['role'] as String
        : ((user != null && user.skills.isNotEmpty)
            ? user.skills.first
            : ((appData?['job_role'] as String?)?.trim().isNotEmpty == true
                ? appData!['job_role'] as String
                : "Design"));

    // Check tier (Senior Contributor vs standard Active Contributor)
    final isSenior = (membership?['role'] as String?)?.toLowerCase().contains('senior') == true ||
        (membership?['is_senior'] == true) ||
        (membership?['tier'] as String?)?.toLowerCase() == 'senior' ||
        assignments.isNotEmpty;

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
          ref.invalidate(myContributorProjectsProvider);
          ref.invalidate(myContributorAssignmentsProvider);
          ref.invalidate(myContributorMetricsProvider);
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

            /// Status Badge (matching Image 1 Bottom Right & Column 9)
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
                  isSenior && (membership?['role'] as String?)?.toLowerCase().contains('senior') == true
                      ? "contributor.seniorContributor".tr()
                      : "contributor.activeContributor".tr(),
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

            if (isSenior) ...[
              /// 2x2 Action Cards Grid (matching Figma Column 9)
              Row(
                children: [
                  Expanded(
                    child: ContributorActionCard(
                      icon: Icons.assignment_outlined,
                      title: "contributor.viewAssignments".tr(),
                      subtitle: "contributor.viewAssignmentsDesc".tr(),
                      onTap: () => context.push(RouteNames.communityProjects),
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
            ] else ...[
              /// 1x2 Action Cards Grid (matching Figma Column 7)
              Row(
                children: [
                  Expanded(
                    child: ContributorActionCard(
                      icon: Icons.article_outlined,
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
            ],

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

            ContributorSummaryCard(
              tasksCompleted: metrics['tasks_completed'] ?? "06",
              eventsContributed: metrics['events_contributed'] ?? "40%",
              activeTasks: metrics['active_tasks'] ?? "24",
            ),

            if (isSenior && assignments.isNotEmpty) ...[
              SizedBox(height: 24.h),

              /// Current Assignments Section Header (Figma Column 9)
              Text(
                "contributor.currentAssignments".tr(),
                style: AppTextStyles.titleSmall.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.neutral950,
                ),
              ),

              SizedBox(height: AppSpacing.v12),

              for (final assignment in assignments.take(1))
                GestureDetector(
                  onTap: () => context.push(RouteNames.contributionDetails),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(AppSpacing.h16),
                    decoration: BoxDecoration(
                      color: AppColors.whiteBase,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: AppBorders.secondary),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.blackBase.withValues(alpha: 0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
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
                                assignment['title']?.toString() ?? "Mobile App UI Implementation",
                                style: AppTextStyles.titleSmall.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.neutral950,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                "${assignment['due_date'] ?? 'Due in 3 days'} • ${assignment['context'] ?? 'Flutter Kanpur App 2.0'}",
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.neutral400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right_rounded,
                          color: AppColors.neutral400,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
            ],

            SizedBox(height: 24.h),

            if (isSenior) ...[
              /// Bottom Actions Card (matching Figma Column 9)
              Container(
                decoration: BoxDecoration(
                  color: AppColors.whiteBase,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: AppBorders.secondary),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.blackBase.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                      onTap: () => context.push(RouteNames.communityGuidelines),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.h16,
                          vertical: AppSpacing.v14,
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.menu_book_outlined,
                              color: AppColors.neutral700,
                              size: 20,
                            ),
                            SizedBox(width: AppSpacing.h12),
                            Expanded(
                              child: Text(
                                "contributor.viewContributorGuidelines".tr(),
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.neutral950,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.chevron_right_rounded,
                              color: AppColors.neutral400,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: AppBorders.secondary,
                    ),
                    InkWell(
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(16.r)),
                      onTap: () => context.push(RouteNames.reportAnIssue),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.h16,
                          vertical: AppSpacing.v14,
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.edit_outlined,
                              color: AppColors.neutral700,
                              size: 20,
                            ),
                            SizedBox(width: AppSpacing.h12),
                            Expanded(
                              child: Text(
                                "contributor.reportIssue".tr(),
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.neutral950,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.chevron_right_rounded,
                              color: AppColors.neutral400,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              /// Need help? action (matching Figma Column 7)
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
            ],

            SizedBox(height: AppSpacing.v20),
          ],
        ),
      ),
    );
  }
}


