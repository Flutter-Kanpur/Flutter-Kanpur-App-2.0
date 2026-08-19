import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/router/route_names.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_borders.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_knp_mobile_app_v2/common_widgets/search_bar.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/presentation/widgets/community_async_views.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/presentation/widgets/projects_app_bar.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/presentation/widgets/upload_project_cta_card.dart';
import 'package:flutter_knp_mobile_app_v2/modules/explore/application/explore_providers.dart';
import 'package:flutter_knp_mobile_app_v2/modules/explore/presentation/widgets/community_project_preview_card.dart';
import 'package:flutter_knp_mobile_app_v2/modules/explore/presentation/widgets/community_project_preview_card_skeleton.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/border_shadow_container.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_primary_button.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/gradiant_background.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Built on the same model/widgets as the Explore dashboard's Community
/// Projects preview ([CommunityProjectPreview]/[CommunityProjectPreviewCard])
/// rather than the older [CommunityProjectCard] - that card has no like
/// heart, author/date, or github/figma/live links, which this design needs.
///
/// [communityProjectsPagedProvider] seeds itself from whatever
/// [exploreCommunityProjectPreviewsProvider] already loaded on the Explore
/// dashboard (the newest 2 projects) instead of re-fetching them, and shows
/// just those 2 until "Load more" is tapped - see explore_providers.dart.
///
/// Typing (or a filter chip, or voice) drives [projectSearchProvider]
/// instead - see that provider for the debounced `ilike` search itself.
/// While it's active, it fully replaces the paginated list below the search
/// bar/chips.
///
/// A plain [ConsumerWidget], not a `ConsumerStatefulWidget` - the search
/// text field's [TextEditingController] and the voice-search listening flag
/// both live on [ProjectSearchNotifier] (`projectSearchControllerProvider`/
/// `ProjectSearchState.isListening`) instead of local `State` fields, so
/// every bit of this screen's state is Riverpod-managed, not a mix of
/// `setState` and providers.
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
    // Only meaningful outside of search - once loaded (`.value` is null
    // while the very first fetch is still in flight, so this stays false
    // during that skeleton window too).
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
                  child: _FilterChipsRow(
                    selectedLabel: searchState.query,
                    onSelect: searchNotifier.selectFilter,
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: AppSpacing.v20)),
                // Shows the query the current results (or lack of them)
                // actually came from - present in both the populated and
                // empty search states, absent outside of search entirely.
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
                // Both empty states fill whatever's left of the viewport
                // instead of sitting content-height-tall at the top, and
                // center within that - everything else keeps its normal
                // scrolling flow.
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
                              data: (state) =>
                                  _PagedProjectsList(state: state),
                            ),
                    ),
                  ),
                  // Hidden while a search is active - the empty-results state
                  // already has its own "Upload your project" button, and a
                  // populated search shouldn't be nudging an unrelated upload.
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

/// Only ever built for a non-empty [state.projects] - the empty case is
/// handled a level up in CommunityProjectsScreen.build (the `noProjectsAtAll`
/// branch), which needs to fill the remaining viewport rather than sit
/// inline here.
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
        // "Load more" swaps for skeleton cards the instant it's tapped,
        // rather than spinning in place - the skeletons themselves are the
        // loading indicator, until the real cards replace them.
        if (state.isLoadingMore) ...const [
          CommunityProjectPreviewCardSkeleton(),
          CommunityProjectPreviewCardSkeleton(),
        ] else if (state.hasMore)
          _LoadMoreButton(
            label: 'Load more',
            icon: Icons.keyboard_arrow_down_rounded,
            onTap: () =>
                ref.read(communityProjectsPagedProvider.notifier).loadMore(),
          )
        else if (state.projects.length >
            CommunityProjectsPagedNotifier.initialCount)
          _LoadMoreButton(
            label: 'View less',
            icon: Icons.keyboard_arrow_up_rounded,
            onTap: () =>
                ref.read(communityProjectsPagedProvider.notifier).collapse(),
          ),
      ],
    );
  }
}

/// Replaces [_PagedProjectsList] while a search (typed, voice, or filter
/// chip) is active and has results. [ProjectSearchState.isSearching] means
/// the debounced backend request is actually in flight (Figma
/// `iPhone 16 - 310.svg`); the zero-results case (`- 307.svg`) is handled a
/// level up in CommunityProjectsScreen.build (the `noResults` branch) for
/// the same fill-remaining-viewport reason [_PagedProjectsList] does.
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

