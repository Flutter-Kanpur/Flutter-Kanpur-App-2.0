import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kanpur_ui_kit/flutter_kanpur_ui_kit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingSkillsScreen extends StatelessWidget {
  final VoidCallback onNext;

  const OnboardingSkillsScreen({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    final List<String> skills = [
      'Flutter',
      'Firebase',
      'Dart',
      'UI Design',
      'Git',
      'Supabase',
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,

      resizeToAvoidBottomInset: false,

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14.r),

                  border: Border.all(color: const Color(0xFFE0E0E0)),
                ),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    Text('onboarding.yearsOfExperience'.tr()),

                    const Icon(Icons.keyboard_arrow_down_rounded),
                  ],
                ),
              ),

              20.verticalSpace,

              Wrap(
                spacing: 10.w,
                runSpacing: 10.h,

                children: skills.map((skill) {
                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 10.h,
                    ),

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24.r),

                      border: Border.all(color: const Color(0xFFE0E0E0)),
                    ),

                    child: Text(skill),
                  );
                }).toList(),
              ),

              16.verticalSpace,

              Text(
                'onboarding.addOther'.tr(),

                style: TextStyle(
                  color: const Color(0xFF4167F2),
                  fontSize: 16.sp,
                ),
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
        ),
      ),
    );
  }
}
