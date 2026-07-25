import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/router/route_names.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_back_button.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_header.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_primary_button.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/gradiant_background.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';

class ContributorRejectedScreen extends StatelessWidget {
  const ContributorRejectedScreen({super.key});

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
                leading: const FkBackButton(fallbackPath: RouteNames.profile),
              ),

              const Spacer(),

              Text(
                "contributor.applicationNotApproved".tr(),
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),

              SizedBox(height: AppSpacing.v8),

              Text(
                "contributor.applicationRejectedDescription".tr(),
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),

              SizedBox(height: AppSpacing.v22),

              FkPrimaryButton(
                label: "contributor.backToProfile".tr(),
                onPressed: () => context.go(RouteNames.profile),
              ),

              const Spacer(),

              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.h16,
                  vertical: AppSpacing.v12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.pending50,
                  borderRadius: AppRadius.all03,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info, color: AppColors.pending400, size: 18),
                    SizedBox(width: AppSpacing.h8),
                    Expanded(
                      child: Text(
                        "contributor.applyAgainInFuture".tr(),
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
}