/// Shared shape behind both empty states - Figma `iPhone 16 - 306.svg`'s
/// "no projects at all" ("No projects shared yet") and `- 307.svg`'s
/// zero-results search ("No results found"). Same subtitle/button copy in
/// both, only the title differs - the Figma reuses the same subtitle
/// verbatim rather than writing search-specific copy. `mainAxisSize.min` so
/// the `Center` this is wrapped in (see CommunityProjectsScreen.build)
/// actually centers it instead of the Column itself stretching to fill the
/// space.
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

/// Matches the Figma's "Filters ▾ / Mobile app / Flutter / UI/UX / DSA" row.
/// Same visual pattern as HomeFilterTabs (InnerShadowContainer + FilterChip)
/// built locally instead of reusing that widget directly, since it's wired
/// to Home's own filter state. Selecting a chip fills the search box with
/// its label and searches on that - see [ProjectSearchNotifier.selectFilter].
/// The "Filters" dropdown (index 0) has no sheet built yet, so it stays a
/// no-op.
///
/// Outer padding matches [AppSpacing.h20] like every other component on this
/// screen (header/cards/upload card) so the first chip lines up with them,
/// instead of AppSpacing.horizontal used elsewhere just for the row itself.
class _FilterChipsRow extends StatelessWidget {
  const _FilterChipsRow({required this.selectedLabel, required this.onSelect});

  final String selectedLabel;
  final ValueChanged<String?> onSelect;

  static const _labels = ['Filters', 'Mobile app', 'Flutter', 'UI/UX', 'DSA'];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      // Explicit (matches the default) - chips past the viewport edge are
      // clipped/hidden and only drawn once a horizontal drag scrolls them in.
      clipBehavior: Clip.hardEdge,
      padding: AppSpacing.horizontal(AppSpacing.h20),
      child: Row(
        children: List.generate(_labels.length, (index) {
          final isFilterChip = index != 0;
          final label = _labels[index];
          final isSelected =
              isFilterChip &&
              selectedLabel.toLowerCase() == label.toLowerCase();

          return Padding(
            padding: EdgeInsets.only(right: AppSpacing.h8),
            child: InnerShadowContainer(
              borderColor: isSelected
                  ? AppColors.primary500
                  : AppColors.neutral100,
              shadowColor: AppColors.primary500.withValues(alpha: 0.05),
              isShadowBottomLeft: true,
              isShadowBottomRight: true,
              isShadowTopLeft: true,
              isShadowTopRight: true,
              borderRadius: 12,
              child: Theme(
                data: Theme.of(context).copyWith(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: FilterChip(
                    showCheckmark: false,
                    avatar: index == 0
                        ? const Icon(
                            Icons.filter_list_rounded,
                            color: AppColors.blackBase,
                          )
                        : null,
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          label,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: AppColors.blackBase,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                        if (isSelected) ...[
                          SizedBox(width: AppSpacing.h4),
                          const Icon(
                            Icons.close,
                            size: 16,
                            color: AppColors.blackBase,
                          ),
                        ],
                      ],
                    ),
                    selected: isSelected,
                    onSelected: (_) {
                      if (!isFilterChip) return;
                      onSelect(isSelected ? null : label);
                    },
                    backgroundColor: AppColors.whiteBase,
                    selectedColor: AppColors.whiteBase,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.all02,
                      side: const BorderSide(color: Colors.transparent),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

/// Pill button used both to page in more projects ("Load more") and, once
/// every page has loaded, to collapse back down to the first 2 ("View
/// less") - same shell, just a different label/icon/action.
class _LoadMoreButton extends StatelessWidget {
  const _LoadMoreButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: AppSpacing.v6),
      child: Center(
        child: Material(
          color: AppColors.whiteBase,
          borderRadius: AppRadius.all09,
          child: InkWell(
            onTap: onTap,
            borderRadius: AppRadius.all09,
            child: Container(
              padding: AppSpacing.symmetric(
                horizontal: AppSpacing.h18,
                vertical: AppSpacing.v10,
              ),
              decoration: BoxDecoration(
                border: AppBorders.allSecondary(),
                borderRadius: AppRadius.all09,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 18, color: AppColors.blackBase),
                  SizedBox(width: AppSpacing.h4),
                  Text(
                    label,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: AppColors.blackBase),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
