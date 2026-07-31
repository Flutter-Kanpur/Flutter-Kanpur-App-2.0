import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';

class GradientBackground extends StatelessWidget {
  const GradientBackground({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primary500.withValues(alpha: 0.48),
              AppColors.primary500.withValues(alpha: 0.28),
              AppColors.primary500.withValues(alpha: 0.15),
              AppColors.whiteBase.withValues(alpha: 0.15),
              AppColors.whiteBase,
            ],
            stops: const [0.0, 0.08, 0.12, 0.20, 0.25],
          ),
        ),
        child: child,
      ),
    );
  }
}
