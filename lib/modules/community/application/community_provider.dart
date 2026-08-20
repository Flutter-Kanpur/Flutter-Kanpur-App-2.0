import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/data/repositories/community_repository.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/data/services/answer_service.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/domain/community_models.dart';
import 'package:flutter_knp_mobile_app_v2/modules/explore/application/explore_providers.dart';

// --- Repository -------------------------------------------------------------

final communityRepositoryProvider = Provider<CommunityRepository>((ref) {
  return CommunityRepository();
});

final answerServiceProvider = Provider<AnswerService>((ref) {
  return AnswerService();
});

// --- Current user -----------------------------------------------------------

final currentUserIdProvider = Provider<String?>((ref) {
  return Supabase.instance.client.auth.currentUser?.id;
});

// --- Questions feed (paginated) ---------------------------------------------

/// Immutable view of the feed: the loaded page(s) plus paging flags.
class QuestionFeedState {
  const QuestionFeedState({
    this.questions = const [],
    this.filter,
    this.hasMore = false,
    this.isLoadingMore = false,
    this.loadMoreError,
  });

  final List<CommunityQuestion> questions;
  final String? filter;
  final bool hasMore;
  final bool isLoadingMore;

  /// Set when a *subsequent* page fails. The first page's failure surfaces
  /// through the AsyncValue itself so the whole list can show an error view.
  final Object? loadMoreError;

  QuestionFeedState copyWith({
    List<CommunityQuestion>? questions,
    String? filter,
    bool clearFilter = false,
    bool? hasMore,
    bool? isLoadingMore,
    Object? loadMoreError,
    bool clearLoadMoreError = false,
  }) {
    return QuestionFeedState(
      questions: questions ?? this.questions,
      filter: clearFilter ? null : (filter ?? this.filter),
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      loadMoreError: clearLoadMoreError
          ? null
          : (loadMoreError ?? this.loadMoreError),
    );
  }
}

final questionFeedProvider =
    AsyncNotifierProvider<QuestionFeedNotifier, QuestionFeedState>(
      QuestionFeedNotifier.new,
    );

class QuestionFeedNotifier extends AsyncNotifier<QuestionFeedState> {
  static const pageSize = 20;

  String? _filter;

  CommunityRepository get _repo => ref.read(communityRepositoryProvider);

  @override
  Future<QuestionFeedState> build() => _loadFirstPage();

  Future<QuestionFeedState> _loadFirstPage() async {
    final page = await _repo.fetchQuestionPage(
      filter: _filter,
      limit: pageSize,
      offset: 0,
    );
    return QuestionFeedState(
      questions: page.items,
      filter: _filter,
      hasMore: page.hasMore,
    );
  }

  /// Applies a filter and reloads from page 0. Passing null clears it.
  ///
  /// Drops to a bare loading state on purpose: the old list belongs to the
  /// previous filter, so showing it while the new one loads would be wrong.
  Future<void> setFilter(String? filter) async {
    if (_filter == filter) return;
    _filter = filter;
    state = const AsyncLoading<QuestionFeedState>();
    state = await AsyncValue.guard(_loadFirstPage);
  }

  /// Pull-to-refresh. Assigns the result directly so the current list stays on
  /// screen while reloading - RefreshIndicator already shows its own spinner.
  Future<void> refresh() async {
    state = await AsyncValue.guard(_loadFirstPage);
  }

  /// Appends the next page. No-ops while one is already in flight, at the end
  /// of the list, or before the first page has arrived.
  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasMore || current.isLoadingMore) return;

    state = AsyncData(
      current.copyWith(isLoadingMore: true, clearLoadMoreError: true),
    );

    try {
      final page = await _repo.fetchQuestionPage(
        filter: _filter,
        limit: pageSize,
        offset: current.questions.length,
      );
      state = AsyncData(
        current.copyWith(
          questions: [...current.questions, ...page.items],
          hasMore: page.hasMore,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      state = AsyncData(
        current.copyWith(isLoadingMore: false, loadMoreError: e),
      );
    }
  }

  /// Swaps one question in place - used by optimistic like / save updates so
  /// the whole feed doesn't have to refetch.
  void replaceQuestion(CommunityQuestion updated) {
    final current = state.value;
    if (current == null) return;
    final index = current.questions.indexWhere((q) => q.id == updated.id);
    if (index == -1) return;

    final next = [...current.questions];
    next[index] = updated;
    state = AsyncData(current.copyWith(questions: next));
  }
}

