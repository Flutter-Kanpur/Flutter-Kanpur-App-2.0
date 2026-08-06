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
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';

class ContributorApplicationUnderReviewScreen extends StatelessWidget {
  const ContributorApplicationUnderReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GradientBackground(
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.h20,
            AppSpacing.h18,
            AppSpacing.h20,
            24,
          ),
          child: Column(
            children: [
              FkHeader(
                title: "contributor.myContributions".tr(),
                subtitle: "",
                leading: const FkBackButton(
                  fallbackPath: RouteNames.applicationAlreadySubmitted,
                ),
              ),

              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(AssetsPath.contributorReviewClock, width: 120),

                    SizedBox(height: AppSpacing.v22),

                    Text(
                      "contributor.applicationUnderReview".tr(),
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    SizedBox(height: AppSpacing.v12),

                    Text(
                      "contributor.thanksForApplying".tr(),
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium,
                    ),

                    SizedBox(height: AppSpacing.v22),

                    FkPrimaryButton(
                      label: "contributor.viewApplicationDetails".tr(),
                      onPressed: () =>
                          context.push(RouteNames.reviewApplication),
                    ),

                    SizedBox(height: AppSpacing.v22),

                    _item(
                      "contributor.status".tr(),
                      "contributor.underReview".tr(),
                    ),
                    SizedBox(height: AppSpacing.v18),
                    _item("contributor.submittedOn".tr(), "Apr 12, 2026"),
                    SizedBox(height: AppSpacing.v18),
                    _item(
                      "contributor.estimatedResponse".tr(),
                      "contributor.withinFiveToSevenDays".tr(),
                    ),
                  ],
                ),
              ),

              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.h16,
                  vertical: AppSpacing.v16,
                ),
                decoration: BoxDecoration(
                  color: AppColors.pending50,
                  borderRadius: AppRadius.all03,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info,
                      size: 18,
                      color: AppColors.pending400,
                    ),
                    SizedBox(width: AppSpacing.h8),
                    Expanded(
                      child: Text(
                        "contributor.notifyOnUpdate".tr(),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.pending400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _item(String title, String value) {
    return Column(
      children: [
        Text(
          title,
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.neutral400),
        ),
        SizedBox(height: AppSpacing.v4),
        Text(value, style: AppTextStyles.titleMedium),
      ],
    );
  }
}
