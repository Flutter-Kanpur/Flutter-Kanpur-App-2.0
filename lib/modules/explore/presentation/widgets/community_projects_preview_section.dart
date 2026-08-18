import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/presentation/widgets/community_async_views.dart';
import 'package:flutter_knp_mobile_app_v2/modules/explore/application/explore_providers.dart';
import 'package:flutter_knp_mobile_app_v2/modules/explore/presentation/widgets/community_project_preview_card.dart';
import 'package:flutter_knp_mobile_app_v2/modules/explore/presentation/widgets/community_project_preview_card_skeleton.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_section_title.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Watches [exploreCommunityProjectPreviewsProvider] directly (rather than
/// receiving a list prop) since that provider is a real Supabase fetch (see
/// ExploreRepository.fetchLatestCommunityProjects) - loading/error/data all
/// need to be handled here.
class CommunityProjectsPreviewSection extends ConsumerWidget {
  const CommunityProjectsPreviewSection({
    super.key,
    required this.onViewAllTap,
  });

  final VoidCallback onViewAllTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsAsync = ref.watch(exploreCommunityProjectPreviewsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FkSectionTitle(
          title: 'Community projects',
          actionLabel: 'View all',
          onActionTap: onViewAllTap,
        ),
        projectsAsync.when(
          loading: () => const Column(
            children: [
              CommunityProjectPreviewCardSkeleton(),
              CommunityProjectPreviewCardSkeleton(),
            ],
          ),
          error: (error, _) => CommunityErrorView(
            message: 'Could not load community projects.',
            error: error,
            compact: true,
            onRetry: () =>
                ref.invalidate(exploreCommunityProjectPreviewsProvider),
          ),
          data: (projects) {
            if (projects.isEmpty) {
              // Matches CoreTeamPreviewSection's empty state: SizedBox +
              // width:infinity so CommunityEmptyView centers across the full
              // section width instead of shrink-wrapping (the outer Column is
              // left-aligned).
              return const SizedBox(
                width: double.infinity,
                child: CommunityEmptyView(
                  icon: Icons.folder_open_outlined,
                  message: 'No community projects to show yet.',
                ),
              );
            }
            return Column(
              children: [
                for (final project in projects)
                  Padding(
                    padding: EdgeInsets.only(bottom: AppSpacing.v12),
                    child: CommunityProjectPreviewCard(project: project),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
