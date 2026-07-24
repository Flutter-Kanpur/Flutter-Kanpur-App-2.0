import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/domain/community_models.dart';
import 'package:flutter_knp_mobile_app_v2/common_widgets/fk_card.dart';
import 'package:flutter_knp_mobile_app_v2/common_widgets/fk_status_chip.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';

class CommunityMemberCard extends StatelessWidget {
  const CommunityMemberCard({super.key, required this.member});

  final CommunityMember member;

  @override
  Widget build(BuildContext context) {
    return FkCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: AppColors.primary500.withValues(alpha: 0.12),
            child: Text(member.name.substring(0, 1)),
          ),
          SizedBox(width: AppSpacing.s06),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: AppSpacing.s02),
                Text(member.role),
                SizedBox(height: AppSpacing.s05),
                Wrap(
                  spacing: AppSpacing.s04,
                  runSpacing: AppSpacing.s04,
                  children: member.skills
                      .map((skill) => FkStatusChip(label: skill))
                      .toList(),
                ),
              ],
            ),
          ),
          FkStatusChip(label: member.status, color: AppColors.success600),
        ],
      ),
    );
  }
}
