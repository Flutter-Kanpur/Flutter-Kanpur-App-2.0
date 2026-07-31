import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_borders.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';

class AnswerCard extends ConsumerWidget {
  final String answerId;
  final String authorName;
  final String? authorPhotoUrl;
  final String body;
  final String createdAt;
  final int likeCount;
  final bool isOwnAnswer;
  final VoidCallback? onDelete;
  final VoidCallback? onLike;

  const AnswerCard({
    super.key,
    required this.answerId,
    required this.authorName,
    required this.body,
    required this.createdAt,
    required this.likeCount,
    this.authorPhotoUrl,
    this.isOwnAnswer = false,
    this.onDelete,
    this.onLike,
  });

  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSpacing.v16),
      padding: AppSpacing.all(AppSpacing.h12),
      decoration: BoxDecoration(
        border: Border.all(color: AppBorders.primary),
        borderRadius: AppRadius.all02,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Info Header
          Row(
            children: [
              CircleAvatar(
                radius: 18.r,
                backgroundImage: authorPhotoUrl != null
                    ? NetworkImage(authorPhotoUrl!)
                    : null,
                child: authorPhotoUrl == null
                    ? Text(
                        _getInitials(authorName),
                        style: AppTextStyles.labelMedium,
                      )
                    : null,
              ),
              SizedBox(width: AppSpacing.h12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(authorName, style: AppTextStyles.labelLarge),
                    Text(
                      createdAt,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.neutral500,
                      ),
                    ),
                  ],
                ),
              ),
              if (isOwnAnswer)
                PopupMenuButton(
                  itemBuilder: (context) => [
                    if (onDelete != null)
                      PopupMenuItem(
                        child: Text(
                          'Delete',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.warning600,
                          ),
                        ),
                        onTap: onDelete,
                      ),
                  ],
                  icon: const Icon(Icons.more_vert),
                ),
            ],
          ),
          SizedBox(height: AppSpacing.v12),

          // Answer Body
          Text(
            body,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.blackBase,
              height: 1.5,
            ),
          ),
          SizedBox(height: AppSpacing.v12),

          // Bottom Stats
          Row(
            children: [
              // Like Button
              TextButton.icon(
                onPressed: onLike,
                icon: const Icon(Icons.thumb_up_outlined, size: 16),
                label: Text('$likeCount'),
                style: TextButton.styleFrom(
                  padding: AppSpacing.horizontal(AppSpacing.h8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
