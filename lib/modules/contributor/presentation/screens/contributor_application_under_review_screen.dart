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

class ContributorApplicationUnderReviewScreen extends StatelessWidget {
  const ContributorApplicationUnderReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GradientBackground(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
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

                    const SizedBox(height: 24),

                    Text(
                      "contributor.applicationUnderReview".tr(),
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      "contributor.thanksForApplying".tr(),
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium,
                    ),

                    const SizedBox(height: 24),

                    FkPrimaryButton(
                      label: "contributor.viewApplicationDetails".tr(),
                      onPressed: () =>
                          context.push(RouteNames.reviewApplication),
                    ),

                    const SizedBox(height: 40),

                    _item(
                      "contributor.status".tr(),
                      "contributor.underReview".tr(),
                    ),
                    const SizedBox(height: 18),
                    _item("contributor.submittedOn".tr(), "Apr 12, 2026"),
                    const SizedBox(height: 18),
                    _item(
                      "contributor.estimatedResponse".tr(),
                      "contributor.withinFiveToSevenDays".tr(),
                    ),
                  ],
                ),
              ),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: AppColors.yellowWarningBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info, size: 18, color: AppColors.orange),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "contributor.notifyOnUpdate".tr(),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.orange,
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
        Text(title, style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ],
    );
  }
}
