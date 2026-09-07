import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/router/route_names.dart';
import 'package:flutter_knp_mobile_app_v2/common_widgets/fk_primary_button.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_back_button.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_header.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_screen.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';

class JoinAsContributorScreen extends StatelessWidget {
  const JoinAsContributorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.primary100,
      body: FkScreen(
        children: [
          FkHeader(
            title: "contributor.joinAsContributor".tr(),
            subtitle: "",
            leading: const FkBackButton(fallbackPath: RouteNames.profile),
          ),

          SizedBox(height: AppSpacing.v16),

          /// Information Card
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.h10,
              vertical: AppSpacing.v16,
            ),
            decoration: BoxDecoration(
              color: AppColors.primary50,
              borderRadius: AppRadius.all05,
            ),
            child: Text(
              "contributor.joinDescription".tr(),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge,
            ),
          ),

          SizedBox(height: AppSpacing.v16),

          /// Green Card
          Container(
            width: double.infinity,
            padding: AppSpacing.symmetric(
              horizontal: AppSpacing.h18,
              vertical: AppSpacing.v18,
            ),
            decoration: BoxDecoration(
              color: AppColors.success100,
              borderRadius: AppRadius.all04,
            ),
            child: Text(
              "contributor.noExperienceRequired".tr(),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.success800,
              ),
            ),
          ),

          SizedBox(height: MediaQuery.of(context).size.height * 0.33),

          FkPrimaryButton(
            label: "contributor.applyToContribute".tr(),
            icon: Icons.arrow_forward,
            onPressed: () => context.push(RouteNames.contributorApplication),
          ),

          SizedBox(height: AppSpacing.v12),

          Center(
            child: TextButton(
              onPressed: () => context.go(RouteNames.communityGuidelines),
              child: Text(
                "contributor.learnMore".tr(),
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ),

          SizedBox(height: AppSpacing.v12),
        ],
      ),
    );
  }
}
