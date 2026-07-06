import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingLinksForm extends StatelessWidget {
  const OnboardingLinksForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        TextField(
          decoration: InputDecoration(
            hintText: 'onboarding.githubLink'.tr(),

            filled: true,
            fillColor: const Color(0xFFF7F7F7),

            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 18.h,
            ),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: BorderSide.none,
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: BorderSide.none,
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),

              borderSide: const BorderSide(
                color: Colors.black,
              ),
            ),
          ),
        ),

        16.verticalSpace,

        TextField(
          decoration: InputDecoration(
            hintText: 'onboarding.linkedinLink'.tr(),

            filled: true,
            fillColor: const Color(0xFFF7F7F7),

            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 18.h,
            ),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: BorderSide.none,
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: BorderSide.none,
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),

              borderSide: const BorderSide(
                color: Colors.black,
              ),
            ),
          ),
        ),

        16.verticalSpace,

        TextField(
          decoration: InputDecoration(
            hintText: 'onboarding.portfolioLink'.tr(),

            filled: true,
            fillColor: const Color(0xFFF7F7F7),

            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 18.h,
            ),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: BorderSide.none,
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: BorderSide.none,
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),

              borderSide: const BorderSide(
                color: Colors.black,
              ),
            ),
          ),
        ),

        12.verticalSpace,

        Align(
          alignment: Alignment.centerLeft,

          child: Text(
            'onboarding.editAnytime'.tr(),

            style: TextStyle(
              color: Colors.orange,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}