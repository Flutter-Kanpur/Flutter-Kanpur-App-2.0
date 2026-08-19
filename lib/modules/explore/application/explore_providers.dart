import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_knp_mobile_app_v2/modules/explore/data/explore_local_data_source.dart';
import 'package:flutter_knp_mobile_app_v2/modules/explore/data/repositories/explore_repository.dart';
import 'package:flutter_knp_mobile_app_v2/modules/explore/domain/community_project_detail.dart';
import 'package:flutter_knp_mobile_app_v2/modules/explore/domain/community_project_preview.dart';
import 'package:flutter_knp_mobile_app_v2/modules/explore/domain/core_team_member.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

// heroBannerSlidesProvider is still a synchronous plain Provider - there is
// nothing to await for that sample data yet. Core team and community
// projects are both real Supabase fetches (see ExploreRepository), using
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
      ref.read(exploreRepositoryProvider).fetchLatestCommunityProjects();
}

/// Paginated view of the same `projects` feed, for the full "Projects"
/// screen. Seeds from whatever [exploreCommunityProjectPreviewsProvider] has
/// already loaded (the Explore dashboard's 2 newest projects) instead of
/// re-fetching them, then pages in the rest underneath - same
/// hasMore/isLoadingMore shape as [CoreTeamMembersState].
class CommunityProjectsPagedState {
  const CommunityProjectsPagedState({
    this.projects = const [],
    this.hasMore = false,
    this.isLoadingMore = false,
  });

  final List<CommunityProjectPreview> projects;
  final bool hasMore;
  final bool isLoadingMore;

