import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/router/route_names.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/core/constants/app_assets.dart';
import 'package:flutter_knp_mobile_app_v2/modules/auth/application/auth_provider.dart';
import 'package:flutter_knp_mobile_app_v2/modules/auth/application/auth_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await Future.delayed(const Duration(milliseconds: 2500));
    if (!mounted) return;
    await ref.read(authNotifierProvider.notifier).initialize();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AppAuthState>(authNotifierProvider, (_, next) {
      if (!mounted) return;
      switch (next.status) {
        case AuthStatus.authenticated:
          context.go(RouteNames.home);
        case AuthStatus.unauthenticated:
        case AuthStatus.error:
          context.go(RouteNames.authOptions);
        case AuthStatus.verificationSent:
          context.go(RouteNames.emailVerification);
        case AuthStatus.initial:
        case AuthStatus.loading:
          break;
      }
    });

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w),
          child: Column(
            children: [
              const Spacer(),
              Center(
                child: Image.asset(
                  AppAssets.dashIcon,
                  width: 120.w,
                  height: 120.h,
                  fit: BoxFit.contain,
                ),
              ),
              const Spacer(),
              Padding(
                padding: EdgeInsets.only(bottom: 40.h),
                child: const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
