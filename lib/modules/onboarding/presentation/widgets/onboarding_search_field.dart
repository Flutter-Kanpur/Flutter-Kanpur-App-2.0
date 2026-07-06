import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingSearchField extends StatelessWidget {
  const OnboardingSearchField({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'onboarding.searchRolesHint'.tr(),

        prefixIcon: const Icon(
          Icons.search,
        ),

        filled: true,
        fillColor: const Color(0xFFF7F7F7),

        contentPadding: EdgeInsets.symmetric(
          vertical: 16.h,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100.r),
          borderSide: BorderSide.none,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100.r),
          borderSide: BorderSide.none,
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100.r),

          borderSide: const BorderSide(
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}