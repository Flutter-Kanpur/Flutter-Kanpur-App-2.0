import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/router/route_names.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/modules/contributor/presentation/widgets/application_info_tile.dart';
import 'package:flutter_knp_mobile_app_v2/modules/contributor/presentation/widgets/application_links_tile.dart';
import 'package:flutter_knp_mobile_app_v2/modules/contributor/presentation/widgets/contributor_display_skill_chip.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_back_button.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_header.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_screen.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/gradiant_background.dart';
import 'package:flutter_knp_mobile_app_v2/utils/assets_path.dart';
import 'package:easy_localization/easy_localization.dart';

class ApplicationSummaryScreen extends StatelessWidget {
  const ApplicationSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GradientBackground(
      child: FkScreen(
        children: [
          FkHeader(
            title: "contributor.applicationSummary".tr(),
            subtitle: "",
            leading: const FkBackButton(
              fallbackPath: RouteNames.reviewApplication,
            ),
          ),

          const SizedBox(height: 28),

          ApplicationInfoTile(
            title: "contributor.fullName".tr(),
            value: "Angelica Singh",
          ),

          const SizedBox(height: 18),

          ApplicationInfoTile(
            title: "contributor.emailAddress".tr(),
            value: "angie.work@gmail.com",
          ),

          const SizedBox(height: 18),

          ApplicationInfoTile(
            title: "contributor.currentRole".tr(),
            value: "UI UX Designer",
          ),

          const SizedBox(height: 18),

          ApplicationInfoTile(
            title: "contributor.contributionArea".tr(),
            value: "Design System",
          ),

          const SizedBox(height: 18),

          Text(
            "contributor.relevantSkills".tr(),
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.textGrey,
            ),
          ),

          const SizedBox(height: 8),

          const Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ContributorDisplaySkillChip(label: "Figma"),
              ContributorDisplaySkillChip(label: "UI/UX Designer"),
              ContributorDisplaySkillChip(label: "Flutter"),
            ],
          ),

          const SizedBox(height: 18),

          ApplicationInfoTile(
            title: "contributor.experienceLevel".tr(),
            value: "2 years",
          ),

          const SizedBox(height: 18),

          ApplicationInfoTile(
            title: "contributor.weeklyContributionTime".tr(),
            value: "2–4 hours",
          ),

          const SizedBox(height: 18),

          Text(
            "contributor.workProfileLinks".tr(),
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.textGrey,
            ),
          ),

          const SizedBox(height: 10),

          const ApplicationLinksTile(
            icon: AssetsPath.githubSvg,
            text: "https://github.com/angelica-singh-04",
          ),

          const SizedBox(height: 10),

          const ApplicationLinksTile(
            icon: AssetsPath.websiteSvg,
            text: "https://angelica.works",
          ),

          const SizedBox(height: 10),

          const ApplicationLinksTile(
            icon: AssetsPath.linkedinSvg,
            text: "https://linkedin.com/angelica.works",
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
