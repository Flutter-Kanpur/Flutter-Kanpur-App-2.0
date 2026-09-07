import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:flutter_knp_mobile_app_v2/app/theme/app_borders.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/domain/community_models.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/presentation/widgets/community_author_row.dart';

class DiscussionListItem extends StatelessWidget {
  const DiscussionListItem({
    super.key,
    required this.question,
    required this.onTap,
  });

  final CommunityQuestion question;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final answers = question.answerCount;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: AppSpacing.v12),
        padding: AppSpacing.all(AppSpacing.h16),
        decoration: BoxDecoration(
          color: AppColors.whiteBase,
          borderRadius: AppRadius.all04,
          border: Border.all(color: AppBorders.secondary),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question.title,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.primary500,
                height: 1.4,
              ),
            ),
            if (question.imageUrl != null && question.imageUrl!.isNotEmpty) ...[
              SizedBox(height: AppSpacing.v12),
              ClipRRect(
                borderRadius: AppRadius.all02,
                child: CachedNetworkImage(
                  imageUrl: question.imageUrl!,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) => const SizedBox.shrink(),
                ),
              ),
            ],
            SizedBox(height: AppSpacing.v18),
            CommunityAuthorRow(
              name: question.authorName,
              subtitle: question.createdLabel,
              photoUrl: question.authorPhotoUrl,
              trailing: Text(
                answers == 1 ? '1 answer' : '$answers answers',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppColors.neutral500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
