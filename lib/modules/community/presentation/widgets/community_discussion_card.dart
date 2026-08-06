import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/domain/community_models.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_borders.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';

class CommunityDiscussionCard extends StatelessWidget {
  const CommunityDiscussionCard({
    super.key,
    required this.question,
    required this.width,
    required this.onTap,
  });

  final CommunityQuestion question;
  final double width;
  final VoidCallback onTap;

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
            _AuthorRow(
              name: question.authorName,
              time: question.createdLabel,
              photoUrl: question.authorPhotoUrl,
            ),
            SizedBox(height: AppSpacing.v18),
            Text(
              question.title,
              maxLines: 1,
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
            SizedBox(height: AppSpacing.v12),
            if (question.tag.isNotEmpty)
              Text(
                '#${question.tag}',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.primary500,
                ),
              ),
            SizedBox(height: AppSpacing.v10),
            const Divider(),
            Row(
              children: [
                const Icon(Icons.favorite_border_outlined, size: 18),
                SizedBox(width: AppSpacing.h4),
                Text('${question.answerCount}'),
                SizedBox(width: AppSpacing.h10),
                const Icon(Icons.chat_bubble_outline, size: 18),
                SizedBox(width: AppSpacing.h4),
                Text('${question.answerCount}'),
                const Spacer(),
                const Icon(
                  Icons.bookmark_outline,
                  color: AppColors.primary500,
                  size: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AuthorRow extends StatelessWidget {
  const _AuthorRow({required this.name, required this.time, this.photoUrl});

  final String name;
  final String time;
  final String? photoUrl;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: AppColors.warning300,
          backgroundImage: photoUrl != null ? NetworkImage(photoUrl!) : null,
          child: photoUrl == null
              ? Text(
                  name.isNotEmpty ? name[0].toUpperCase() : '?',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.whiteBase,
                  ),
                )
              : null,
        ),
        SizedBox(width: AppSpacing.h10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              Text(
                time,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.neutral400),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
