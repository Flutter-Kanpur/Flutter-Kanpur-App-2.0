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
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';

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

          SizedBox(height: AppSpacing.s10),

          ApplicationInfoTile(
            title: "contributor.fullName".tr(),
            value: "Angelica Singh",
          ),

          SizedBox(height: AppSpacing.s08),

          ApplicationInfoTile(
            title: "contributor.emailAddress".tr(),
            value: "angie.work@gmail.com",
          ),

          SizedBox(height: AppSpacing.s08),

          ApplicationInfoTile(
            title: "contributor.currentRole".tr(),
            value: "UI UX Designer",
          ),

          SizedBox(height: AppSpacing.s08),

          ApplicationInfoTile(
            title: "contributor.contributionArea".tr(),
            value: "Design System",
          ),

          SizedBox(height: AppSpacing.s08),

          Text(
            "contributor.relevantSkills".tr(),
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.neutral400,
            ),
          ),

          SizedBox(height: AppSpacing.s04),

          Wrap(
            spacing: AppSpacing.s04,
            runSpacing: AppSpacing.s04,
            children: [
              ContributorDisplaySkillChip(label: "Figma"),
              ContributorDisplaySkillChip(label: "UI/UX Designer"),
              ContributorDisplaySkillChip(label: "Flutter"),
            ],
          ),

          SizedBox(height: AppSpacing.s08),

          ApplicationInfoTile(
            title: "contributor.experienceLevel".tr(),
            value: "2 years",
          ),

          SizedBox(height: AppSpacing.s08),

          ApplicationInfoTile(
            title: "contributor.weeklyContributionTime".tr(),
            value: "2–4 hours",
          ),

          SizedBox(height: AppSpacing.s08),

          Text(
            "contributor.workProfileLinks".tr(),
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.neutral400,
            ),
          ),

          SizedBox(height: AppSpacing.s05),

          const ApplicationLinksTile(
            icon: AssetsPath.githubSvg,
            text: "https://github.com/angelica-singh-04",
          ),

          SizedBox(height: AppSpacing.s05),

          const ApplicationLinksTile(
            icon: AssetsPath.websiteSvg,
            text: "https://angelica.works",
          ),

          SizedBox(height: AppSpacing.s05),

          const ApplicationLinksTile(
            icon: AssetsPath.linkedinSvg,
            text: "https://linkedin.com/angelica.works",
          ),

          SizedBox(height: AppSpacing.s10),
        ],
      ),
    );
  }
}
