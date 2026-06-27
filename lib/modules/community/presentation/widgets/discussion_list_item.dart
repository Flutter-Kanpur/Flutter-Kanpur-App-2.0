import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/domain/community_models.dart';
import 'package:flutter_knp_mobile_app_v2/utils/colors.dart';

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
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE2E2E2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question.title,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.primary,
                    height: 1.4,
                  ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: const Color(0xFFFFB5C8),
                  backgroundImage: question.authorPhotoUrl != null
                      ? NetworkImage(question.authorPhotoUrl!)
                      : null,
                  child: question.authorPhotoUrl == null
                      ? Text(
                          question.authorName.isNotEmpty
                              ? question.authorName[0].toUpperCase()
                              : '?',
                          style: const TextStyle(color: Colors.white, fontSize: 13),
                        )
                      : null,
                ),
                const SizedBox(width: 10),
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
                            ?.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${question.answerCount} answers',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.subtitleTextDarkGrey,
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
