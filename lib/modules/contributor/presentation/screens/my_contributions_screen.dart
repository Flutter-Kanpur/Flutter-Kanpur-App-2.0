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

class MyContributionsScreen extends StatelessWidget {
  const MyContributionsScreen({super.key});

  void _showHelpBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
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

          const SizedBox(height: 24),

          Align(
            alignment: Alignment.topLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.contributorGreenContainerBg,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                "contributor.activeContributor".tr(),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.contributorTextGreen,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          Text(
            "contributor.greeting".tr(namedArgs: {"name": "Angelica Singh"}),
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            "contributor.contributorRole".tr(namedArgs: {"role": "Design"}),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textGrey,
            ),
          ),

          const SizedBox(height: 2),

          Text(
            "contributor.contributorSince".tr(namedArgs: {"date": "Mar 2026"}),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textGrey,
            ),
          ),

          const SizedBox(height: 28),

          Text(
            "contributor.heresWhatYouCanDo".tr(),
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 16),

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

              const SizedBox(width: 12),

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

          const SizedBox(height: 28),

          Text(
            "contributor.yourContributionSummary".tr(),
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 14),

          const ContributorSummaryCard(
            tasksCompleted: "06",
            eventsContributed: "40%",
            activeTasks: "24",
          ),

          const SizedBox(height: 20),

          GestureDetector(
            onTap: () => _showHelpBottomSheet(context),
            child: Text(
              "contributor.needHelp".tr(),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.blue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
