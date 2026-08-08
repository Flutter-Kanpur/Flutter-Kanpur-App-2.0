import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kanpur_ui_kit/flutter_kanpur_ui_kit.dart';
import 'package:flutter_knp_mobile_app_v2/app/router/route_names.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_knp_mobile_app_v2/core/constants/app_assets.dart';
import 'package:flutter_knp_mobile_app_v2/modules/auth/application/auth_state_manager.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/gradient_background.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_borders.dart';
import 'package:flutter_knp_mobile_app_v2/modules/auth/data/services/user_service.dart';

class AuthOptionsScreen extends ConsumerWidget {
  const AuthOptionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(currentUserProvider, (previous, next) {
      next.whenData((user) async {
        if (!context.mounted || user == null) return;
        final done = await UserService().isOnboardingCompleted();
        if (!context.mounted) return;
        context.go(done ? RouteNames.home : RouteNames.onboardingNavigation);
      });
    });

    return GradientBackground(
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.h16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              40.verticalSpace,
              _buildMascot(),
              32.verticalSpace,
              _buildHeadline(),
              8.verticalSpace,
              _buildSubtitle(),
              40.verticalSpace,

              _AuthOptionButton(
                onPressed: () {
                  // TODO: Implement Google Sign In
                  context.push(RouteNames.signIn);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      AppAssets.googleIcon,
                      width: 20.w,
                      height: 20.h,
                    ),
                    12.horizontalSpace,
                    Text(
                      'auth.continueWithGoogle'.tr(),
                      style: AppTextStyles.titleMedium
                    ),
                  ],
                ),
              ),

              10.verticalSpace,

              _AuthOptionButton(
                onPressed: () => context.push(RouteNames.signIn),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.mail_outline_rounded,
                      size: 22.sp,
                      color: AppColors.blackBase,
                    ),
                    12.horizontalSpace,
                    Text(
                      'auth.signInWithEmail'.tr(),
                      style: AppTextStyles.titleMedium
                    ),
                  ],
                ),
              ),

              20.verticalSpace,

              Row(
                children: [
                  Expanded(
                    child: Divider(color: AppColors.borderSecondary, thickness: 1),
                  ),
                  Padding(
                    padding: AppSpacing.horizontal(AppSpacing.h12),
                    child: Text(
                      'onboarding.or'.tr(),
                      style: AppTextStyles.titleSmall.copyWith(
                        color: AppColors.blackBase,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(color: AppBorders.primary, thickness: 1),
                  ),
                ],
              ),

              20.verticalSpace,

              GradientButton(
                height: 45.h,
                text: 'auth.createAccount'.tr(),
                textStyle: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.whiteBase,
                ),
                onTap: () => context.push(RouteNames.signUp),
              ),

              32.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMascot() {
    return Center(
      child: SizedBox(
        width: 130.w,
        height: 130.w,
        child: Image.asset(
          AppAssets.dashIcon,
          fit: BoxFit.contain,
          errorBuilder: (_, _, _) => Container(
            decoration: BoxDecoration(
              color: AppColors.primary100,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.blackBase.withValues(alpha: 0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Icons.person_rounded,
              size: 72.sp,
              color: AppColors.primary500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeadline() {
    return Text(
      'auth.signInTitle'.tr(),
      textAlign: TextAlign.center,
      style: AppTextStyles.titleLarge.copyWith(
        color: AppColors.blackBase,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildSubtitle() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.h16),
      child: Text(
        'auth.signInSubTitle'.tr(),
        textAlign: TextAlign.center,
        style: AppTextStyles.titleMedium.copyWith(
          color: AppColors.neutral500,
        ),
      ),
    );
  }
}

class _AuthOptionButton extends StatelessWidget {
  const _AuthOptionButton({required this.onPressed, required this.child});

  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52.h,
      child: Material(
        color: AppColors.whiteBase,
        borderRadius: AppRadius.all03,
        child: InkWell(
          borderRadius: AppRadius.all03,
          onTap: onPressed,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: AppRadius.all03,
              border: Border.all(
                color: AppColors.borderSecondary,
                width: AppSpacing.h1,
              ),
            ),
            padding: AppSpacing.horizontal(AppSpacing.h16),
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}
