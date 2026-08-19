import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/router/route_names.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_knp_mobile_app_v2/common_widgets/search_bar.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/presentation/widgets/community_async_views.dart';
import 'package:flutter_knp_mobile_app_v2/modules/explore/application/contest_providers.dart';
import 'package:flutter_knp_mobile_app_v2/modules/explore/domain/contest_preview.dart';
import 'package:flutter_knp_mobile_app_v2/modules/explore/presentation/widgets/contest_filter_chips_row.dart';
import 'package:flutter_knp_mobile_app_v2/modules/explore/presentation/widgets/contest_preview_card.dart';
import 'package:flutter_knp_mobile_app_v2/modules/explore/presentation/widgets/contest_preview_card_skeleton.dart';
import 'package:flutter_knp_mobile_app_v2/modules/explore/presentation/widgets/contests_app_bar.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_load_more_button.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_primary_button.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/gradiant_background.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Browse-all "Contests" list. Seeds from [contestsPagedProvider];
/// switches to [contestSearchProvider] instead.
class ContestsScreen extends ConsumerWidget {
  const ContestsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pagedAsync = ref.watch(contestsPagedProvider);
    final searchState = ref.watch(contestSearchProvider);
    final searchController = ref.watch(contestSearchControllerProvider);
    final searchNotifier = ref.read(contestSearchProvider.notifier);
    final noResults =
        searchState.isActive &&
        !searchState.isSearching &&
        searchState.results.isEmpty;
    final noContestsAtAll =
        !searchState.isActive && (pagedAsync.value?.contests.isEmpty ?? false);

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () =>
                ref.read(contestsPagedProvider.notifier).refresh(),
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                const SliverToBoxAdapter(child: ContestsAppBar()),
                SliverToBoxAdapter(child: SizedBox(height: AppSpacing.v18)),
                SliverToBoxAdapter(
                  child: CommonSearchBar(
                    controller: searchController,
                    hintText: 'Search for contests...',
                    onChanged: searchNotifier.setQuery,
                    onSubmitted: searchNotifier.submit,
                    onMicTap: searchNotifier.toggleListening,
                    darkenOnFocus: true,
                    isListening: searchState.isListening,
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: AppSpacing.v12)),
                SliverToBoxAdapter(
                  child: ContestFilterChipsRow(
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
                        child: _EmptyContestsView(title: 'No results found'),
                      ),
                    ),
                  )
                else if (noContestsAtAll)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Padding(
                      padding: AppSpacing.horizontal(AppSpacing.h20),
                      child: const Center(
                        child: _EmptyContestsView(
                          title: 'No contests available',
                        ),
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: AppSpacing.horizontal(AppSpacing.h20),
                    sliver: SliverToBoxAdapter(
                      child: searchState.isActive
                          ? _ContestList(
                              contests: searchState.results,
                              isSearching: searchState.isSearching,
                            )
                          : pagedAsync.when(
                              loading: () => const Column(
                                children: [
                                  ContestPreviewCardSkeleton(),
                                  ContestPreviewCardSkeleton(),
                                ],
                              ),
                              error: (error, _) => CommunityErrorView(
                                message: 'Could not load contests.',
                                error: error,
                                compact: true,
                                onRetry: () =>
                                    ref.invalidate(contestsPagedProvider),
                              ),
                              data: (state) =>
                                  _PagedContestList(state: state),
                            ),
                    ),
                  ),
                SliverToBoxAdapter(child: SizedBox(height: AppSpacing.v16)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Search results, or a skeleton while searching. No load-more affordance.
class _ContestList extends StatelessWidget {
  const _ContestList({required this.contests, required this.isSearching});

  final List<ContestPreview> contests;
  final bool isSearching;

  @override
  Widget build(BuildContext context) {
    if (isSearching) {
      return const Column(
        children: [ContestPreviewCardSkeleton(), ContestPreviewCardSkeleton()],
      );
    }
    return Column(
      children: [
        for (final contest in contests)
          Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.v12),
            child: ContestPreviewCard(contest: contest),
          ),
      ],
    );
  }
}

/// Renders [state.contests] + "Load more"/"View less". Assumes non-empty.
class _PagedContestList extends ConsumerWidget {
  const _PagedContestList({required this.state});

  final ContestsPagedState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        for (final contest in state.contests)
          Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.v12),
            child: ContestPreviewCard(contest: contest),
          ),
        if (state.hasMore)
          FkLoadMoreButton(
            label: 'Load more',
            icon: Icons.keyboard_arrow_down_rounded,
            onTap: () => ref.read(contestsPagedProvider.notifier).loadMore(),
          )
        else if (state.contests.length > ContestsPagedNotifier.initialCount)
          FkLoadMoreButton(
            label: 'View less',
            icon: Icons.keyboard_arrow_up_rounded,
            onTap: () => ref.read(contestsPagedProvider.notifier).collapse(),
          ),
      ],
    );
  }
}

/// Empty state for both "no contests" and "no search results".
class _EmptyContestsView extends StatelessWidget {
  const _EmptyContestsView({required this.title});

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
            'New contests will appear here once announced.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.neutral500,
            ),
          ),
          SizedBox(height: AppSpacing.v18),
          SizedBox(
            width: 220,
            child: FkPrimaryButton(
              label: "Solve today's problem",
              icon: null,
              onPressed: () => context.push(RouteNames.problemOfDay),
            ),
          ),
        ],
      ),
    );
  }
}
