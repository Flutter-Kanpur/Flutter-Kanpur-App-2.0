import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/router/route_names.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_back_button.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_header.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_primary_button.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/gradiant_background.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';

class NoContributionsScreen extends StatelessWidget {
  const NoContributionsScreen({super.key});

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

              const SizedBox(height: 8),

              Text(
                "contributor.noContributionsDescription".tr(),
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),

              const SizedBox(height: 24),

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