/// Read-only view of just the list, for widgets that don't care about paging.
final questionsProvider = Provider<AsyncValue<List<CommunityQuestion>>>((ref) {
  return ref.watch(questionFeedProvider).whenData((s) => s.questions);
});

// --- Community members ------------------------------------------------------

final communityMembersProvider =
    AsyncNotifierProvider<CommunityMembersNotifier, List<CommunityMember>>(
      CommunityMembersNotifier.new,
    );

class CommunityMembersNotifier extends AsyncNotifier<List<CommunityMember>> {
  @override
  Future<List<CommunityMember>> build() =>
      ref.read(communityRepositoryProvider).fetchMembers();

  Future<void> refresh() async {
    state = await AsyncValue.guard(
      () => ref.read(communityRepositoryProvider).fetchMembers(),
    );
  }
}

// --- Community projects -----------------------------------------------------

final communityProjectsProvider =
    AsyncNotifierProvider<CommunityProjectsNotifier, List<CommunityProject>>(
      CommunityProjectsNotifier.new,
    );

class CommunityProjectsNotifier extends AsyncNotifier<List<CommunityProject>> {
  @override
  Future<List<CommunityProject>> build() =>
      ref.read(communityRepositoryProvider).fetchProjects();

  Future<void> refresh() async {
    state = await AsyncValue.guard(
      () => ref.read(communityRepositoryProvider).fetchProjects(),
    );
  }
}

/// Current user's projects waiting for community-team approval.
final myPendingProjectsProvider =
    AsyncNotifierProvider<MyPendingProjectsNotifier, List<CommunityProject>>(
      MyPendingProjectsNotifier.new,
    );

class MyPendingProjectsNotifier extends AsyncNotifier<List<CommunityProject>> {
  @override
  Future<List<CommunityProject>> build() =>
      ref.read(communityRepositoryProvider).fetchMyProjectsPendingReview();

  Future<void> refresh() async {
    state = await AsyncValue.guard(
      () =>
          ref.read(communityRepositoryProvider).fetchMyProjectsPendingReview(),
    );
  }
}

// --- Question detail --------------------------------------------------------

final questionDetailProvider =
    AsyncNotifierProvider.family<
      QuestionDetailNotifier,
      CommunityQuestion?,
      String
    >(QuestionDetailNotifier.new);

class QuestionDetailNotifier extends AsyncNotifier<CommunityQuestion?> {
  QuestionDetailNotifier(this.questionId);

  /// Riverpod 3 hands a family's argument to the notifier constructor.
  final String questionId;

  @override
  Future<CommunityQuestion?> build() {
    return ref.read(communityRepositoryProvider).fetchQuestionById(questionId);
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(
      () => ref.read(communityRepositoryProvider).fetchQuestionById(questionId),
    );
  }

  void replace(CommunityQuestion question) => state = AsyncData(question);
}

// --- Replies (paginated) ----------------------------------------------------

class ReplyFeedState {
  const ReplyFeedState({
    this.replies = const [],
    this.hasMore = false,
    this.isLoadingMore = false,
  });

  final List<CommunityReply> replies;
  final bool hasMore;
  final bool isLoadingMore;

