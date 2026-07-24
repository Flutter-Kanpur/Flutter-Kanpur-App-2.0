import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';

class OnboardingImagePickerSheet extends StatelessWidget {
  final VoidCallback onGalleryTap;
  final VoidCallback onCameraTap;
  final VoidCallback onRemoveTap;

  const OnboardingImagePickerSheet({
    super.key,
    required this.onGalleryTap,
    required this.onCameraTap,
    required this.onRemoveTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.s07,
        vertical: AppSpacing.s07,
      ),

      decoration: BoxDecoration(
        color: AppColors.whiteBase,

        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppRadius.r06),
          topRight: Radius.circular(AppRadius.r06),
        ),
      ),

      child: Column(
        mainAxisSize: MainAxisSize.min,

        children: [

          _buildTile(
            icon: Icons.photo_library_outlined,
            title: 'onboarding.importFromGallery'.tr(),
            onTap: onGalleryTap,
          ),

          20.verticalSpace,

          _buildTile(
            icon: Icons.camera_alt_outlined,
            title: 'onboarding.takePhoto'.tr(),
            onTap: onCameraTap,
          ),

          20.verticalSpace,

          _buildTile(
            icon: Icons.delete_outline_rounded,
            title: 'onboarding.removeCurrentPicture'.tr(),
            onTap: onRemoveTap,
            isDelete: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDelete = false,
  }) {

    return GestureDetector(
      onTap: onTap,

      child: Row(
        children: [

          Icon(
            icon,
            size: 24.sp,
            color: isDelete ? AppColors.warning600 : AppColors.blackBase,
          ),

          14.horizontalSpace,

          Text(
            title,

            style: AppTextStyles.titleMedium.copyWith(color: isDelete ? AppColors.warning600 : AppColors.blackBase),
          ),
        ],
      ),
    );
  }
}