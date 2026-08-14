import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_skeleton_block.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_skeleton_pulse.dart';

/// Loading placeholder for [SuggestedJobPreviewCard]. Built as plain
/// Container blocks (same approach and palette as
/// CommunityProjectPreviewCardSkeleton, for a consistent skeleton look across
/// Explore) mirroring the card's own layout: a title bar with a bookmark-badge
/// placeholder, 3 tag-pill placeholders, and a company logo + text line.
class SuggestedJobPreviewCardSkeleton extends StatelessWidget {
  const SuggestedJobPreviewCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.v12),
      child: FkSkeletonPulse(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.h16,
            vertical: AppSpacing.v16,
          ),
          decoration: BoxDecoration(
            color: AppColors.primary50,
            borderRadius: AppRadius.all05,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(child: FkSkeletonBlock(height: 24, radius: 8)),
                  SizedBox(width: AppSpacing.h12),
                  const FkSkeletonBlock(width: 62, height: 24, radius: 12),
                ],
              ),
              SizedBox(height: AppSpacing.v12),
              Row(
                children: [
                  const Expanded(
                    flex: 3,
                    child: FkSkeletonBlock(height: 31, radius: 16),
                  ),
                  SizedBox(width: AppSpacing.h8),
                  const Expanded(
                    flex: 3,
                    child: FkSkeletonBlock(height: 31, radius: 16),
                  ),
                  SizedBox(width: AppSpacing.h8),
                  const Expanded(
                    flex: 2,
                    child: FkSkeletonBlock(height: 31, radius: 16),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.v12),
              Row(
                children: [
                  const FkSkeletonBlock(width: 32, height: 32, radius: 8),
                  SizedBox(width: AppSpacing.h8),
                  const Expanded(child: FkSkeletonBlock(height: 16, radius: 4)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
