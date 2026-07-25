import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/router/route_names.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/gradiant_background.dart';
import 'package:flutter_knp_mobile_app_v2/utils/assets_path.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_borders.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';

class ApplicationSubmittedScreen extends StatelessWidget {
  const ApplicationSubmittedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.h16),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(AssetsPath.applicationSubmitted, width: 300),

                  SizedBox(height: AppSpacing.v22),

                  Text(
                    "contributor.applicationSubmitted".tr(),
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  SizedBox(height: AppSpacing.v16),

                  Text(
                    "contributor.applicationSubmittedDescription".tr(),
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                  ),

                  SizedBox(height: AppSpacing.v22),

                  Text(
                    "contributor.currentStatus".tr(),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.neutral400,
                      fontStyle: FontStyle.italic,
                    ),
                  ),

                  SizedBox(height: AppSpacing.v22),

                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => context.go(RouteNames.profile),
                      icon: Icon(Icons.arrow_back, size: 18),
                      label: Text("contributor.backToProfile".tr()),
                      style: OutlinedButton.styleFrom(
                        minimumSize: Size(double.infinity, 52),
                        side: BorderSide(color: AppBorders.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.all07,
                        ),
                        textStyle: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
