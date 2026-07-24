import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/router/route_names.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_back_button.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_header.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_primary_button.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/gradiant_background.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';

class AlreadyContributorScreen extends StatelessWidget {
  const AlreadyContributorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GradientBackground(
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(AppSpacing.s09, AppSpacing.s08, AppSpacing.s09, 24),
          child: Column(
            children: [
              FkHeader(
                title: "contributor.joinAsContributor".tr(),
                subtitle: "",
                leading: const FkBackButton(
                  fallbackPath: RouteNames.profile,
                ),
              ),

              const Spacer(),

              Text(
                "contributor.alreadyContributor".tr(),
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),

              SizedBox(height: AppSpacing.s04),

              Text(
                "contributor.alreadyContributorDescription".tr(),
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),

              SizedBox(height: AppSpacing.s10),

              FkPrimaryButton(
                label: "contributor.viewContributorResources".tr(),
                onPressed: () => context.push(RouteNames.myContributions),
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
