import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/router/route_names.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/core/constants/app_assets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 5));
    if (!mounted) return;

    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      context.go(RouteNames.home);
    } else {
      context.go(RouteNames.authOptions);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w),

          child: Column(
            children: [
              const Spacer(),

              /// Dash Icon
              Center(
                child: Image.asset(
                  AppAssets.dashIcon,
                  width: 120.w,
                  height: 120.h,
                  fit: BoxFit.contain,
                ),
              ),

              const Spacer(),

              /// Loading Text
              Padding(
                padding: EdgeInsets.only(bottom: 40.h),

                child: Text(
                  'Loading...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
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
