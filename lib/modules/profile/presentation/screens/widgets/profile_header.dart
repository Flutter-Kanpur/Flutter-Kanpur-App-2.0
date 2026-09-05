import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_borders.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.displayName,
    required this.username,
    this.photoUrl,
    this.onEditProfile,
  });

  final String displayName;
  /// Already formatted handle, e.g. "@angie…" — empty if none.
  final String username;
  final String? photoUrl;
  final VoidCallback? onEditProfile;

  bool get _hasUsername => username.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.h20,
        AppSpacing.v16,
        AppSpacing.h20,
        AppSpacing.v22,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Figma: 100×100 avatar + blue ring
          Container(
            width: 100.w,
            height: 100.w,
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppBorders.blue, width: 2.5),
            ),
            child: CircleAvatar(
              radius: 48.w,
              backgroundColor: AppColors.neutral100,
              backgroundImage: photoUrl != null && photoUrl!.isNotEmpty
                  ? NetworkImage(photoUrl!)
                  : null,
              child: photoUrl == null || photoUrl!.isEmpty
                  ? Text(
                      displayName.isNotEmpty
                          ? displayName[0].toUpperCase()
                          : '?',
                      style: AppTextStyles.titleLarge.copyWith(
                        color: AppColors.blackBase,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  : null,
            ),
          ),
          SizedBox(width: AppSpacing.h16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  displayName,
                  style: AppTextStyles.titleLarge.copyWith(
                    color: AppColors.blackBase,
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                // Only show username row when it exists
                if (_hasUsername) ...[
                  SizedBox(height: AppSpacing.v4),
                  Text(
                    username,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.neutral400,
                      fontWeight: FontWeight.w400,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
                SizedBox(height: AppSpacing.v6),
                GestureDetector(
                  onTap: onEditProfile,
                  child: Text(
                    'profile.editProfile'.tr(),
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.primary500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}