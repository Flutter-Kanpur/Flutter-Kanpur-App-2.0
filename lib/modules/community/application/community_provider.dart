import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/data/repositories/community_repository.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/data/services/answer_service.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/domain/community_models.dart';

// ─── Repository ──────────────────────────────────────────────────────────────

final communityRepositoryProvider = Provider<CommunityRepository>((ref) {
  return CommunityRepository();
});

final answerServiceProvider = Provider<AnswerService>((ref) {
  return AnswerService();
});

// ─── Current User ────────────────────────────────────────────────────────────

final currentUserIdProvider = FutureProvider<String?>((ref) async {
  final user = Supabase.instance.client.auth.currentUser;
  return user?.id;
});

// ─── Questions ───────────────────────────────────────────────────────────────

final questionsProvider =
    AsyncNotifierProvider<QuestionsNotifier, List<CommunityQuestion>>(
      QuestionsNotifier.new,
    );

class QuestionsNotifier extends AsyncNotifier<List<CommunityQuestion>> {
  String? _filter;

  @override
  Future<List<CommunityQuestion>> build() =>
      ref.read(communityRepositoryProvider).fetchQuestions(filter: _filter);

  Future<void> setFilter(String? filter) async {
    _filter = filter;
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () =>
          ref.read(communityRepositoryProvider).fetchQuestions(filter: _filter),
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () =>
          ref.read(communityRepositoryProvider).fetchQuestions(filter: _filter),
    );
  }
}

// ─── Community Members ───────────────────────────────────────────────────────

final communityMembersProvider =
    AsyncNotifierProvider<CommunityMembersNotifier, List<CommunityMember>>(
      CommunityMembersNotifier.new,
    );

class CommunityMembersNotifier extends AsyncNotifier<List<CommunityMember>> {
  @override
  Future<List<CommunityMember>> build() =>
      ref.read(communityRepositoryProvider).fetchMembers();

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(communityRepositoryProvider).fetchMembers(),
    );
  }
}

// ─── Community Projects ──────────────────────────────────────────────────────

final communityProjectsProvider =
    AsyncNotifierProvider<CommunityProjectsNotifier, List<CommunityProject>>(
      CommunityProjectsNotifier.new,
    );

class CommunityProjectsNotifier extends AsyncNotifier<List<CommunityProject>> {
  @override
  Future<List<CommunityProject>> build() =>
      ref.read(communityRepositoryProvider).fetchProjects();

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(communityRepositoryProvider).fetchProjects(),
    );
  }
}

// ─── Question Detail ─────────────────────────────────────────────────────────

final questionDetailProvider =
    FutureProvider.family<CommunityQuestion?, String>((ref, questionId) {
      return ref
          .read(communityRepositoryProvider)
          .fetchQuestionById(questionId);
    });

// ─── Replies ─────────────────────────────────────────────────────────────────

final repliesProvider = FutureProvider.family<List<CommunityReply>, String>((
  ref,
  questionId,
) {
  return ref.read(communityRepositoryProvider).fetchReplies(questionId);
});

// ─── Actions (submit question / project) ─────────────────────────────────────

final communityActionControllerProvider =
    AsyncNotifierProvider<CommunityActionController, void>(
      CommunityActionController.new,
    );

class CommunityActionController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<bool> submitQuestion(CommunityQuestionDraft draft) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(communityRepositoryProvider).submitQuestion(draft),
    );
    if (!state.hasError) {
      ref.invalidate(questionsProvider);
    }
    return !state.hasError;
  }

  Future<bool> submitAnswer({
    required String questionId,
    required String body,
    String? codeSnippet,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref
          .read(answerServiceProvider)
          .submitAnswer(
            questionId: questionId,
            body: body,
            codeSnippet: codeSnippet,
          ),
    );
    if (!state.hasError) {
      ref.invalidate(repliesProvider(questionId));
    }
    return !state.hasError;
  }

  Future<bool> deleteAnswer(String answerId, String questionId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(answerServiceProvider).deleteAnswer(answerId),
    );
    if (!state.hasError) {
      ref.invalidate(repliesProvider(questionId));
    }
    return !state.hasError;
  }

  Future<bool> likeAnswer(String answerId, String questionId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(answerServiceProvider).likeAnswer(answerId: answerId),
    );
    if (!state.hasError) {
      ref.invalidate(repliesProvider(questionId));
    }
    return !state.hasError;
  }

  Future<bool> submitProject(CommunityProjectSubmission submission) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(communityRepositoryProvider).submitProject(submission),
    );
    if (!state.hasError) {
      ref.invalidate(communityProjectsProvider);
    }
    return !state.hasError;
  }
}
