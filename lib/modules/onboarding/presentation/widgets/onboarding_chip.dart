import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingChip extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const OnboardingChip({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),

        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 10.h,
        ),

        decoration: BoxDecoration(
          color: isSelected
              ? Colors.black
              : Colors.white,

          borderRadius: BorderRadius.circular(24.r),

          border: Border.all(
            color: isSelected
                ? Colors.black
                : const Color(0xFFE0E0E0),
          ),
        ),

        child: Text(
          title,

          style: TextStyle(
            color: isSelected
                ? Colors.white
                : Colors.black,

            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}