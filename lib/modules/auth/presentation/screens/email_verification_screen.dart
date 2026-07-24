import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/router/route_names.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_kanpur_ui_kit/flutter_kanpur_ui_kit.dart';
import 'package:flutter_knp_mobile_app_v2/core/constants/app_assets.dart';
import 'package:flutter_knp_mobile_app_v2/modules/auth/application/auth_state_manager.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/gradient_background.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';

class EmailVerificationScreen extends ConsumerWidget {
  const EmailVerificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    final email = '';

    currentUser.whenData((user) {
      if (!context.mounted) return;
      if (user != null) {
        context.pushReplacement(RouteNames.home);
      }
    });

    return GradientBackground(
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.s07),
          child: Column(
            children: [
              const Spacer(),

              Center(
                child: Image.asset(
                  AppAssets.dashIcon,
                  width: 120.w,
                  height: 120.w,
                  fit: BoxFit.contain,
                ),
              ),

              32.verticalSpace,

              Text(
                'auth.emailVerifiedTitle'.tr(),
                style: AppTextStyles.titleLarge.copyWith(color: AppColors.blackBase, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),

              12.verticalSpace,

              Text(
                'auth.emailVerifiedSubTitle'.tr(),
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.neutral500,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),

              if (email.isNotEmpty) ...[
                8.verticalSpace,
                Text(
                  email,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],

              const Spacer(),

              GradientButton(
                height: 50.h,
                text: "I've verified my email",
                textStyle: AppTextStyles.bodyLarge.copyWith(color: AppColors.whiteBase),
                onTap: () => context.go(RouteNames.home),
              ),

              16.verticalSpace,

              TextButton(
                onPressed: () => context.go(RouteNames.signIn),
                child: Text(
                  'auth.login'.tr(),
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primary500,
                  ),
                ),
              ),

              32.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}
