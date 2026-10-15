import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_knp_mobile_app_v2/app/router/route_names.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_borders.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_knp_mobile_app_v2/utils/assets_path.dart';
import 'package:go_router/go_router.dart';

class ApplicationSubmittedScreen extends StatelessWidget {
  const ApplicationSubmittedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteBase,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(AssetsPath.applicationSubmitted, width: 220.w),

                SizedBox(height: 24.h),

                Text(
                  "contributor.applicationSubmitted".tr(),
                  textAlign: TextAlign.center,
                  style: AppTextStyles.headlineSmall.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.neutral950,
                  ),
                ),

                SizedBox(height: AppSpacing.v12),

                Text(
                  "contributor.applicationSubmittedDescription".tr(),
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.neutral500,
                    height: 1.5,
                  ),
                ),

                SizedBox(height: AppSpacing.v20),

                /// Status Pill Badge
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.h16,
                    vertical: AppSpacing.v6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.pending50,
                    borderRadius: BorderRadius.circular(100.r),
                    border: Border.all(
                      color: AppColors.pending200.withValues(alpha: 0.6),
                    ),
                  ),
                  child: Text(
                    "contributor.currentStatus".tr(),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.pending700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                SizedBox(height: 28.h),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => context.go(RouteNames.profile),
                    icon: const Icon(Icons.arrow_back_rounded, size: 18),
                    label: Text("contributor.backToProfile".tr()),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.neutral950,
                      minimumSize: const Size(double.infinity, 50),
                      side: const BorderSide(color: AppBorders.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100.r),
                      ),
                      textStyle: AppTextStyles.titleSmall.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
