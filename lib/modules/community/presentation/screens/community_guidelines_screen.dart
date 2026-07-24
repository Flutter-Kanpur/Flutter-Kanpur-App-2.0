import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/common_widgets/fk_back_button.dart';
import 'package:flutter_knp_mobile_app_v2/common_widgets/fk_header.dart';
import 'package:flutter_knp_mobile_app_v2/common_widgets/fk_screen.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/gradient_background.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';

class CommunityGuidelinesScreen extends StatelessWidget {
  const CommunityGuidelinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GradientBackground(
      child: FkScreen(
        children: [
          FkHeader(
            title: "community.communityGuidelines.title".tr(),
            subtitle: '',
            leading: FkBackButton(),
          ),
          SizedBox(height: AppSpacing.s08),
          Text(
            "community.communityGuidelines.about".tr(),
            style: theme.textTheme.bodyLarge,
          ),
          SizedBox(height: AppSpacing.s10),
          SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ContainerBackground(
                  title: "community.communityGuidelines.respectAndConduct.title"
                      .tr(),
                  description:
                      "community.communityGuidelines.respectAndConduct.description"
                          .tr(),
                ),
                SizedBox(height: AppSpacing.s08),
                _ContainerBackground(
                  title: "community.communityGuidelines.inclusivity.title".tr(),
                  description:
                      "community.communityGuidelines.inclusivity.description"
                          .tr(),
                ),
                SizedBox(height: AppSpacing.s08),
                _ContainerBackground(
                  title:
                      "community.communityGuidelines.meaningfulParticipation.title"
                          .tr(),
                  description:
                      "community.communityGuidelines.meaningfulParticipation.description"
                          .tr(),
                ),
                SizedBox(height: AppSpacing.s08),
                _ContainerBackground(
                  title:
                      "community.communityGuidelines.responsibleSharing.title"
                          .tr(),
                  description:
                      "community.communityGuidelines.responsibleSharing.description"
                          .tr(),
                ),
                SizedBox(height: AppSpacing.s08),
                _ContainerBackground(
                  title: "community.communityGuidelines.privacyAndTrust.title"
                      .tr(),
                  description:
                      "community.communityGuidelines.privacyAndTrust.description"
                          .tr(),
                ),
                SizedBox(height: AppSpacing.s08),
                Text(
                  "common.lastUpdated".tr(
                    args: ["common.lastUpdatedDate".tr()],
                  ),
                  style: theme.textTheme.titleLarge,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ContainerBackground extends StatelessWidget {
  final String title;
  final String description;
  const _ContainerBackground({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: AppSpacing.all08,
      decoration: BoxDecoration(
        color: AppColors.primary50,
        borderRadius: AppRadius.all02,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleLarge),
          SizedBox(height: AppSpacing.s05),
          Text(description, style: theme.textTheme.bodyLarge),
        ],
      ),
    );
  }
}
