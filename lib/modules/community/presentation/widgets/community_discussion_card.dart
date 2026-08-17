import 'package:flutter/material.dart';

import 'package:flutter_knp_mobile_app_v2/app/theme/app_borders.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/domain/community_models.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/presentation/widgets/community_author_row.dart';
import 'package:flutter_knp_mobile_app_v2/utils/count_format.dart';

/// Card in the "Featured discussions" carousel.
class CommunityDiscussionCard extends StatelessWidget {
  const CommunityDiscussionCard({
    super.key,
    required this.question,
    required this.width,
    required this.onTap,
    this.onLike,
    this.onSave,
  });

  final CommunityQuestion question;
  final double width;
  final VoidCallback onTap;
  final VoidCallback? onLike;
  final VoidCallback? onSave;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        padding: AppSpacing.all(AppSpacing.h16),
        decoration: BoxDecoration(
          color: AppColors.whiteBase,
          borderRadius: AppRadius.all06,
          border: Border.all(color: AppBorders.secondary),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommunityAuthorRow(
              name: question.authorName,
              subtitle: question.createdLabel,
              photoUrl: question.authorPhotoUrl,
            ),
            SizedBox(height: AppSpacing.v18),
            Text(
              question.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: AppSpacing.v10),
            Expanded(
              child: Text(
                question.body,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.neutral500,
                ),
              ),
            ),
            if (question.tags.isNotEmpty) ...[
              SizedBox(height: AppSpacing.v10),
              Text(
                question.tags.map((t) => '#$t').join('  '),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.primary500,
                ),
              ),
            ],
            SizedBox(height: AppSpacing.v10),
            const Divider(),
            Row(
              children: [
                _CountAction(
                  // Was showing answerCount next to a heart, so likes and
                  // answers rendered the same number.
                  icon: question.isLiked
                      ? Icons.favorite
                      : Icons.favorite_border_outlined,
                  color: question.isLiked
                      ? AppColors.warning600
                      : AppColors.neutral500,
                  count: question.likeCount,
                  onTap: onLike,
                  tooltip: question.isLiked ? 'Unlike' : 'Like',
                ),
                SizedBox(width: AppSpacing.h16),
                _CountAction(
                  icon: Icons.chat_bubble_outline,
                  color: AppColors.neutral500,
                  count: question.answerCount,
                  onTap: onTap,
                  tooltip: 'Answers',
                ),
                const Spacer(),
                _CountAction(
                  icon: question.isSaved
                      ? Icons.bookmark
                      : Icons.bookmark_outline,
                  color: AppColors.primary500,
                  count: question.saveCount,
                  onTap: onSave,
                  tooltip: question.isSaved ? 'Remove bookmark' : 'Bookmark',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CountAction extends StatelessWidget {
  const _CountAction({
    required this.icon,
    required this.color,
    required this.count,
    required this.tooltip,
    this.onTap,
  });

  final IconData icon;
  final Color color;
  final int count;
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
              SizedBox(width: AppSpacing.h4),
              Text(
                formatCount(count),
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
