import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
        horizontal: 24.w,
        vertical: 24.h,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
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
            color: isDelete ? Colors.red : Colors.black,
          ),

          14.horizontalSpace,

          Text(
            title,

            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: isDelete ? Colors.red : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}