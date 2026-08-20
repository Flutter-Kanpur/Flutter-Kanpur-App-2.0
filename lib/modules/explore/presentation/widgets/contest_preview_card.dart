import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_knp_mobile_app_v2/modules/explore/application/contest_providers.dart';
import 'package:flutter_knp_mobile_app_v2/modules/explore/domain/contest_preview.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ContestPreviewCard extends ConsumerWidget {
  const ContestPreviewCard({super.key, required this.contest});

  final ContestPreview contest;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (contest.phase == ContestPhase.ongoing ||
        contest.phase == ContestPhase.upcoming) {
      ref.watch(contestCountdownTickerProvider);
    }

    final isLiked = (ref.watch(likedContestIdsProvider).value ?? const {})
        .contains(contest.id);

    return FkCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  contest.categoryLabel,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.neutral500,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => ref
                    .read(likedContestIdsProvider.notifier)
                    .toggle(contest.id),
                icon: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  color: isLiked ? AppColors.errorFg : AppColors.neutral400,
                  size: 20,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.v8),
          Text(
            contest.title,
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppSpacing.v12),
          Wrap(
            spacing: AppSpacing.h8,
            runSpacing: AppSpacing.v8,
            children: contest.tags
                .map(
                  (tag) => Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.h16,
                      vertical: AppSpacing.v8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.neutral50,
                      borderRadius: AppRadius.all09,
                    ),
                    child: Text(
                      tag,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.blackBase,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          SizedBox(height: AppSpacing.v16),
          const Divider(height: 1, thickness: 1),
          SizedBox(height: AppSpacing.v16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Null metaLabel means no dates set - skip, don't leave blank.
              if (contest.metaLabel != null)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contest.metaLabel!,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.neutral500,
                        ),
                      ),
                      SizedBox(height: AppSpacing.v4),
                      Text(
                        contest.metaValue!,
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: contest.metaUrgent
                              ? AppColors.warning600
                              : AppColors.success600,
                        ),
                      ),
                    ],
                  ),
                )
              else
                const Spacer(),
              // No join/continue flow yet - not wired.
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.blackBase,
                  foregroundColor: AppColors.whiteBase,
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.h16,
                    vertical: AppSpacing.v10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.all09,
                  ),
                  elevation: 0,
                ),
                child: Text(
                  contest.actionLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
