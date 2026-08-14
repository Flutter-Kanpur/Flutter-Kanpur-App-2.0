import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_knp_mobile_app_v2/modules/explore/domain/core_team_member.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_section_title.dart';

class CoreTeamPreviewSection extends StatelessWidget {
  const CoreTeamPreviewSection({
    super.key,
    required this.members,
    required this.onViewAllTap,
  });

  final List<CoreTeamMember> members;
  final VoidCallback onViewAllTap;

  @override
  Widget build(BuildContext context) {
    if (members.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FkSectionTitle(
          title: 'Core team',
          actionLabel: 'View all',
          onActionTap: onViewAllTap,
        ),
        SizedBox(
          height: 90,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: members.length,
            separatorBuilder: (_, __) => SizedBox(width: AppSpacing.h16),
            itemBuilder: (context, index) {
              final member = members[index];
              return InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(40),
                child: SizedBox(
                  width: 64,
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: AppColors.neutral100,
                        backgroundImage: CachedNetworkImageProvider(
                          member.photoUrl,
                        ),
                      ),
                      SizedBox(height: AppSpacing.v6),
                      Text(
                        member.name,
                        style: AppTextStyles.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
