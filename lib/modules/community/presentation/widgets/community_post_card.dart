import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/domain/community_models.dart';
import 'package:flutter_knp_mobile_app_v2/common_widgets/fk_card.dart';
import 'package:flutter_knp_mobile_app_v2/common_widgets/fk_status_chip.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';

class CommunityPostCard extends StatelessWidget {
  const CommunityPostCard({super.key, required this.post, this.onTap});

  final CommunityPost post;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FkCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.primary500.withValues(alpha: 0.12),
                child: Text(post.authorName.substring(0, 1)),
              ),
              SizedBox(width: AppSpacing.h10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.authorName,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      '${post.authorRole} - ${post.createdLabel}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.neutral500,
                      ),
                    ),
                  ],
                ),
              ),
              FkStatusChip(
                label: _typeLabel(post.type),
                icon: _typeIcon(post.type),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.v16),
          Text(
            post.title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: AppSpacing.v8),
          Text(post.body, style: theme.textTheme.bodyMedium),
          SizedBox(height: AppSpacing.v12),
          Wrap(
            spacing: AppSpacing.h8,
            runSpacing: AppSpacing.v8,
            children: post.tags
                .map((tag) => FkStatusChip(label: '#$tag'))
                .toList(),
          ),
          SizedBox(height: AppSpacing.v16),
          Row(
            children: [
              _Metric(
                icon: Icons.chat_bubble_outline,
                label: '${post.replyCount} replies',
              ),
              SizedBox(width: AppSpacing.h16),
              _Metric(
                icon: Icons.favorite_border_rounded,
                label: '${post.likeCount} likes',
              ),
            ],
          ),
        ],
      ),
    );
  }

  static String _typeLabel(CommunityPostType type) {
    return switch (type) {
      CommunityPostType.announcement => 'Update',
      CommunityPostType.discussion => 'Discuss',
      CommunityPostType.question => 'Question',
      CommunityPostType.project => 'Project',
    };
  }

  static IconData _typeIcon(CommunityPostType type) {
    return switch (type) {
      CommunityPostType.announcement => Icons.campaign_rounded,
      CommunityPostType.discussion => Icons.forum_rounded,
      CommunityPostType.question => Icons.help_outline_rounded,
      CommunityPostType.project => Icons.handyman_rounded,
    };
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppColors.neutral500),
        SizedBox(width: AppSpacing.h4),
        Text(label),
      ],
    );
  }
}
