import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/router/route_names.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_back_button.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_header.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_primary_button.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/gradiant_background.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';

class NoContributionsScreen extends StatelessWidget {
  const NoContributionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GradientBackground(
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(AppSpacing.h20, AppSpacing.h18, AppSpacing.h20, 24),
          child: Column(
            children: [
              FkHeader(
                title: "contributor.myContributions".tr(),
                subtitle: "",
                leading: const FkBackButton(
                  fallbackPath: RouteNames.profile,
                ),
              ),

              const Spacer(),

              Text(
                "contributor.noContributionsYet".tr(),
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),

              SizedBox(height: AppSpacing.v8),

              Text(
                "contributor.noContributionsDescription".tr(),
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),

              SizedBox(height: AppSpacing.v22),

              FkPrimaryButton(
                label: "contributor.joinAsContributor".tr(),
                onPressed: () => context.push(RouteNames.joinContributor),
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
