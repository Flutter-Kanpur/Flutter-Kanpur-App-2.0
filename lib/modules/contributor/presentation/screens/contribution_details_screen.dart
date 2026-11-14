import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/router/route_names.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_borders.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_knp_mobile_app_v2/modules/contributor/application/contributor_application_provider.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_back_button.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_primary_button.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_screen.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/gradient_background.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ContributionDetailsScreen extends ConsumerWidget {
  const ContributionDetailsScreen({
    super.key,
    this.assignmentId,
  });

  final String? assignmentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assignmentsAsync = ref.watch(myContributorAssignmentsProvider);
    final assignments = assignmentsAsync.value ?? [];

    final assignment = assignments.firstWhere(
      (a) => a['id'] == assignmentId,
      orElse: () => assignments.isNotEmpty
          ? assignments.first
          : {
              'id': 'default-1',
              'title': 'Mobile App UI Implementation',
              'context': 'Flutter Kanpur App 2.0',
              'due_date': 'Due in 3 days',
              'status': 'in_progress',
            },
    );

    final title = assignment['title'] as String? ?? 'Mobile App UI Implementation';
    final projectContext = assignment['context'] as String? ?? 'Flutter Kanpur App 2.0';
    final dueDate = assignment['due_date'] as String? ?? 'Due in 3 days';

    return GradientBackground(
      child: RefreshIndicator(
        color: AppColors.primary500,
        onRefresh: () async {
          ref.invalidate(myContributorAssignmentsProvider);
          await ref.read(myContributorAssignmentsProvider.future);
        },
        child: FkScreen(
          scrollPhysics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(height: AppSpacing.v10),

            /// Header
            Row(
              children: [
                const FkBackButton(fallbackPath: RouteNames.myContributions),
                Expanded(
                  child: Center(
                    child: Text(
                      "contributor.contributionDetails".tr(),
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

            /// Assignment Title
            Text(
              title,
              style: AppTextStyles.headlineSmall.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.neutral950,
              ),
            ),

            SizedBox(height: AppSpacing.v6),

            /// Context & Due Date
            Row(
              children: [
                const Icon(
                  Icons.schedule_rounded,
                  size: 16,
                  color: AppColors.neutral400,
                ),
                SizedBox(width: 6.w),
                Text(
                  "$dueDate • $projectContext",
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.neutral400,
                  ),
                ),
              ],
            ),

            SizedBox(height: 24.h),

            /// Details Card
            Container(
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "contributor.aboutAssignment".tr(),
                    style: AppTextStyles.titleSmall.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.neutral950,
                    ),
                  ),
                  SizedBox(height: AppSpacing.v8),
                  Text(
                    "contributor.assignmentOverview".tr(),
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.neutral600,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: AppSpacing.v16),
                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: AppBorders.secondary,
                  ),
                  SizedBox(height: AppSpacing.v16),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.r),
                        decoration: BoxDecoration(
                          color: AppColors.primary50,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: const Icon(
                          Icons.person_pin_rounded,
                          color: AppColors.primary500,
                          size: 20,
                        ),
                      ),
                      SizedBox(width: AppSpacing.h12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "contributor.assignedBy".tr(),
                              style: AppTextStyles.titleSmall.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.neutral950,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              "Flutter Kanpur Core Team",
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.neutral400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 32.h),

            /// Actions
            FkPrimaryButton(
              label: "contributor.submitWork".tr(),
              icon: null,
              onPressed: () => context.push(RouteNames.communityUploadProject),
            ),

            SizedBox(height: AppSpacing.v12),

            Center(
              child: GestureDetector(
                onTap: () => context.push(RouteNames.contactCommunityTeam),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.h),
                  child: Text(
                    "contributor.contactTeamDesc".tr(),
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

