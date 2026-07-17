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

class ContributorApplicationSubmittedScreen extends StatelessWidget {
  const ContributorApplicationSubmittedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GradientBackground(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              FkHeader(
                title: "contributor.joinAsContributor".tr(),
                subtitle: "",
                leading: const FkBackButton(
                  fallbackPath: RouteNames.reviewApplication,
                ),
              ),

              const SizedBox(height: 32),

              Center(
                child: Image.asset(
                  AssetsPath.contributorPaperPlane,
                  width: 120,
                ),
              ),

              const SizedBox(height: 28),

              Text(
                "contributor.applicationAlreadySubmitted".tr(),
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                "contributor.applicationReviewMessage".tr(),
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),

              const SizedBox(height: 24),

              FkPrimaryButton(
                label: "contributor.viewApplication".tr(),
                onPressed: () =>
                    context.push(RouteNames.applicationUnderReview),
              ),

              // Pushes the card towards the bottom
              const Spacer(),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.contributorApplicationCardBorder,
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

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(title, style: const TextStyle(color: Colors.grey)),
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
