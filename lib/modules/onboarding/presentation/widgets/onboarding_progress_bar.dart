import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';

class OnboardingProgressBar extends StatelessWidget {
  final int currentStep;

  const OnboardingProgressBar({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(4, (index) {
        final bool isActive = currentStep >= index;

        return Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),

            margin: AppSpacing.horizontal(AppSpacing.h4),

            height: 6.h,

            decoration: BoxDecoration(
              color: isActive ? AppColors.blackBase : AppColors.neutral100,

              borderRadius: AppRadius.all09,
            ),
          ),
        );
      }),
    );
  }
}
