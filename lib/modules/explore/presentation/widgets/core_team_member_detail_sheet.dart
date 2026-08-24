import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_borders.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_knp_mobile_app_v2/modules/explore/domain/core_team_member.dart';
import 'package:flutter_knp_mobile_app_v2/modules/explore/domain/core_team_section.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_icon_button_circle.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_status_chip.dart';
import 'package:flutter_knp_mobile_app_v2/utils/assets_path.dart';
import 'package:flutter_knp_mobile_app_v2/utils/external_links.dart';
import 'package:flutter_knp_mobile_app_v2/utils/short_date_format.dart';

/// Full member profile shown when a grid card is tapped.
class CoreTeamMemberDetailSheet extends StatelessWidget {
  const CoreTeamMemberDetailSheet({
    super.key,
    required this.member,
    required this.isOrganisorsSection,
  });

  final CoreTeamMember member;
  final bool isOrganisorsSection;

  static Future<void> show(
    BuildContext context, {
    required CoreTeamMember member,
    required bool isOrganisorsSection,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => CoreTeamMemberDetailSheet(
        member: member,
        isOrganisorsSection: isOrganisorsSection,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final roleLabel = member.roleLabel(isOrganisorsSection: isOrganisorsSection);
    final roleColor = member.roleColor(isOrganisorsSection: isOrganisorsSection);
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.h20,
        0,
        AppSpacing.h20,
        AppSpacing.h20 + bottomInset,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: _MemberAvatar(member: member)),
            SizedBox(height: AppSpacing.v12),
            Center(
              child: Text(
                member.name,
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            if (member.hasUsername) ...[
              SizedBox(height: AppSpacing.v4),
              Center(
                child: Text(
                  '@${member.username!.trim()}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.neutral400,
                  ),
                ),
              ),
            ],
            SizedBox(height: AppSpacing.v8),
            Center(
              child: Text(
                roleLabel,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: roleColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (member.role.trim().isNotEmpty &&
                member.role.trim().toLowerCase() != roleLabel.toLowerCase()) ...[
              SizedBox(height: AppSpacing.v4),
              Center(
                child: Text(
                  member.role,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.neutral500,
                  ),
                ),
              ),
            ],
            if (member.joinedAt != null) ...[
              SizedBox(height: AppSpacing.v12),
              Center(
                child: FkStatusChip(
                  label:
                      'Joined ${member.joinedAt!.shortMonth} ${member.joinedAt!.year}',
                  color: AppColors.neutral500,
                ),
              ),
            ],
            if (member.hasBio) ...[
              SizedBox(height: AppSpacing.v16),
              Text(
                member.bio!.trim(),
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.neutral600,
                  height: 1.45,
                ),
              ),
            ],
            if (member.hasSkills) ...[
              SizedBox(height: AppSpacing.v16),
              Wrap(
                spacing: AppSpacing.h8,
                runSpacing: AppSpacing.v8,
                children: member.skills
                    .map((skill) => FkStatusChip(label: skill))
                    .toList(),
              ),
            ],
            if (member.hasSocialLinks) ...[
              SizedBox(height: AppSpacing.v16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (member.githubUrl != null &&
                      member.githubUrl!.trim().isNotEmpty)
                    FkIconButtonCircle(
                      assetPath: AssetsPath.githubSvg,
                      onTap: () => openExternalUrlOrNotify(
                        context,
                        member.githubUrl!,
                      ),
                    ),
                  if (member.githubUrl != null &&
                      member.githubUrl!.trim().isNotEmpty)
                    SizedBox(width: AppSpacing.h12),
                  if (member.websiteUrl != null &&
                      member.websiteUrl!.trim().isNotEmpty)
                    FkIconButtonCircle(
                      assetPath: AssetsPath.websiteSvg,
                      onTap: () => openExternalUrlOrNotify(
                        context,
                        member.websiteUrl!,
                      ),
                    ),
                  if (member.websiteUrl != null &&
                      member.websiteUrl!.trim().isNotEmpty)
                    SizedBox(width: AppSpacing.h12),
                  if (member.linkedinUrl != null &&
                      member.linkedinUrl!.trim().isNotEmpty)
                    FkIconButtonCircle(
                      assetPath: AssetsPath.linkedinSvg,
                      onTap: () => openExternalUrlOrNotify(
                        context,
                        member.linkedinUrl!,
                      ),
                    ),
                ],
              ),
            ],
            SizedBox(height: AppSpacing.v8),
          ],
        ),
      ),
    );
  }
}

class _MemberAvatar extends StatelessWidget {
  const _MemberAvatar({required this.member});

  final CoreTeamMember member;

  @override
  Widget build(BuildContext context) {
    const radius = 40.0;
    const size = radius * 2;
    final hasPhoto = member.photoUrl != null && member.photoUrl!.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppBorders.blue, width: 2),
      ),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: AppColors.primary100,
        child: ClipOval(
          child: hasPhoto
              ? CachedNetworkImage(
                  imageUrl: member.photoUrl!,
                  width: size,
                  height: size,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) => const _DefaultAvatar(size: size),
                )
              : _DefaultAvatar(
                  size: size,
                  fallbackLetter: member.name,
                ),
        ),
      ),
    );
  }
}

class _DefaultAvatar extends StatelessWidget {
  const _DefaultAvatar({required this.size, this.fallbackLetter = ''});

  final double size;
  final String fallbackLetter;

  @override
  Widget build(BuildContext context) {
    final letter = fallbackLetter.trim().isNotEmpty
        ? fallbackLetter.trim()[0].toUpperCase()
        : null;

    return SizedBox(
      width: size,
      height: size,
      child: Center(
        child: letter != null
            ? Text(
                letter,
                style: AppTextStyles.titleLarge.copyWith(
                  color: AppColors.primary500,
                  fontWeight: FontWeight.w700,
                ),
              )
            : const Icon(
                Icons.person,
                size: 36,
                color: AppColors.primary500,
              ),
      ),
    );
  }
}
