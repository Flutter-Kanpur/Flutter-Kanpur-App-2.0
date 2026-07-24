import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'border_shadow_container.dart';
import '../../utils/assets_path.dart';
import '../../utils/translate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';

import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_borders.dart';

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
          padding: AppSpacing.all01,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppBorders.blue,
              width: 2.5.r,
            ),
          ),
          child: CircleAvatar(
            radius: 48.r,
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
        ),
        SizedBox(height: AppSpacing.s06),
        Text(
          displayName,
          style: AppTextStyles.headlineSmall.copyWith(color: AppColors.blackBase, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: AppSpacing.s04),
        Text(
          designation,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.neutral500,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: AppSpacing.s02),
        Text(
          username,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.neutral300,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: AppSpacing.s06),
        TextButton(
          onPressed: onEditProfile,
          style: TextButton.styleFrom(
            padding: AppSpacing.vertical(AppSpacing.s04),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            translate(context, "profile.editProfile"),
            style: AppTextStyles.bodyLarge.copyWith(color: AppColors.primary500),
          ),
        ),
        SizedBox(height: AppSpacing.s07),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ProfileSocialIcon(
              svgAsset: AssetsPath.githubSvg,
              onTap: githubUrl != null && githubUrl!.isNotEmpty
                  ? () => _launchURL(githubUrl!)
                  : null,
            ),
            SizedBox(width: AppSpacing.s07),
            ProfileSocialIcon(
              svgAsset: AssetsPath.websiteSvg,
              onTap: websiteUrl != null && websiteUrl!.isNotEmpty
                  ? () => _launchURL(websiteUrl!)
                  : null,
            ),
            SizedBox(width: AppSpacing.s07),
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
          shadowColor: AppColors.primary200.withOpacity(0.08),
          isShadowBottomLeft: true,
          isShadowBottomRight: true,
          isShadowTopLeft: true,
          isShadowTopRight: true,
          width: 44.w,
          height: 44.w,
          borderRadius: 22.r,
          child: Padding(
            padding: AppSpacing.all05,
            child: SvgPicture.asset(
              svgAsset,
              colorFilter: const ColorFilter.mode(AppColors.blackBase, BlendMode.srcIn),
            ),
          ),
        ),
      ),
    );
  }
}
