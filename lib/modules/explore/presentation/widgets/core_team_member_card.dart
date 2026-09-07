import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_knp_mobile_app_v2/modules/explore/domain/core_team_member.dart';
import 'package:flutter_knp_mobile_app_v2/modules/explore/domain/core_team_section.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/border_shadow_container.dart';

/// Shadowed card tile used in older core-team layouts.
class CoreTeamMemberCard extends StatelessWidget {
  const CoreTeamMemberCard({
    super.key,
    required this.member,
    required this.isOrganisorsSection,
    this.onTap,
  });

  final CoreTeamMember member;
  final bool isOrganisorsSection;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final roleLabel = member.roleLabel(isOrganisorsSection: isOrganisorsSection);
    final roleColor = member.roleColor(isOrganisorsSection: isOrganisorsSection);

    final content = Container(
      color: AppColors.whiteBase,
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.h12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildAvatar(),
            SizedBox(height: AppSpacing.v6),
            Text(
              member.name,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w500,
                height: 1.2,
              ),
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.v6),
            Text(
              roleLabel,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmall.copyWith(
                height: 1.2,
                color: roleColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );

    if (onTap == null) return content;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: content,
    );
  }

  Widget _buildAvatar() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(width: 1.5, color: AppColors.communityBorder),
      ),
      width: 65,
      height: 65,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: member.photoUrl != null && member.photoUrl!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: member.photoUrl!,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => _buildDefaultAvatar(),
              )
            : _buildDefaultAvatar(),
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      color: AppColors.primary100,
      child: const Icon(
        Icons.person,
        size: 32,
        color: AppColors.primary500,
      ),
    );
  }
}
