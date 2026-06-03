import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/domain/community_models.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_card.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_status_chip.dart';
import 'package:flutter_knp_mobile_app_v2/utils/colors.dart';

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
            backgroundColor: AppColors.primary.withValues(alpha: 0.12),
            child: Text(member.name.substring(0, 1)),
          ),
          const SizedBox(width: 12),
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
                const SizedBox(height: 4),
                Text(member.role),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: member.skills
                      .map((skill) => FkStatusChip(label: skill))
                      .toList(),
                ),
              ],
            ),
          ),
          FkStatusChip(label: member.status, color: AppColors.successColor),
        ],
      ),
    );
  }
}
