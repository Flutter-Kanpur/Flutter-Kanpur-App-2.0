import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_knp_mobile_app_v2/core/storage/app_prefs.dart';
import 'package:flutter_knp_mobile_app_v2/modules/explore/data/contests_local_data_source.dart';
import 'package:flutter_knp_mobile_app_v2/modules/explore/domain/contest_preview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

/// Ticks every second for a live countdown; `.autoDispose` stops it once no
/// card is watching.
final contestCountdownTickerProvider = StreamProvider.autoDispose<int>((ref) {
  return Stream.periodic(const Duration(seconds: 1), (tick) => tick);
});

/// Liked-contest ids - no server-side like table, so persisted via [AppPrefs].
final likedContestIdsProvider =
    AsyncNotifierProvider<LikedContestIdsNotifier, Set<String>>(
      LikedContestIdsNotifier.new,
    );

class LikedContestIdsNotifier extends AsyncNotifier<Set<String>> {
  @override
  Future<Set<String>> build() => AppPrefs.getLikedContestIds();

  Future<void> toggle(String contestId) async {
    final current = state.value ?? const {};
    final next = Set<String>.from(current);
    next.contains(contestId) ? next.remove(contestId) : next.add(contestId);
    state = AsyncData(next);
    await AppPrefs.setLikedContestIds(next);
  }
}

/// Paginated contests list for the Contests screen.
class ContestsPagedState {
  const ContestsPagedState({
    this.contests = const [],
    this.hasMore = false,
    this.isLoadingMore = false,
  });

  final List<ContestPreview> contests;
  final bool hasMore;
  final bool isLoadingMore;

  ContestsPagedState copyWith({
    List<ContestPreview>? contests,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return ContestsPagedState(
      contests: contests ?? this.contests,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

final contestsPagedProvider =
    AsyncNotifierProvider<ContestsPagedNotifier, ContestsPagedState>(
      ContestsPagedNotifier.new,
    );

class ContestsPagedNotifier extends AsyncNotifier<ContestsPagedState> {
  static const initialCount = 2;

  @override
  Future<ContestsPagedState> build() => _load();

  Future<ContestsPagedState> _load() async {
    final all = ContestsLocalDataSource.fetchAll();
    return ContestsPagedState(
      contests: all.take(initialCount).toList(),
      hasMore: all.length > initialCount,
    );
  }

  Future<void> refresh() async => state = await AsyncValue.guard(_load);

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasMore || current.isLoadingMore) return;

    state = AsyncData(current.copyWith(isLoadingMore: true));
    final all = ContestsLocalDataSource.fetchAll();
    state = AsyncData(
      current.copyWith(
        contests: all,
        hasMore: false,
        isLoadingMore: false,
      ),
    );
  }

  /// Collapses back to [initialCount] and reopens `hasMore`.
  void collapse() {
    final current = state.value;
    if (current == null || current.contests.length <= initialCount) return;

    state = AsyncData(
      current.copyWith(
        contests: current.contests.take(initialCount).toList(),
        hasMore: true,
      ),
    );
  }
}

/// Owned here so the screen can stay a plain `ConsumerWidget`.
final contestSearchControllerProvider =
    Provider.autoDispose<TextEditingController>((ref) {
      final controller = TextEditingController();
      ref.onDispose(controller.dispose);
      return controller;
    });

/// Not `autoDispose` - nothing watches it persistently, so it'd be
/// recreated on every read.
final _speechToTextProvider = Provider<stt.SpeechToText>((ref) {
  final speech = stt.SpeechToText();
  ref.onDispose(speech.cancel);
  return speech;
});

/// Search state over the in-memory contest list (title/category/tags).
class ContestSearchState {
  const ContestSearchState({
    this.query = '',
    this.results = const [],
    this.isSearching = false,
    this.isListening = false,
  });

  final String query;
  final List<ContestPreview> results;

  /// True while the debounced request is in flight; `results` is left
  /// untouched until it resolves.
  final bool isSearching;

  final bool isListening;

  bool get isActive => query.isNotEmpty;

  ContestSearchState copyWith({
    String? query,
    List<ContestPreview>? results,
    bool? isSearching,
    bool? isListening,
  }) {
    return ContestSearchState(
      query: query ?? this.query,
      results: results ?? this.results,
      isSearching: isSearching ?? this.isSearching,
      isListening: isListening ?? this.isListening,
    );
  }
}

final contestSearchProvider =
    NotifierProvider<ContestSearchNotifier, ContestSearchState>(
      ContestSearchNotifier.new,
    );

class ContestSearchNotifier extends Notifier<ContestSearchState> {
  static const _debounceDuration = Duration(milliseconds: 400);

  Timer? _debounce;

  /// Guards a stale in-flight request from clobbering a newer one.
  int _requestId = 0;

  TextEditingController get _controller =>
      ref.read(contestSearchControllerProvider);
  stt.SpeechToText get _speech => ref.read(_speechToTextProvider);

  @override
  ContestSearchState build() {
    ref.onDispose(() => _debounce?.cancel());
    return const ContestSearchState();
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
    final needle = query.toLowerCase();
    final rows = ContestsLocalDataSource.fetchAll()
        .where(
          (c) =>
              c.title.toLowerCase().contains(needle) ||
              c.categoryLabel.toLowerCase().contains(needle) ||
              c.tags.any((tag) => tag.toLowerCase().contains(needle)),
        )
        .toList();
    if (requestId != _requestId) return; // superseded by a newer search
    state = state.copyWith(query: query, results: rows, isSearching: false);
  }

  void clear() {
    _debounce?.cancel();
    _requestId++;
    state = state.copyWith(query: '', results: const [], isSearching: false);
  }
}