  ReplyFeedState copyWith({
    List<CommunityReply>? replies,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return ReplyFeedState(
      replies: replies ?? this.replies,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

final repliesProvider =
    AsyncNotifierProvider.family<RepliesNotifier, ReplyFeedState, String>(
      RepliesNotifier.new,
    );

class RepliesNotifier extends AsyncNotifier<ReplyFeedState> {
  RepliesNotifier(this.questionId);

  /// Riverpod 3 hands a family's argument to the notifier constructor.
  final String questionId;

  static const pageSize = 5;

  CommunityRepository get _repo => ref.read(communityRepositoryProvider);

  @override
  Future<ReplyFeedState> build() => _loadFirstPage();

  Future<ReplyFeedState> _loadFirstPage() async {
    // Ask for one extra to detect a next page without a count query.
    final rows = await _repo.fetchReplies(
      questionId,
      limit: pageSize + 1,
      offset: 0,
    );
    final hasMore = rows.length > pageSize;
    return ReplyFeedState(
      replies: hasMore ? rows.sublist(0, pageSize) : rows,
      hasMore: hasMore,
    );
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(_loadFirstPage);
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasMore || current.isLoadingMore) return;

    state = AsyncData(current.copyWith(isLoadingMore: true));
    try {
      final rows = await _repo.fetchReplies(
        questionId,
        limit: pageSize + 1,
        offset: current.replies.length,
      );
      final hasMore = rows.length > pageSize;
      state = AsyncData(
        current.copyWith(
          replies: [
            ...current.replies,
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

  void replaceReply(CommunityReply updated) {
    final current = state.value;
    if (current == null) return;
    final index = current.replies.indexWhere((r) => r.id == updated.id);
    if (index == -1) return;

    final next = [...current.replies];
    next[index] = updated;
    state = AsyncData(current.copyWith(replies: next));
  }
}

// --- Comments on an answer --------------------------------------------------

final answerCommentsProvider =
    AsyncNotifierProvider.family<
      AnswerCommentsNotifier,
      List<CommunityReply>,
      String
    >(AnswerCommentsNotifier.new);

class AnswerCommentsNotifier extends AsyncNotifier<List<CommunityReply>> {
  AnswerCommentsNotifier(this.answerId);

  /// Riverpod 3 hands a family's argument to the notifier constructor.
  final String answerId;

  @override
  Future<List<CommunityReply>> build() =>
      ref.read(answerServiceProvider).fetchComments(answerId);

  Future<void> refresh() async {
    state = await AsyncValue.guard(
      () => ref.read(answerServiceProvider).fetchComments(answerId),
    );
  }
}

// --- Engagement (like / save) -----------------------------------------------

/// Like and bookmark toggles, applied optimistically and rolled back on error.
///
/// These do not go through [communityActionControllerProvider] because a
/// failed like should not put the whole screen into an error state.
final communityEngagementProvider = Provider<CommunityEngagement>((ref) {
  return CommunityEngagement(ref);
});

class CommunityEngagement {
  CommunityEngagement(this._ref);

  final Ref _ref;

  CommunityRepository get _repo => _ref.read(communityRepositoryProvider);

  /// Returns null on success, or the error to surface to the user.
  Future<Object?> toggleQuestionLike(CommunityQuestion question) async {
    final optimistic = question.copyWith(
      isLiked: !question.isLiked,
      likeCount: question.likeCount + (question.isLiked ? -1 : 1),
    );
    _applyQuestion(optimistic);

    try {
      await _repo.toggleQuestionLike(
        questionId: question.id,
        currentlyLiked: question.isLiked,
      );
      return null;
    } catch (e) {
      _applyQuestion(question); // roll back
      return e;
    }
  }

  Future<Object?> toggleQuestionSave(CommunityQuestion question) async {
    final optimistic = question.copyWith(
      isSaved: !question.isSaved,
      saveCount: question.saveCount + (question.isSaved ? -1 : 1),
    );
    _applyQuestion(optimistic);

    try {
      await _repo.toggleQuestionSave(
        questionId: question.id,
        currentlySaved: question.isSaved,
      );
      return null;
    } catch (e) {
      _applyQuestion(question);
      return e;
    }
  }

  Future<Object?> toggleAnswerLike({
    required String questionId,
    required CommunityReply reply,
  }) async {
    final optimistic = reply.copyWith(
      isLiked: !reply.isLiked,
      likeCount: reply.likeCount + (reply.isLiked ? -1 : 1),
    );
    _ref.read(repliesProvider(questionId).notifier).replaceReply(optimistic);

    try {
      await _ref
          .read(answerServiceProvider)
          .toggleLike(answerId: reply.id, currentlyLiked: reply.isLiked);
      return null;
    } catch (e) {
      _ref.read(repliesProvider(questionId).notifier).replaceReply(reply);
      return e;
    }
  }

  /// Keeps the feed and the detail screen showing the same numbers.
  ///
  /// The detail provider is only touched when it is already alive. Reading
  /// `.notifier` on a family that nothing is watching *creates* it, which fired
  /// a pointless fetchQuestionById on every like from the feed - and that
  /// in-flight fetch (issued before the like was written) then overwrote the
  /// optimistic value, leaving a stale un-liked entry cached for the next time
  /// the detail screen opened.
  void _applyQuestion(CommunityQuestion question) {
    _ref.read(questionFeedProvider.notifier).replaceQuestion(question);

    final detail = questionDetailProvider(question.id);
    if (_ref.exists(detail)) {
      _ref.read(detail.notifier).replace(question);
    }
  }
}

// --- Actions (submit question / answer / project) ---------------------------

final communityActionControllerProvider =
    AsyncNotifierProvider<CommunityActionController, void>(
      CommunityActionController.new,
    );

/// Result of a submit attempt - carries the error so screens can show the real
/// message instead of a generic failure.
class SubmitResult {
  const SubmitResult.success() : error = null;
  const SubmitResult.failure(this.error);

  final Object? error;

  bool get isSuccess => error == null;
  String get message => error?.toString() ?? '';
}

class CommunityActionController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<SubmitResult> _run(Future<void> Function() action) async {
    state = const AsyncLoading();
    try {
      await action();
      state = const AsyncData(null);
      return const SubmitResult.success();
    } catch (e, st) {
      state = AsyncError(e, st);
      return SubmitResult.failure(e);
    }
  }

  Future<SubmitResult> submitQuestion(CommunityQuestionDraft draft) async {
    final result = await _run(
      () => ref.read(communityRepositoryProvider).submitQuestion(draft),
    );
    if (result.isSuccess) {
      await ref.read(questionFeedProvider.notifier).refresh();
    }
    return result;
  }

  Future<SubmitResult> submitAnswer({
    required String questionId,
    required String body,
    String? codeSnippet,
  }) async {
    final result = await _run(
      () => ref
          .read(answerServiceProvider)
          .submitAnswer(
            questionId: questionId,
            body: body,
            codeSnippet: codeSnippet,
          ),
    );
    if (result.isSuccess) {
      await ref.read(repliesProvider(questionId).notifier).refresh();
      await ref.read(questionDetailProvider(questionId).notifier).refresh();
    }
    return result;
  }

  Future<SubmitResult> submitComment({
    required String answerId,
    required String questionId,
    required String body,
  }) async {
    final result = await _run(
      () => ref
          .read(answerServiceProvider)
          .submitComment(answerId: answerId, body: body),
    );
    if (result.isSuccess) {
      await ref.read(answerCommentsProvider(answerId).notifier).refresh();
      // comment_count lives on the answer row, so the reply list needs a
      // reload for the count under the answer to move.
      await ref.read(repliesProvider(questionId).notifier).refresh();
    }
    return result;
  }

  Future<SubmitResult> deleteAnswer(String answerId, String questionId) async {
    final result = await _run(
      () => ref.read(answerServiceProvider).deleteAnswer(answerId),
    );
    if (result.isSuccess) {
      await ref.read(repliesProvider(questionId).notifier).refresh();
      await ref.read(questionDetailProvider(questionId).notifier).refresh();
    }
    return result;
  }

  Future<SubmitResult> submitProject(
    CommunityProjectSubmission submission,
  ) async {
    final result = await _run(
      () => ref.read(communityRepositoryProvider).submitProject(submission),
    );
    if (result.isSuccess) {
      ref.invalidate(communityProjectsProvider);
      ref.invalidate(myPendingProjectsProvider);
      // Explore's model/repo also surfaces projects (once approved &
      // status='active') - keep both in sync with the same invalidation.
      ref.invalidate(exploreCommunityProjectPreviewsProvider);
      ref.invalidate(communityProjectsPagedProvider);
    }
    return result;
  }
}
