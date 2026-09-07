import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_knp_mobile_app_v2/modules/explore/domain/core_team_member.dart';
import 'package:flutter_knp_mobile_app_v2/modules/explore/domain/core_team_section.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/border_shadow_container.dart';

/// White shadowed grid tile for the core-team browse screen.
class CoreTeamMemberGridCard extends StatelessWidget {
  const CoreTeamMemberGridCard({
    super.key,
    required this.member,
    required this.isOrganisorsSection,
    required this.onTap,
  });

  final CoreTeamMember member;
  final bool isOrganisorsSection;
  final VoidCallback onTap;

  static const _avatarSize = 72.0;

  @override
  Widget build(BuildContext context) {
    final roleLabel = member.roleLabel(isOrganisorsSection: isOrganisorsSection);
    final roleColor = member.roleColor(isOrganisorsSection: isOrganisorsSection);

    return LayoutBuilder(
      builder: (context, constraints) {
        return InnerShadowContainer(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          backgroundColor: AppColors.whiteBase,
          borderColor: AppColors.communityBorder,
          borderRadius: 16,
          shadowColor: const Color(0XFFB3C4FF).withValues(alpha: 0.10),
          isShadowBottomLeft: true,
          isShadowBottomRight: true,
          isShadowTopLeft: true,
          isShadowTopRight: true,
          alignment: Alignment.center,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              // borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.h8,
                  vertical: AppSpacing.h10,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _MemberAvatar(photoUrl: member.photoUrl),
                    SizedBox(height: AppSpacing.v8),
                    Text(
                      member.name,
                      style: AppTextStyles.titleMedium.copyWith(
                        color: AppColors.blackBase,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                    if (roleLabel.isNotEmpty) ...[
                      SizedBox(height: AppSpacing.v6),
                      Text(
                        roleLabel,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: roleColor,
                          fontWeight: FontWeight.w500,
                          height: 1.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _MemberAvatar extends StatelessWidget {
  const _MemberAvatar({required this.photoUrl});

  final String? photoUrl;

  @override
  Widget build(BuildContext context) {
    final hasPhoto = photoUrl != null && photoUrl!.trim().isNotEmpty;

    return Container(
      width: CoreTeamMemberGridCard._avatarSize,
      height: CoreTeamMemberGridCard._avatarSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.communityBorder, width: 1.5),
      ),
      child: ClipOval(
        child: hasPhoto
            ? CachedNetworkImage(
                imageUrl: photoUrl!,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => const _DefaultAvatar(),
              )
            : const _DefaultAvatar(),
      ),
    );
  }
}

class _DefaultAvatar extends StatelessWidget {
  const _DefaultAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary100,
      child: const Center(
        child: Icon(
          Icons.person,
          size: 28,
          color: AppColors.primary500,
        ),
      ),
    );
  }
}
