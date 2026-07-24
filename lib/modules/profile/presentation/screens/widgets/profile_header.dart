import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';

import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.displayName,
    required this.username,
    this.photoUrl,
  });

  final String displayName;
  final String username;
  final String? photoUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(AppSpacing.s09, AppSpacing.s07, AppSpacing.s09, AppSpacing.s10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 36.r,
            backgroundColor: AppColors.neutral100,
            backgroundImage: photoUrl != null && photoUrl!.isNotEmpty
                ? NetworkImage(photoUrl!)
                : null,
            child: photoUrl == null || photoUrl!.isEmpty
                ? Text(
                    displayName.isNotEmpty ? displayName[0].toUpperCase() : '?',
                    style: AppTextStyles.titleLarge.copyWith(color: AppColors.blackBase, fontWeight: FontWeight.w600),
                  )
                : null,
          ),
          SizedBox(width: AppSpacing.s07),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style: AppTextStyles.titleLarge.copyWith(color: AppColors.blackBase, fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: AppSpacing.s02),
                Text(
                  username,
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.neutral300, fontWeight: FontWeight.w300),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: AppSpacing.s03),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    'Edit profile',
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primary500),
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
