import 'package:flutter/material.dart';
import 'border_shadow_container.dart';
import '../../utils/assets_path.dart';
import '../../utils/translate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../utils/colors.dart';
import '../../../utils/text_styles.dart';

class ManageProfileHeader extends StatelessWidget {
  const ManageProfileHeader({
    super.key,
    required this.displayName,
    required this.designation,
    required this.username,
    this.photoUrl,
    required this.onEditProfile,
    this.githubUrl,
    this.websiteUrl,
    this.linkedinUrl,
  });

  final String displayName;
  final String designation;
  final String username;
  final String? photoUrl;
  final VoidCallback onEditProfile;
  final String? githubUrl;
  final String? websiteUrl;
  final String? linkedinUrl;

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url.startsWith('http') ? url : 'https://$url');
    if (!await launchUrl(uri)) {
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(3.r),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.primary,
              width: 2.5.r,
            ),
          ),
          child: CircleAvatar(
            radius: 48.r,
            backgroundColor: AppColors.avatarBackgroundColor,
            backgroundImage: photoUrl != null && photoUrl!.isNotEmpty
                ? NetworkImage(photoUrl!)
                : null,
            child: photoUrl == null || photoUrl!.isEmpty
                ? Text(
                    displayName.isNotEmpty ? displayName[0].toUpperCase() : '?',
                    style: textStyle_18MediumBlack().copyWith(fontSize: 32.sp),
                  )
                : null,
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          displayName,
          style: textStyle_24BoldBlack(),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8.h),
        Text(
          designation,
          style: textStyle_14RegularBlack().copyWith(
            color: const Color(0xFF666666),
            fontSize: 18.sp,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 4.h),
        Text(
          username,
          style: textStyle_14RegularBlack().copyWith(
            color: const Color(0xFFAAAAAA),
            fontSize: 16.sp,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 12.h),
        TextButton(
          onPressed: onEditProfile,
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            translate(context, "profile.editProfile"),
            style: textStyle_16RegularLinkBlue(),
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ProfileSocialIcon(
              svgAsset: AssetsPath.githubSvg,
              onTap: githubUrl != null && githubUrl!.isNotEmpty
                  ? () => _launchURL(githubUrl!)
                  : null,
            ),
            SizedBox(width: 16.w),
            ProfileSocialIcon(
              svgAsset: AssetsPath.websiteSvg,
              onTap: websiteUrl != null && websiteUrl!.isNotEmpty
                  ? () => _launchURL(websiteUrl!)
                  : null,
            ),
            SizedBox(width: 16.w),
            ProfileSocialIcon(
              svgAsset: AssetsPath.linkedinSvg,
              onTap: linkedinUrl != null && linkedinUrl!.isNotEmpty
                  ? () => _launchURL(linkedinUrl!)
                  : null,
            ),
          ],
        ),
      ],
    );
  }
}

class ProfileSocialIcon extends StatelessWidget {
  const ProfileSocialIcon({
    super.key,
    required this.svgAsset,
    this.onTap,
  });

  final String svgAsset;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: onTap == null ? 0.4 : 1.0,
        child: InnerShadowContainer(
          shadowColor: const Color(0XFFB3C4FF).withOpacity(0.08),
          isShadowBottomLeft: true,
          isShadowBottomRight: true,
          isShadowTopLeft: true,
          isShadowTopRight: true,
          width: 44.w,
          height: 44.w,
          borderRadius: 22.r,
          child: Padding(
            padding: EdgeInsets.all(10.sp),
            child: SvgPicture.asset(
              svgAsset,
              colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
            ),
          ),
        ),
      ),
    );
  }
}
