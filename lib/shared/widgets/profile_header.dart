import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/colors.dart';
import '../../utils/text_styles.dart';

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
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
      child: Row(
        children: [
          CircleAvatar(
            radius: 36.r,
            backgroundColor: AppColors.avatarBackgroundColor,
            backgroundImage: photoUrl != null && photoUrl!.isNotEmpty
                ? NetworkImage(photoUrl!)
                : null,
            child: photoUrl == null || photoUrl!.isEmpty
                ? Text(
                    displayName.isNotEmpty ? displayName[0].toUpperCase() : '?',
                    style: textStyle_18MediumBlack().copyWith(fontSize: 24.sp),
                  )
                : null,
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style: textStyle_18MediumBlack(),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  username,
                  style: textStyle_14RegularGrey().copyWith(
                    color: AppColors.contributorFieldHintColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 6.h),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    'Edit profile',
                    style: textStyle_14RegularLinkBlue(),
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
