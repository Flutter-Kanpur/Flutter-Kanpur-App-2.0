import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/router/navigation_provider.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/core/constants/app_assets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    Future<void>.microtask(_navigateFromSplash);
  }

  Future<void> _navigateFromSplash() async {
    final routePath = await ref.read(splashRouteProvider.future);
    if (!mounted || _hasNavigated) return;

    _hasNavigated = true;
    context.go(routePath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary500,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.s10),
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
                padding: EdgeInsets.only(bottom: AppSpacing.s09),
                child: const CircularProgressIndicator(
                  color: AppColors.whiteBase,
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
