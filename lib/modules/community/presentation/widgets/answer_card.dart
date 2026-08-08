import 'package:flutter/material.dart';

import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/domain/community_models.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/presentation/widgets/community_author_row.dart';
import 'package:flutter_knp_mobile_app_v2/utils/count_format.dart';

/// One reply in a discussion thread.
class AnswerCard extends StatelessWidget {
  const AnswerCard({
    super.key,
    required this.reply,
    required this.isOwnAnswer,
    this.onLike,
    this.onReply,
    this.onDelete,
  });

  final CommunityReply reply;
  final bool isOwnAnswer;
  final VoidCallback? onLike;
  final VoidCallback? onReply;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.v18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommunityAuthorRow(
            name: reply.authorName,
            subtitle: reply.createdLabel,
            photoUrl: reply.authorPhotoUrl,
            radius: 16,
            trailing: isOwnAnswer && onDelete != null
                ? PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, size: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.all03,
                    ),
                    onSelected: (_) => _confirmDelete(context),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'delete',
                        child: Text(
                          'Delete',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.warning600,
                          ),
                        ),
                      ),
                    ],
                  )
                : null,
          ),
          SizedBox(height: AppSpacing.v12),
          Text(
            reply.body,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.blackBase,
              height: 1.5,
            ),
          ),
          SizedBox(height: AppSpacing.v12),
          Row(
            children: [
              _Action(
                icon: reply.isLiked
                    ? Icons.favorite
                    : Icons.favorite_border_outlined,
                color: reply.isLiked
                    ? AppColors.warning600
                    : AppColors.neutral500,
                label: formatCount(reply.likeCount),
                onTap: onLike,
                tooltip: reply.isLiked ? 'Unlike' : 'Like',
              ),
              SizedBox(width: AppSpacing.h16),
              _Action(
                icon: Icons.mode_comment_outlined,
                color: AppColors.neutral500,
                label: reply.commentCount == 1
                    ? '1 reply'
                    : '${formatCount(reply.commentCount)} reply',
                onTap: onReply,
                tooltip: 'Reply',
              ),
            ],
          ),
          SizedBox(height: AppSpacing.v12),
          const Divider(height: 1),
        ],
      ),
    );
  }

  /// Deleting a reply is not undoable, so confirm before calling through.
  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete reply?'),
        content: const Text('This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(
              'Delete',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.warning600,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) onDelete?.call();
  }
}

class _Action extends StatelessWidget {
  const _Action({
    required this.icon,
    required this.color,
    required this.label,
    required this.tooltip,
    this.onTap,
  });

  final IconData icon;
  final Color color;
  final String label;
  final String tooltip;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.all02,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.h4,
            vertical: AppSpacing.v4,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: color),
              SizedBox(width: AppSpacing.h6),
              Text(
                label,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.neutral600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
