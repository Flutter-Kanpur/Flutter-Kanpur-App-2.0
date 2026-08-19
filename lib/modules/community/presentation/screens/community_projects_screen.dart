import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/router/route_names.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_knp_mobile_app_v2/common_widgets/search_bar.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/presentation/widgets/community_async_views.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/presentation/widgets/project_filter_chips_row.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/presentation/widgets/projects_app_bar.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/presentation/widgets/upload_project_cta_card.dart';
import 'package:flutter_knp_mobile_app_v2/modules/explore/application/explore_providers.dart';
import 'package:flutter_knp_mobile_app_v2/modules/explore/presentation/widgets/community_project_preview_card.dart';
import 'package:flutter_knp_mobile_app_v2/modules/explore/presentation/widgets/community_project_preview_card_skeleton.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_load_more_button.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_primary_button.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/gradiant_background.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Full "Projects" list. Seeds from [communityProjectsPagedProvider];
/// typing/voice/a filter chip switches to [projectSearchProvider] instead.
class CommunityProjectsScreen extends ConsumerWidget {
  const CommunityProjectsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pagedAsync = ref.watch(communityProjectsPagedProvider);
    final searchState = ref.watch(projectSearchProvider);
    final searchController = ref.watch(projectSearchControllerProvider);
    final searchNotifier = ref.read(projectSearchProvider.notifier);
    final noResults =
        searchState.isActive &&
        !searchState.isSearching &&
        searchState.results.isEmpty;
    final noProjectsAtAll =
        !searchState.isActive &&
        (pagedAsync.value?.projects.isEmpty ?? false);

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () =>
                ref.read(communityProjectsPagedProvider.notifier).refresh(),
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                const SliverToBoxAdapter(child: ProjectsAppBar()),
                SliverToBoxAdapter(child: SizedBox(height: AppSpacing.v18)),
                SliverToBoxAdapter(
                  child: CommonSearchBar(
                    controller: searchController,
                    hintText: 'Search for titles...',
                    darkenOnFocus: true,
                    isListening: searchState.isListening,
                    onChanged: searchNotifier.setQuery,
                    onSubmitted: searchNotifier.submit,
                    onMicTap: searchNotifier.toggleListening,
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: AppSpacing.v12)),
                SliverToBoxAdapter(
                  child: ProjectFilterChipsRow(
                    selectedLabel: searchState.query,
                    onSelect: searchNotifier.selectFilter,
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: AppSpacing.v20)),
                if (searchState.isActive) ...[
                  SliverPadding(
                    padding: AppSpacing.horizontal(AppSpacing.h20),
                    sliver: SliverToBoxAdapter(
                      child: Text(
                        'Results for "${searchState.query}"',
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.neutral500,
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: AppSpacing.v16)),
                ],
                // Empty states fill and center in the remaining viewport.
                if (noResults)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Padding(
                      padding: AppSpacing.horizontal(AppSpacing.h20),
                      child: const Center(
                        child: _EmptyProjectsView(title: 'No results found'),
                      ),
                    ),
                  )
                else if (noProjectsAtAll)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Padding(
                      padding: AppSpacing.horizontal(AppSpacing.h20),
                      child: const Center(
                        child: _EmptyProjectsView(
                          title: 'No projects shared yet',
                        ),
                      ),
                    ),
                  )
                else ...[
                  SliverPadding(
                    padding: AppSpacing.horizontal(AppSpacing.h20),
                    sliver: SliverToBoxAdapter(
                      child: searchState.isActive
                          ? _SearchResults(searchState: searchState)
                          : pagedAsync.when(
                              loading: () => const Column(
                                children: [
                                  CommunityProjectPreviewCardSkeleton(),
                                  CommunityProjectPreviewCardSkeleton(),
                                ],
                              ),
                              error: (error, _) => CommunityErrorView(
                                message: 'Could not load projects.',
                                error: error,
                                compact: true,
                                onRetry: () => ref.invalidate(
                                  communityProjectsPagedProvider,
                                ),
                              ),
                              data: (state) => _PagedProjectsList(state: state),
                            ),
                    ),
                  ),
                  // Hidden during search - the empty state has its own
                  // upload button.
                  if (!searchState.isActive) ...[
                    SliverToBoxAdapter(
                      child: SizedBox(height: AppSpacing.v20),
                    ),
                    SliverPadding(
                      padding: AppSpacing.horizontal(AppSpacing.h20),
                      sliver: SliverToBoxAdapter(
                        child: UploadProjectCtaCard(
                          title: 'Upload your project',
                          subtitle:
                              'Upload your project and let the community inspired by your work.',
                          buttonLabel: 'Upload project',
                          onPressed: () =>
                              context.go(RouteNames.communityUploadProject),
                        ),
                      ),
                    ),
                  ],
                  SliverToBoxAdapter(
                    child: SizedBox(height: AppSpacing.v16),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Renders [state.projects] + "Load more"/"View less". Assumes non-empty.
class _PagedProjectsList extends ConsumerWidget {
  const _PagedProjectsList({required this.state});

  final CommunityProjectsPagedState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        for (final project in state.projects)
          Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.v12),
            child: CommunityProjectPreviewCard(project: project),
          ),
        if (state.isLoadingMore) ...const [
          CommunityProjectPreviewCardSkeleton(),
          CommunityProjectPreviewCardSkeleton(),
        ] else if (state.hasMore)
          FkLoadMoreButton(
            label: 'Load more',
            icon: Icons.keyboard_arrow_down_rounded,
            onTap: () =>
                ref.read(communityProjectsPagedProvider.notifier).loadMore(),
          )
        else if (state.projects.length >
            CommunityProjectsPagedNotifier.initialCount)
          FkLoadMoreButton(
            label: 'View less',
            icon: Icons.keyboard_arrow_up_rounded,
            onTap: () =>
                ref.read(communityProjectsPagedProvider.notifier).collapse(),
          ),
      ],
    );
  }
}

/// Search results, or a skeleton while the request is in flight.
class _SearchResults extends StatelessWidget {
  const _SearchResults({required this.searchState});

  final ProjectSearchState searchState;

  @override
  Widget build(BuildContext context) {
    if (searchState.isSearching) {
      return const Column(
        children: [
          CommunityProjectPreviewCardSkeleton(),
          CommunityProjectPreviewCardSkeleton(),
        ],
      );
    }
    return Column(
      children: [
        for (final project in searchState.results)
          Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.v12),
            child: CommunityProjectPreviewCard(project: project),
          ),
      ],
    );
  }
}

/// Empty state for both "no projects" and "no search results".
class _EmptyProjectsView extends StatelessWidget {
  const _EmptyProjectsView({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.v22),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: AppSpacing.v10),
          Text(
            'Community projects will appear here once members start sharing their work.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.neutral500,
            ),
          ),
          SizedBox(height: AppSpacing.v18),
          SizedBox(
            width: 220,
            child: FkPrimaryButton(
              label: 'Upload your project',
              icon: null,
              onPressed: () => context.go(RouteNames.communityUploadProject),
            ),
          ),
        ],
      ),
    );
  }
}
