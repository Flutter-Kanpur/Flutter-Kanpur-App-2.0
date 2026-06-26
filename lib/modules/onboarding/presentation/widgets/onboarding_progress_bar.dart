import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingProgressBar extends StatelessWidget {
  final int currentStep;

  const OnboardingProgressBar({
    super.key,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        4,
            (index) {
          final bool isActive = currentStep >= index;

          return Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),

              margin: EdgeInsets.symmetric(horizontal: 4.w),

              height: 6.h,

              decoration: BoxDecoration(
                color: isActive
                    ? Colors.black
                    : const Color(0xFFE5E5E5),

                borderRadius: BorderRadius.circular(100.r),
              ),
            ),
          );
        },
      ),
    );
  }
}