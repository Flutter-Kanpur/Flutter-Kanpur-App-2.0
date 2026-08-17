import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_skeleton_block.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_skeleton_pulse.dart';

/// Loading placeholder for [CommunityProjectPreviewCard]. Built as plain
/// Container blocks (not an SVG asset) mirroring the supplied skeleton
/// design's layout: a title bar, 3 tech-chip pills, a metadata-row block,
/// and a button-row block.
class CommunityProjectPreviewCardSkeleton extends StatelessWidget {
  const CommunityProjectPreviewCardSkeleton({super.key});

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
              const FkSkeletonBlock(height: 36, radius: AppRadius.radius02),
              SizedBox(height: AppSpacing.v10),
              Row(
                children: [
                  const Expanded(
                    flex: 3,
                    child: FkSkeletonBlock(height: 32, radius: 16),
                  ),
                  SizedBox(width: AppSpacing.h4),
                  const Expanded(
                    flex: 3,
                    child: FkSkeletonBlock(height: 32, radius: 16),
                  ),
                  SizedBox(width: AppSpacing.h4),
                  const Expanded(
                    flex: 2,
                    child: FkSkeletonBlock(height: 32, radius: 16),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.v10),
              const FkSkeletonBlock(height: 57, radius: AppRadius.radius02),
              SizedBox(height: AppSpacing.v10),
              const FkSkeletonBlock(height: 37, radius: AppRadius.radius02),
            ],
          ),
        ),
      ),
    );
  }
}
