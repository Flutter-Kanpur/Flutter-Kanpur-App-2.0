import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_knp_mobile_app_v2/modules/explore/data/explore_local_data_source.dart';
import 'package:flutter_knp_mobile_app_v2/modules/explore/data/repositories/explore_repository.dart';
import 'package:flutter_knp_mobile_app_v2/modules/explore/domain/community_project_detail.dart';
import 'package:flutter_knp_mobile_app_v2/modules/explore/domain/community_project_preview.dart';
import 'package:flutter_knp_mobile_app_v2/modules/explore/domain/core_team_member.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

// heroBannerSlidesProvider stays a plain Provider (sample data, nothing to
// await). Everything else here is a real Supabase fetch.

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

/// Paginated projects list for the full "Projects" screen. Seeds from
/// [exploreCommunityProjectPreviewsProvider] instead of re-fetching.
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
  /// Matches the Explore dashboard preview's own count.
  static const initialCount = 2;
  static const pageSize = 10;

  ExploreRepository get _repo => ref.read(exploreRepositoryProvider);

  @override
  Future<CommunityProjectsPagedState> build() => _load();

  Future<CommunityProjectsPagedState> _load() async {
    final seed = ref.read(exploreCommunityProjectPreviewsProvider).value;
    if (seed != null && seed.isNotEmpty) {
      // Reuse what the dashboard already fetched instead of re-querying.
      return CommunityProjectsPagedState(projects: seed, hasMore: true);
    }
    // No seed available (e.g. a deep link) - fetch the first page directly.
    final rows = await _repo.fetchLatestCommunityProjects(
      limit: initialCount,
    );
    return CommunityProjectsPagedState(
      projects: rows,
      hasMore: rows.length == initialCount,
    );
  }

  /// Pull-to-refresh - re-fetches however many projects are already loaded,
  /// so pagination progress isn't lost.
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

  /// "View less" - collapses back down to [initialCount] rows already in
  /// memory and reopens `hasMore`.
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

/// `TextEditingController` for the Projects search field, owned here so
/// the screen can stay a plain `ConsumerWidget`. `autoDispose` disposes it
/// when the screen stops watching it.
final projectSearchControllerProvider =
    Provider.autoDispose<TextEditingController>((ref) {
      final controller = TextEditingController();
      ref.onDispose(controller.dispose);
      return controller;
    });

/// `SpeechToText` instance for voice search. Not `autoDispose` - nothing
/// keeps a persistent watch on it, so it would be recreated on every read.
final _speechToTextProvider = Provider<stt.SpeechToText>((ref) {
  final speech = stt.SpeechToText();
  ref.onDispose(speech.cancel);
  return speech;
});

/// Search state over the full `projects` table (title `ilike`).
class ProjectSearchState {
  const ProjectSearchState({
    this.query = '',
    this.results = const [],
    this.isSearching = false,
    this.isListening = false,
  });

  final String query;
  final List<CommunityProjectPreview> results;

  /// True while the debounced request is in flight; `results` is left
  /// untouched until it resolves.
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

  /// Guards a stale in-flight request from clobbering a newer one.
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

  /// Sets `query` immediately; `results` waits for the debounced request.
  void setQuery(String query) {
    _debounce?.cancel();
    final trimmed = query.trim();

    if (trimmed.isEmpty) {
      _requestId++;
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

  /// Skips the debounce - for keyboard submit and filter-chip taps.
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

  /// Fills the search box with the chip's label and searches; tapping the
  /// selected chip again clears it.
  void selectFilter(String? label) {
    if (label == null) {
      _controller.clear();
      clear();
    } else {
      _controller.text = label;
      submit(label);
    }
  }

  /// Toggles a voice-search session. `initialize()` is idempotent, so it's
  /// safe to call every time.
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

  final String projectId;

  @override
  Future<CommunityProjectDetail> build() =>
      ref.read(exploreRepositoryProvider).fetchProjectById(projectId);
}

/// Paginated core team state, same shape as CommunityProvider's
/// ReplyFeedState.
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

  /// Appends the next page; no-ops if already loading or at the end.
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
