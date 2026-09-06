import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/modules/contributor/domain/contributor_application_draft.dart';
import 'package:flutter_knp_mobile_app_v2/utils/assets_path.dart';

import 'application_info_tile.dart';
import 'application_links_tile.dart';
import 'contributor_display_skill_chip.dart';

class ContributorApplicationReviewBody extends StatelessWidget {
  const ContributorApplicationReviewBody({super.key, required this.draft});

  final ContributorApplicationDraft draft;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ApplicationInfoTile(
          title: 'contributor.fullName'.tr(),
          value: draft.fullName,
        ),
        SizedBox(height: AppSpacing.v18),
        ApplicationInfoTile(
          title: 'contributor.emailAddress'.tr(),
          value: draft.email,
        ),
        SizedBox(height: AppSpacing.v18),
        ApplicationInfoTile(
          title: 'contributor.currentRole'.tr(),
          value: draft.currentRole,
        ),
        SizedBox(height: AppSpacing.v18),
        ApplicationInfoTile(
          title: 'contributor.contributionArea'.tr(),
          value: draft.contributionArea,
        ),
        SizedBox(height: AppSpacing.v18),
        Text(
          'contributor.relevantSkills'.tr(),
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.neutral400,
          ),
        ),
        SizedBox(height: AppSpacing.v8),
        Wrap(
          spacing: AppSpacing.h8,
          runSpacing: AppSpacing.v8,
          children: [
            for (final skill in draft.skills)
              ContributorDisplaySkillChip(label: skill),
          ],
        ),
        SizedBox(height: AppSpacing.v18),
        ApplicationInfoTile(
          title: 'contributor.experienceLevel'.tr(),
          value: draft.experienceLevel,
        ),
        SizedBox(height: AppSpacing.v18),
        ApplicationInfoTile(
          title: 'contributor.weeklyContributionTime'.tr(),
          value: draft.weeklyHours,
        ),
        SizedBox(height: AppSpacing.v18),
        Text(
          'contributor.workProfileLinks'.tr(),
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.neutral400,
          ),
        ),
        SizedBox(height: AppSpacing.v10),
        ..._linkTiles(),
      ],
    );
  }

  List<Widget> _linkTiles() {
    final entries = <(String icon, String url)>[
      if (_isPresent(draft.githubUrl))
        (AssetsPath.githubSvg, draft.githubUrl!),
      if (_isPresent(draft.websiteUrl))
        (AssetsPath.websiteSvg, draft.websiteUrl!),
      if (_isPresent(draft.linkedinUrl))
        (AssetsPath.linkedinSvg, draft.linkedinUrl!),
    ];

    if (entries.isEmpty) {
      return [
        Text(
          '—',
          style: TextStyle(color: AppColors.neutral500),
        ),
      ];
    }

    return [
      for (var i = 0; i < entries.length; i++) ...[
        if (i > 0) SizedBox(height: AppSpacing.v10),
        ApplicationLinksTile(icon: entries[i].$1, text: entries[i].$2),
      ],
    ];
  }

  bool _isPresent(String? value) => value != null && value.trim().isNotEmpty;
}
