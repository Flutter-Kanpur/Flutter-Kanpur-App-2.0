import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingRemovePhotoDialog extends StatelessWidget {
  final VoidCallback onDeleteTap;
  final VoidCallback onCancelTap;

  const OnboardingRemovePhotoDialog({
    super.key,
    required this.onDeleteTap,
    required this.onCancelTap,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.r),
      ),

      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 24.w,
          vertical: 24.h,
        ),

        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [

            Text(
              'onboarding.removePhotoTitle'.tr(),

              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),

            12.verticalSpace,

            Text(
              'onboarding.removePhotoSubTitle'.tr(),

              textAlign: TextAlign.center,

              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF7A7A7A),
                height: 1.5,
              ),
            ),

            24.verticalSpace,

            Row(
              children: [

                Expanded(
                  child: OutlinedButton(
                    onPressed: onCancelTap,

                    style: OutlinedButton.styleFrom(
                      minimumSize: Size(
                        double.infinity,
                        48.h,
                      ),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                    ),

                    child: Text(
                      'onboarding.cancel'.tr(),
                    ),
                  ),
                ),

                12.horizontalSpace,

                Expanded(
                  child: ElevatedButton(
                    onPressed: onDeleteTap,

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,

                      minimumSize: Size(
                        double.infinity,
                        48.h,
                      ),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                    ),

                    child: Text(
                      'onboarding.delete'.tr(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}