  CommunityProjectsPagedState copyWith({
    List<CommunityProjectPreview>? projects,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return CommunityProjectsPagedState(
      projects: projects ?? this.projects,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

final communityProjectsPagedProvider =
    AsyncNotifierProvider<
      CommunityProjectsPagedNotifier,
      CommunityProjectsPagedState
    >(CommunityProjectsPagedNotifier.new);

class CommunityProjectsPagedNotifier
    extends AsyncNotifier<CommunityProjectsPagedState> {
  /// Matches the Explore dashboard preview's own count - the design only
  /// shows these 2 before a "Load more" tap.
  static const initialCount = 2;
  static const pageSize = 10;

  ExploreRepository get _repo => ref.read(exploreRepositoryProvider);

  @override
  Future<CommunityProjectsPagedState> build() => _load();

  Future<CommunityProjectsPagedState> _load() async {
    final seed = ref.read(exploreCommunityProjectPreviewsProvider).value;
    if (seed != null && seed.isNotEmpty) {
      // Reuse what the Explore dashboard already fetched instead of
      // re-querying the same first rows. Whether there's anything beyond
      // these isn't known yet - "Load more" finds out on tap.
      return CommunityProjectsPagedState(projects: seed, hasMore: true);
    }
    // No dashboard state to seed from (e.g. a deep link straight into this
    // screen) - fetch the first page directly, same count as the preview.
    final rows = await _repo.fetchLatestCommunityProjects(
      limit: initialCount,
    );
    return CommunityProjectsPagedState(
      projects: rows,
      hasMore: rows.length == initialCount,
    );
  }

  /// Pull-to-refresh. Re-fetches however many projects are already loaded
  /// (not just [initialCount]) so a "Load more" tap the user already made
  /// isn't undone by refreshing - only the data itself is refreshed, not the
  /// pagination progress. Assigns the result directly so the current list
  /// stays on screen while reloading, same as QuestionFeedNotifier.refresh.
  Future<void> refresh() async {
    final current = state.value;
    if (current == null || current.isLoadingMore) return;

    final count = current.projects.isEmpty ? initialCount : current.projects.length;
    state = await AsyncValue.guard(() async {
      final rows = await _repo.fetchLatestCommunityProjects(limit: count + 1);
      final hasMore = rows.length > count;
      return CommunityProjectsPagedState(
        projects: hasMore ? rows.sublist(0, count) : rows,
        hasMore: hasMore,
      );
    });
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasMore || current.isLoadingMore) return;

    state = AsyncData(current.copyWith(isLoadingMore: true));
    try {
      final rows = await _repo.fetchLatestCommunityProjects(
        limit: pageSize + 1,
        offset: current.projects.length,
      );
      final hasMore = rows.length > pageSize;
      state = AsyncData(
        current.copyWith(
          projects: [
            ...current.projects,
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

  /// "View less" - once every page has been loaded (`hasMore == false`) and
  /// the list has grown past [initialCount], this collapses it back down to
  /// the first [initialCount] rows already in memory (no re-fetch) and
  /// re-opens `hasMore` so a "Load more" tap resumes pagination from there.
  void collapse() {
    final current = state.value;
    if (current == null || current.projects.length <= initialCount) return;

    state = AsyncData(
      current.copyWith(
        projects: current.projects.take(initialCount).toList(),
        hasMore: true,
      ),
    );
  }
}

/// The `TextEditingController` backing the Projects search field. Owned
/// here (not a local `State` field) so the whole screen can stay a plain
/// `ConsumerWidget` with every bit of state - including this controller and
/// the voice-search listening flag - managed through Riverpod. `autoDispose`
/// because a `TextEditingController` must be disposed like any other
/// controller; the screen's own `ref.watch` of it is what keeps it alive
/// for exactly as long as the screen is mounted.
final projectSearchControllerProvider =
    Provider.autoDispose<TextEditingController>((ref) {
      final controller = TextEditingController();
      ref.onDispose(controller.dispose);
      return controller;
    });

/// The `SpeechToText` instance for voice search. Deliberately *not*
/// `autoDispose` - nothing keeps a persistent `ref.watch` on it (only
/// `ProjectSearchNotifier.toggleListening` reads it on demand), and an
/// unwatched `autoDispose` provider would be torn down and recreated on
/// almost every read, losing the plugin's own `initialize()` cache.
final _speechToTextProvider = Provider<stt.SpeechToText>((ref) {
  final speech = stt.SpeechToText();
  ref.onDispose(speech.cancel);
  return speech;
});

/// Search over the full `projects` table (title `ilike`), not just whatever
/// [communityProjectsPagedProvider] happens to have paged in - see
/// [ProjectSearchNotifier.setQuery].
class ProjectSearchState {
  const ProjectSearchState({
    this.query = '',
    this.results = const [],
    this.isSearching = false,
    this.isListening = false,
  });

  final String query;
  final List<CommunityProjectPreview> results;

  /// True once the debounced backend request has actually been sent and is
  /// still in flight - `results` is left untouched (still whatever it was
  /// before) until this flips back to false, so the UI shows a skeleton
  /// instead of a stale or locally-guessed list under the live query label.
  final bool isSearching;

  /// True while a voice-search session is actively listening.
  final bool isListening;

  bool get isActive => query.isNotEmpty;

  ProjectSearchState copyWith({
    String? query,
    List<CommunityProjectPreview>? results,
    bool? isSearching,
    bool? isListening,
  }) {
    return ProjectSearchState(
      query: query ?? this.query,
      results: results ?? this.results,
      isSearching: isSearching ?? this.isSearching,
      isListening: isListening ?? this.isListening,
    );
  }
}

final projectSearchProvider =
    NotifierProvider<ProjectSearchNotifier, ProjectSearchState>(
      ProjectSearchNotifier.new,
    );

class ProjectSearchNotifier extends Notifier<ProjectSearchState> {
  static const _debounceDuration = Duration(milliseconds: 400);

  Timer? _debounce;

  /// Guards against an in-flight request finishing after a newer one has
  /// already started (or the query was cleared) and clobbering it.
  int _requestId = 0;

  ExploreRepository get _repo => ref.read(exploreRepositoryProvider);
  TextEditingController get _controller =>
      ref.read(projectSearchControllerProvider);
  stt.SpeechToText get _speech => ref.read(_speechToTextProvider);

  @override
  ProjectSearchState build() {
    ref.onDispose(() => _debounce?.cancel());
    return const ProjectSearchState();
  }

  /// Called on every keystroke. Sets `query` and `isSearching` immediately
  /// (so the "Results for" label is always accurate the instant it changes)
  /// but deliberately does *not* touch `results` here - it stays whatever it
  /// last was, hidden behind the loading state, until the debounced `ilike`
  /// request actually resolves.
  ///
  /// An earlier version filled `results` with a client-side filter of
  /// whatever was already loaded, as an instant preview while the debounce
  /// settled. That's what caused the bug: `query` had already moved on to
  /// the newly-typed text while `results` still reflected that local-only
  /// guess (not a real search for it) - the two could visibly disagree.
  /// Showing a skeleton until the real results land avoids that entirely.
  void setQuery(String query) {
    _debounce?.cancel();
    final trimmed = query.trim();

    if (trimmed.isEmpty) {
      _requestId++;
      // copyWith, not a fresh ProjectSearchState() - preserves isListening,
      // e.g. when this is called mid-voice-session with an empty result.
      state = state.copyWith(query: '', results: const [], isSearching: false);
      return;
    }

    state = state.copyWith(
      query: trimmed,
      results: const [],
      isSearching: true,
    );

    final requestId = ++_requestId;
    _debounce = Timer(_debounceDuration, () => _runSearch(trimmed, requestId));
  }

  /// Skips the debounce and searches immediately - used for a keyboard
  /// submit and for filter-chip taps, both deliberate one-shot actions
  /// rather than continuous typing.
  Future<void> submit(String query) async {
    _debounce?.cancel();
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      _requestId++;
      state = state.copyWith(query: '', results: const [], isSearching: false);
      return;
    }
    final requestId = ++_requestId;
    state = state.copyWith(
      query: trimmed,
      results: const [],
      isSearching: true,
    );
    await _runSearch(trimmed, requestId);
  }

  /// Filter chip tap - fills the search box with that label and searches on
  /// it, exactly as if it had been typed; tapping the already-selected chip
  /// clears it. Nothing else about it is special-cased. Owning the
  /// controller here (rather than the widget) is what lets a chip tap update
  /// the visible text without the screen needing any local state of its own.
  void selectFilter(String? label) {
    if (label == null) {
      _controller.clear();
      clear();
    } else {
      _controller.text = label;
      submit(label);
    }
  }

  /// Toggles a voice-search session. `SpeechToText.initialize()` is
  /// idempotent (cached after the first successful call), so this is cheap
  /// to call every time rather than tracking init state separately.
  Future<void> toggleListening() async {
    if (state.isListening) {
      await _speech.stop();
      state = state.copyWith(isListening: false);
      return;
    }

    final available = await _speech.initialize(
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') {
          state = state.copyWith(isListening: false);
        }
      },
      onError: (_) => state = state.copyWith(isListening: false),
    );
    if (!available) return;

    state = state.copyWith(isListening: true);
    await _speech.listen(
      onResult: (result) {
        _controller.value = TextEditingValue(
          text: result.recognizedWords,
          selection: TextSelection.collapsed(
            offset: result.recognizedWords.length,
          ),
        );
        setQuery(result.recognizedWords);
      },
      listenOptions: stt.SpeechListenOptions(
        listenMode: stt.ListenMode.search,
        partialResults: true,
        cancelOnError: true,
      ),
    );
  }

  Future<void> _runSearch(String query, int requestId) async {
    if (requestId != _requestId) return;
    try {
      final rows = await _repo.searchProjects(query);
      if (requestId != _requestId) return; // superseded by a newer search
      state = state.copyWith(query: query, results: rows, isSearching: false);
    } catch (_) {
      if (requestId != _requestId) return;
      state = state.copyWith(isSearching: false);
    }
  }

  void clear() {
    _debounce?.cancel();
    _requestId++;
    state = state.copyWith(query: '', results: const [], isSearching: false);
  }
}

/// Single project by id, for the project detail screen.
final projectDetailProvider =
    AsyncNotifierProvider.family<
      ProjectDetailNotifier,
      CommunityProjectDetail,
      String
    >(ProjectDetailNotifier.new);

class ProjectDetailNotifier extends AsyncNotifier<CommunityProjectDetail> {
  ProjectDetailNotifier(this.projectId);

  /// Riverpod 3 hands a family's argument to the notifier constructor.
  final String projectId;

  @override
  Future<CommunityProjectDetail> build() =>
      ref.read(exploreRepositoryProvider).fetchProjectById(projectId);
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
