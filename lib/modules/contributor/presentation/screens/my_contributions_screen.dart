import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/router/route_names.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/modules/contributor/presentation/widgets/contributor_action_card.dart';
import 'package:flutter_knp_mobile_app_v2/modules/contributor/presentation/widgets/contributor_summary_card.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_back_button.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_header.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_screen.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/gradient_background.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../widgets/contributor_help_bottom_sheet.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';

class MyContributionsScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GradientBackground(
      child: FkScreen(
        children: [
          FkHeader(
            title: "contributor.myContributions".tr(),
            subtitle: "",
            leading: const FkBackButton(fallbackPath: RouteNames.profile),
          ),

          SizedBox(height: AppSpacing.v22),

          Align(
            alignment: Alignment.topLeft,
            child: Container(
              padding: AppSpacing.symmetric(
                horizontal: AppSpacing.h12,
                vertical: AppSpacing.v6,
              ),
              decoration: BoxDecoration(
                color: AppColors.success100,
                borderRadius: AppRadius.all07,
              ),
              child: Text(
                "contributor.activeContributor".tr(),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.success800,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          SizedBox(height: AppSpacing.v16),

          Text(
            "contributor.greeting".tr(namedArgs: {"name": "Angelica Singh"}),
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),

          SizedBox(height: AppSpacing.v8),

          Text(
            "contributor.contributorRole".tr(namedArgs: {"role": "Design"}),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.neutral400,
            ),
          ),

          SizedBox(height: AppSpacing.v2),

          Text(
            "contributor.contributorSince".tr(namedArgs: {"date": "Mar 2026"}),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.neutral400,
            ),
          ),

          SizedBox(height: AppSpacing.v22),

          Text(
            "contributor.heresWhatYouCanDo".tr(),
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: AppSpacing.v16),

          Row(
            children: [
              Expanded(
                child: ContributorActionCard(
                  icon: Icons.code,
                  title: "contributor.viewBlogs".tr(),
                  subtitle: "contributor.viewBlogsDescription".tr(),
                  onTap: () => context.go(RouteNames.blogs),
                ),
              ),

              SizedBox(width: AppSpacing.h12),

              Expanded(
                child: ContributorActionCard(
                  icon: Icons.code,
                  title: "contributor.viewProjects".tr(),
                  subtitle: "contributor.viewProjectsDescription".tr(),
                  onTap: () => context.go(RouteNames.communityProjects),
                ),
              ),
            ],
          ),

          SizedBox(height: AppSpacing.v22),

          Text(
            "contributor.yourContributionSummary".tr(),
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: AppSpacing.v16),

          const ContributorSummaryCard(
            tasksCompleted: "06",
            eventsContributed: "40%",
            activeTasks: "24",
          ),

          SizedBox(height: AppSpacing.v20),

          GestureDetector(
            onTap: () => _showHelpBottomSheet(context),
            child: Text(
              "contributor.needHelp".tr(),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.primary400,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
