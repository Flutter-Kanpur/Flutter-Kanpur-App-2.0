import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/domain/community_models.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_borders.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';

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
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.primary500,
                    height: 1.4,
                  ),
            ),
            SizedBox(height: AppSpacing.v18),
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.warning300,
                  backgroundImage: question.authorPhotoUrl != null
                      ? NetworkImage(question.authorPhotoUrl!)
                      : null,
                  child: question.authorPhotoUrl == null
                      ? Text(
                          question.authorName.isNotEmpty
                              ? question.authorName[0].toUpperCase()
                              : '?',
                          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.whiteBase),
                        )
                      : null,
                ),
                SizedBox(width: AppSpacing.h10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        question.authorName,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      Text(
                        question.createdLabel,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: AppColors.neutral400),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${question.answerCount} answers',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.neutral500,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
