import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kanpur_ui_kit/flutter_kanpur_ui_kit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingRoleScreen extends StatelessWidget {
  final VoidCallback onNext;

  const OnboardingRoleScreen({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    final List<String> roles = [
      'Flutter Developer',
      'Backend Developer',
      'Frontend Developer',
      'UI/UX Designer',
      'Android Developer',
      'iOS Developer',
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'onboarding.searchRolesHint'.tr(),

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100.r),
              ),
            ),
          ),

          20.verticalSpace,

          Wrap(
            spacing: 10.w,
            runSpacing: 10.h,

            children: roles.map((role) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24.r),

                  border: Border.all(color: const Color(0xFFE0E0E0)),
                ),

                child: Text(role),
              );
            }).toList(),
          ),

          16.verticalSpace,

          Text(
            'onboarding.addOther'.tr(),

            style: TextStyle(color: const Color(0xFF4167F2), fontSize: 16.sp),
          ),

          const Spacer(),

          GradientButton(
            text: 'onboarding.continue'.tr(),
            onTap: onNext,
            height: 48.h,
            width: double.infinity,
          ),

          16.verticalSpace,

          Center(child: Text('onboarding.skipForNow'.tr())),

          24.verticalSpace,
        ],
      ),
    );
  }
}
