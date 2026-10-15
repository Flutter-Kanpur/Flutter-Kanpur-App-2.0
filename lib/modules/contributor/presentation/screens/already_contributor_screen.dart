import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/router/route_names.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_back_button.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_primary_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class AlreadyContributorScreen extends StatelessWidget {
  const AlreadyContributorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteBase,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.h20),
          child: Column(
            children: [
              SizedBox(height: AppSpacing.v10),

              /// Top App Bar / Header
              Row(
                children: [
                  const FkBackButton(fallbackPath: RouteNames.profile),
                  Expanded(
                    child: Center(
                      child: Text(
                        "contributor.joinAsContributor".tr(),
                        style: AppTextStyles.titleLarge.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.neutral950,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48), // Balances the 48px IconButton
                ],
              ),

              const Spacer(),

              Text(
                "contributor.alreadyContributor".tr(),
                textAlign: TextAlign.center,
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.neutral950,
                ),
              ),

              SizedBox(height: AppSpacing.v8),

              Text(
                "contributor.alreadyContributorDescription".tr(),
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.neutral500,
                  height: 1.4,
                ),
              ),

              SizedBox(height: 24.h),

              FkPrimaryButton(
                label: "contributor.viewContributorResources".tr(),
                icon: Icons.arrow_forward_rounded,
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
