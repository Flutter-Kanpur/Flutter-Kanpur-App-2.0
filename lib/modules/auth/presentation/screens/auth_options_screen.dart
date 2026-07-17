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

class AuthOptionsScreen extends ConsumerWidget {
  const AuthOptionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(currentUserProvider, (previous, next) {
      next.whenData((user) {
        if (context.mounted && user != null) {
          context.go(RouteNames.home);
        }
      });
    });

    return GradientBackground(
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
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
                    SvgPicture.asset(AppAssets.googleIcon, width: 20.w, height: 20.h),
                    12.horizontalSpace,
                    Text('auth.continueWithGoogle'.tr(), style: textStyle_16MediumBlack()),
                  ],
                ),
              ),

              16.verticalSpace,

              _AuthOptionButton(
                onPressed: () => context.push(RouteNames.signIn),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.mail_outline_rounded, size: 22.sp, color: Colors.black87),
                    12.horizontalSpace,
                    Text('auth.signInWithEmail'.tr(), style: textStyle_16MediumBlack()),
                  ],
                ),
              ),

              20.verticalSpace,

              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Text('onboarding.or'.tr(), style: textStyle_16MediumBlack()),
                  ),
                  Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1)),
                ],
              ),

              20.verticalSpace,

              GradientButton(
                height: 45.h,
                text: 'auth.createAccount'.tr(),
                textStyle: textStyle_16RegularBlack().copyWith(color: Colors.white),
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
              color: const Color(0xFFE8F0FE),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(Icons.person_rounded, size: 72.sp, color: const Color(0xFF4373E2)),
          ),
        ),
      ),
    );
  }

  Widget _buildHeadline() {
    return Text(
      'auth.signInTitle'.tr(),
      textAlign: TextAlign.center,
      style: textStyle_18MediumBlack().copyWith(fontSize: 24.sp),
    );
  }

  Widget _buildSubtitle() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Text(
        'auth.signInSubTitle'.tr(),
        textAlign: TextAlign.center,
        style: textStyle_16RegularBlack().copyWith(
          height: 1.5,
          color: AppColors.subtitleTextDarkGrey,
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        child: InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: onPressed,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.grey.shade300, width: 1),
            ),
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}
