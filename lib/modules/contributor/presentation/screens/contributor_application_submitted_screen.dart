import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/router/route_names.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_back_button.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_header.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_primary_button.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/gradiant_background.dart';
import 'package:flutter_knp_mobile_app_v2/utils/assets_path.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_borders.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';

class ContributorApplicationSubmittedScreen extends StatelessWidget {
  const ContributorApplicationSubmittedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GradientBackground(
      child: SafeArea(
        child: Padding(
          padding: AppSpacing.horizontal(AppSpacing.h20),
          child: Column(
            children: [
              FkHeader(
                title: "contributor.joinAsContributor".tr(),
                subtitle: "",
                leading: const FkBackButton(
                  fallbackPath: RouteNames.reviewApplication,
                ),
              ),

              SizedBox(height: AppSpacing.v22),

              Center(
                child: Image.asset(
                  AssetsPath.contributorPaperPlane,
                  width: 120,
                ),
              ),

              SizedBox(height: AppSpacing.v22),

              Text(
                "contributor.applicationAlreadySubmitted".tr(),
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),

              SizedBox(height: AppSpacing.v12),

              Text(
                "contributor.applicationReviewMessage".tr(),
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),

              SizedBox(height: AppSpacing.v22),

              FkPrimaryButton(
                label: "contributor.viewApplication".tr(),
                onPressed: () =>
                    context.push(RouteNames.applicationUnderReview),
              ),

              // Pushes the card towards the bottom
              Spacer(),

              Container(
                padding: AppSpacing.all(AppSpacing.h20),
                decoration: BoxDecoration(
                  color: AppColors.whiteBase,
                  borderRadius: AppRadius.all05,
                  border: Border.all(
                    color: AppBorders.secondary,
                  ),
                ),
                child: Column(
                  children: [
                    _row("contributor.fullName".tr(), "Angelica Singh"),
                    const Divider(),
                    _row(
                      "contributor.emailAddress".tr(),
                      "angie.work@gmail.com",
                    ),
                    const Divider(),
                    _row("contributor.currentRole".tr(), "UI/UXDesigner"),
                    const Divider(),
                    _row("contributor.experienceLevel".tr(), "2 years"),
                    const Divider(),
                    _row("contributor.time".tr(), "2-4 hours"),
                  ],
                ),
              ),

              SizedBox(height: AppSpacing.v20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(String title, String value) {
    return Padding(
      padding: AppSpacing.vertical(AppSpacing.v6),
      child: Row(
        children: [
          Expanded(
            child: Text(title, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.neutral400)),
          ),
          Text(value, style: AppTextStyles.titleSmall),
        ],
      ),
    );
  }
}
