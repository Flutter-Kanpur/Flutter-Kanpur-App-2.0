import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_skeleton_block.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_skeleton_pulse.dart';

/// Loading placeholder for [CoreTeamPreviewSection]: a horizontal row of
/// circular avatar + name-line pairs, matching the real list's shape.
class CoreTeamMemberSkeleton extends StatelessWidget {
  const CoreTeamMemberSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: FkSkeletonPulse(
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: 5,
          separatorBuilder: (_, __) => SizedBox(width: AppSpacing.h16),
          itemBuilder: (_, __) => SizedBox(
            width: 64,
            child: Column(
              children: [
                const FkSkeletonBlock(width: 56, height: 56, radius: 28),
                SizedBox(height: AppSpacing.v6),
                const FkSkeletonBlock(height: 12, radius: 4),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
