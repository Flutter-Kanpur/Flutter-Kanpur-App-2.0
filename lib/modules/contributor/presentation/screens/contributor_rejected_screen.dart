import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_knp_mobile_app_v2/app/router/route_names.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_knp_mobile_app_v2/modules/contributor/application/contributor_application_provider.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_back_button.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_primary_button.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/gradient_background.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ContributorRejectedScreen extends ConsumerWidget {
  const ContributorRejectedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GradientBackground(
      child: SafeArea(
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
                        "contributor.myContributions".tr(),
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

              Expanded(
                child: RefreshIndicator(
                  color: AppColors.primary500,
                  onRefresh: () async {
                    ref.invalidate(myContributorApplicationProvider);
                    ref.invalidate(myContributorMembershipProvider);
                    await Future.wait([
                      ref.read(myContributorApplicationProvider.future),
                      ref.read(myContributorMembershipProvider.future),
                    ]);
                  },
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight,
                          ),
                          child: IntrinsicHeight(
                            child: Column(
                              children: [
                                const Spacer(),

                                Text(
                                  "contributor.applicationNotApproved".tr(),
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.titleLarge.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.neutral950,
                                  ),
                                ),

                                SizedBox(height: AppSpacing.v8),

                                Text(
                                  "contributor.applicationRejectedDescription".tr(),
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.neutral500,
                                    height: 1.4,
                                  ),
                                ),

                                SizedBox(height: 24.h),

                                FkPrimaryButton(
                                  label: "contributor.backToProfile".tr(),
                                  icon: null,
                                  onPressed: () => context.go(RouteNames.profile),
                                ),

                                const Spacer(),

                                /// Notice Banner
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: AppSpacing.h16,
                                    vertical: 14.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.pending50,
                                    borderRadius: BorderRadius.circular(12.r),
                                    border: Border.all(
                                      color: AppColors.pending200.withValues(alpha: 0.6),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.error_outline_rounded,
                                        color: AppColors.pending700,
                                        size: 18,
                                      ),
                                      SizedBox(width: AppSpacing.h10),
                                      Expanded(
                                        child: Text(
                                          "contributor.applyAgainInFuture".tr(),
                                          style: AppTextStyles.bodySmall.copyWith(
                                            color: AppColors.pending700,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(height: AppSpacing.v16),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

