import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingCustomChip extends StatelessWidget {
  final String title;
  final VoidCallback onRemove;

  const OnboardingCustomChip({
    super.key,
    required this.title,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 14.w,
        vertical: 10.h,
      ),

      decoration: BoxDecoration(
        color: Colors.black,

        borderRadius: BorderRadius.circular(24.r),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,

        children: [

          Text(
            title,

            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),

          8.horizontalSpace,

          GestureDetector(
            onTap: onRemove,

            child: Icon(
              Icons.close,
              color: Colors.white,
              size: 18.sp,
            ),
          ),
        ],
      ),
    );
  }
}