import 'package:flutter_knp_mobile_app_v2/modules/explore/data/explore_local_data_source.dart';
import 'package:flutter_knp_mobile_app_v2/modules/explore/data/repositories/explore_repository.dart';
import 'package:flutter_knp_mobile_app_v2/modules/explore/domain/community_project_preview.dart';
import 'package:flutter_knp_mobile_app_v2/modules/explore/domain/core_team_member.dart';
import 'package:flutter_knp_mobile_app_v2/modules/explore/domain/suggested_job.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// heroBannerSlidesProvider is still a synchronous plain Provider - there is
// nothing to await for that sample data yet. Community projects and suggested
// jobs simulate an async fetch (see ExploreLocalDataSource); core team is a
// real Supabase fetch (see ExploreRepository). All three use
// AsyncNotifierProvider - the same pattern the real `communityProjectsProvider`
// uses - with loading/error/data handled via `.when()` in their preview
// sections.

final heroBannerSlidesProvider = Provider<List<Map<String, String?>>>(
  (ref) => ExploreLocalDataSource.fetchHeroBannerSlides(),
);

final exploreRepositoryProvider = Provider<ExploreRepository>(
  (ref) => ExploreRepository(),
);

final exploreCommunityProjectPreviewsProvider =
    AsyncNotifierProvider<
      ExploreCommunityProjectPreviewsNotifier,
      List<CommunityProjectPreview>
    >(ExploreCommunityProjectPreviewsNotifier.new);

class ExploreCommunityProjectPreviewsNotifier
    extends AsyncNotifier<List<CommunityProjectPreview>> {
  @override
  Future<List<CommunityProjectPreview>> build() =>
      ExploreLocalDataSource.fetchCommunityProjectPreviews();
}

/// Paginated core team state - mirrors CommunityProvider's ReplyFeedState/
/// RepliesNotifier shape (page of items + hasMore/isLoadingMore flags) so
/// scroll-triggered pagination in the preview section follows the same
/// pattern as the rest of the app.
class CoreTeamMembersState {
  const CoreTeamMembersState({
    this.members = const [],
    this.hasMore = false,
    this.isLoadingMore = false,
  });

  final List<CoreTeamMember> members;
  final bool hasMore;
  final bool isLoadingMore;

  CoreTeamMembersState copyWith({
    List<CoreTeamMember>? members,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return CoreTeamMembersState(
      members: members ?? this.members,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

final coreTeamMembersProvider =
    AsyncNotifierProvider<CoreTeamMembersNotifier, CoreTeamMembersState>(
      CoreTeamMembersNotifier.new,
    );

class CoreTeamMembersNotifier extends AsyncNotifier<CoreTeamMembersState> {
  static const pageSize = 10;

  ExploreRepository get _repo => ref.read(exploreRepositoryProvider);

  @override
  Future<CoreTeamMembersState> build() => _loadFirstPage();

  Future<CoreTeamMembersState> _loadFirstPage() async {
    // Ask for one extra to detect a next page without a count query.
    final rows = await _repo.fetchCoreTeamMembers(
      limit: pageSize + 1,
      offset: 0,
    );
    final hasMore = rows.length > pageSize;
    return CoreTeamMembersState(
      members: hasMore ? rows.sublist(0, pageSize) : rows,
      hasMore: hasMore,
    );
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(_loadFirstPage);
  }

  /// Appends the next page. No-ops while one is already in flight, at the end
  /// of the list, or before the first page has arrived.
  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasMore || current.isLoadingMore) return;

    state = AsyncData(current.copyWith(isLoadingMore: true));
    try {
      final rows = await _repo.fetchCoreTeamMembers(
        limit: pageSize + 1,
        offset: current.members.length,
      );
      final hasMore = rows.length > pageSize;
      state = AsyncData(
        current.copyWith(
          members: [
            ...current.members,
            ...(hasMore ? rows.sublist(0, pageSize) : rows),
          ],
          hasMore: hasMore,
          isLoadingMore: false,
        ),
      );
    } catch (_) {
      state = AsyncData(current.copyWith(isLoadingMore: false));
    }
  }
}

final suggestedJobsProvider =
    AsyncNotifierProvider<ExploreSuggestedJobsNotifier, List<SuggestedJob>>(
      ExploreSuggestedJobsNotifier.new,
    );

class ExploreSuggestedJobsNotifier extends AsyncNotifier<List<SuggestedJob>> {
  @override
  Future<List<SuggestedJob>> build() =>
      ExploreLocalDataSource.fetchSuggestedJobs();
}
