import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';

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
      shape: RoundedRectangleBorder(borderRadius: AppRadius.all06),

      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.h16,
          vertical: AppSpacing.v16,
        ),

        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            Text(
              'onboarding.removePhotoTitle'.tr(),

              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.blackBase,
                fontWeight: FontWeight.w700,
              ),
            ),

            12.verticalSpace,

            Text(
              'onboarding.removePhotoSubTitle'.tr(),

              textAlign: TextAlign.center,

              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.neutral500,
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
                      minimumSize: Size(double.infinity, 48.h),

                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.all03,
                      ),
                    ),

                    child: Text('onboarding.cancel'.tr()),
                  ),
                ),

                12.horizontalSpace,

                Expanded(
                  child: ElevatedButton(
                    onPressed: onDeleteTap,

                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.warning600,

                      minimumSize: Size(double.infinity, 48.h),

                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.all03,
                      ),
                    ),

                    child: Text('onboarding.delete'.tr()),
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
