import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_knp_mobile_app_v2/modules/auth/application/auth_session_provider.dart';
import 'package:flutter_knp_mobile_app_v2/modules/leaderboard/data/repositories/leaderboard_repository.dart';
import 'package:flutter_knp_mobile_app_v2/modules/leaderboard/domain/leaderboard_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final leaderboardRepositoryProvider = Provider<LeaderboardRepository>(
  (ref) => LeaderboardRepository(),
);

/// Latest leaderboard, paged for infinite scroll. `autoDispose` so reopening
/// shows a newly published snapshot; no automatic retry - the error view has
/// "Try again". Pull-to-refresh rebuilds from page 1.
final leaderboardProvider =
    AsyncNotifierProvider.autoDispose<LeaderboardNotifier, Leaderboard>(
      LeaderboardNotifier.new,
      retry: (_, _) => null,
    );

/// Same paging shape as `QuestionFeedNotifier` (community_provider.dart).
class LeaderboardNotifier extends AsyncNotifier<Leaderboard> {
  static const pageSize = 20;

  LeaderboardRepository get _repo => ref.read(leaderboardRepositoryProvider);

  @override
  Future<Leaderboard> build() async {
    // Resolved once per build; every later page reuses this id.
    final snapshotId = await _repo.fetchLatestSnapshotId();
    if (snapshotId == null) return Leaderboard.empty;

    final page = await _fetchPage(snapshotId, offset: 0);
    return Leaderboard(
      snapshotId: snapshotId,
      entries: page.entries,
      hasMore: page.hasMore,
    );
  }

  /// Appends the next page of the same snapshot. No-ops before the first page
  /// arrives, at the end of the list, or while a page is already in flight
  /// (scroll notifications fire it repeatedly).
  Future<void> loadMore() async {
    final current = state.value;
    final snapshotId = current?.snapshotId;
    if (current == null ||
        snapshotId == null ||
        !current.hasMore ||
        current.isLoadingMore) {
      return;
    }

    final loading = current.copyWith(
      isLoadingMore: true,
      clearLoadMoreError: true,
    );
    state = AsyncData(loading);

    // Drop this page's result if, while it was in flight, the screen was
    // left (autoDispose) or pull-to-refresh replaced the board - otherwise
    // the old list plus this page would overwrite the fresh page 1.
    // (`isLoading` covers a refresh still running, which keeps the old value.)
    bool superseded() =>
        !ref.mounted || state.isLoading || !identical(state.value, loading);

    try {
      final page = await _fetchPage(
        snapshotId,
        offset: current.entries.length,
      );
      if (superseded()) return;
      state = AsyncData(
        current.copyWith(
          entries: [...current.entries, ...page.entries],
          hasMore: page.hasMore,
          isLoadingMore: false,
          clearLoadMoreError: true,
        ),
      );
    } catch (e) {
      if (superseded()) return;
      // Keep what's loaded; the footer shows an inline retry.
      state = AsyncData(
        current.copyWith(isLoadingMore: false, loadMoreError: e),
      );
    }
  }

  Future<LeaderboardPage> _fetchPage(String snapshotId, {required int offset}) {
    return _repo.fetchEntriesPage(
      snapshotId: snapshotId,
      offset: offset,
      limit: pageSize,
      fallbackName: 'leaderboard.member'.tr(),
    );
  }
}

/// Signed-in user's id, for highlighting their own leaderboard row.
final currentUserIdProvider = FutureProvider.autoDispose<String?>(
  (ref) => ref.watch(authUserIdProvider.future),
);

/// Signed-in user's standing; refetches on account switch.
final myRankProvider = FutureProvider.autoDispose<MyRank>((ref) async {
  final userId = await ref.watch(authUserIdProvider.future);
  return ref.watch(leaderboardRepositoryProvider).fetchMyRank(userId);
}, retry: (_, _) => null);
