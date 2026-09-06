import 'package:flutter_knp_mobile_app_v2/modules/community/domain/community_models.dart';
import 'package:flutter_knp_mobile_app_v2/core/database/database_tables.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Filter identifiers accepted by [CommunityRepository.fetchQuestionPage].
///
/// These are the values the filter chips emit — keep the two in sync.
class CommunityFilter {
  const CommunityFilter._();

  static const trending = 'trending';
  static const active = 'active';
  static const unanswered = 'unanswered';
  static const myQuestions = 'my_questions';
  static const saved = 'saved';

  static const all = [trending, active, unanswered, myQuestions, saved];

  static String labelOf(String filter) {
    return switch (filter) {
      trending => 'Trending',
      active => 'Active',
      unanswered => 'Unanswered',
      myQuestions => 'My questions',
      saved => 'Saved',
      _ => filter,
    };
  }
}

class CommunityRepository {
  CommunityRepository({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  static const _questionColumns =
      '''id, title, body, image_url, status, category, tags, answer_count,
         like_count, save_count, view_count, created_at, author_uid,
         author:users!author_uid(uid, display_name, username, photo_url)''';

  static const _answerColumns =
      '''id, body, code_snippet, image_url, like_count, comment_count,
         view_count, created_at, author_uid,
         author:users!author_uid(uid, display_name, username, photo_url)''';

  String? get _currentUserId => _client.auth.currentUser?.id;

  // ─── Fetch ────────────────────────────────────────────────────────────────

  /// Fetches one page of questions.
  ///
  /// Asks for [limit] + 1 rows so `hasMore` is known without a second count
  /// query, then trims the extra row off before returning.
  Future<CommunityQuestionPage> fetchQuestionPage({
    String? filter,
    int limit = 20,
    int offset = 0,
  }) async {
    final userId = _currentUserId;

    // `saved` is driven off the join table, so it needs its own id lookup
    // before the main query can be restricted.
    List<String>? restrictToIds;
    if (filter == CommunityFilter.saved) {
      if (userId == null) return const CommunityQuestionPage(items: [], hasMore: false);
      restrictToIds = await _savedQuestionIds(userId);
      if (restrictToIds.isEmpty) {
        return const CommunityQuestionPage(items: [], hasMore: false);
      }
    }

    var query = _client
        .from(DatabaseTables.questions)
        .select(_questionColumns)
        .eq('is_deleted', false);

    if (filter == CommunityFilter.unanswered) {
      query = query.eq('answer_count', 0);
    }
    if (filter == CommunityFilter.myQuestions) {
      if (userId == null) {
        return const CommunityQuestionPage(items: [], hasMore: false);
      }
      query = query.eq('author_uid', userId);
    }
    if (restrictToIds != null) {
      query = query.inFilter('id', restrictToIds);
    }

    // Trending ranks by engagement; everything else is newest-first.
    final ordered = filter == CommunityFilter.trending
        ? query
              .order('like_count', ascending: false)
              .order('answer_count', ascending: false)
              .order('created_at', ascending: false)
        : query.order('created_at', ascending: false);

    final data =
        await ordered.range(offset, offset + limit) as List<dynamic>;

    final hasMore = data.length > limit;
    final rows = (hasMore ? data.sublist(0, limit) : data)
        .cast<Map<String, dynamic>>();

    return CommunityQuestionPage(
      items: await _hydrateQuestions(rows, userId),
      hasMore: hasMore,
    );
  }

  /// Kept for callers that just want a plain list (home carousel, etc.).
  Future<List<CommunityQuestion>> fetchQuestions({
    String? filter,
    int limit = 20,
  }) async {
    final page = await fetchQuestionPage(filter: filter, limit: limit);
    return page.items;
  }

  Future<CommunityQuestion?> fetchQuestionById(String questionId) async {
    try {
      final data = await _client
          .from(DatabaseTables.questions)
          .select(_questionColumns)
          .eq('id', questionId)
          .eq('is_deleted', false)
          .single();

      final hydrated = await _hydrateQuestions([data], _currentUserId);
      return hydrated.isEmpty ? null : hydrated.first;
    } catch (_) {
      return null;
    }
  }

  /// Attaches the signed-in user's like / save state to a batch of rows in two
  /// queries, rather than one pair per question.
  Future<List<CommunityQuestion>> _hydrateQuestions(
    List<Map<String, dynamic>> rows,
    String? userId,
  ) async {
    if (rows.isEmpty) return const [];
    if (userId == null) {
      return rows.map(CommunityQuestion.fromMap).toList();
    }

    final ids = rows
        .map((r) => r['id'] as String? ?? '')
        .where((id) => id.isNotEmpty)
        .toList();
    if (ids.isEmpty) return rows.map(CommunityQuestion.fromMap).toList();

    final results = await Future.wait([
      _idSet(DatabaseTables.questionLikes, 'question_id', ids, userId),
      _idSet(DatabaseTables.questionSaves, 'question_id', ids, userId),
    ]);
    final liked = results[0];
    final saved = results[1];

    return rows.map((row) {
      final id = row['id'] as String? ?? '';
      return CommunityQuestion.fromMap(
        row,
        isLiked: liked.contains(id),
        isSaved: saved.contains(id),
      );
    }).toList();
  }

  Future<Set<String>> _idSet(
    String table,
    String column,
    List<String> ids,
    String userId,
  ) async {
    try {
      final data =
          await _client
                  .from(table)
                  .select(column)
                  .eq('user_uid', userId)
                  .inFilter(column, ids)
              as List<dynamic>;
      return data
          .map((r) => (r as Map<String, dynamic>)[column] as String? ?? '')
          .where((id) => id.isNotEmpty)
          .toSet();
    } catch (_) {
      // Engagement state is decorative — never fail the whole feed over it.
      return <String>{};
    }
  }

  Future<List<String>> _savedQuestionIds(String userId) async {
    try {
      final data =
          await _client
                  .from(DatabaseTables.questionSaves)
                  .select('question_id')
                  .eq('user_uid', userId)
              as List<dynamic>;
      return data
          .map(
            (r) => (r as Map<String, dynamic>)['question_id'] as String? ?? '',
          )
          .where((id) => id.isNotEmpty)
          .toList();
    } catch (_) {
      return const [];
    }
  }

  Future<List<CommunityReply>> fetchReplies(
    String questionId, {
    int limit = 5,
    int offset = 0,
  }) async {
    final data =
        await _client
                .from(DatabaseTables.answers)
                .select(_answerColumns)
                .eq('question_id', questionId)
                .eq('is_deleted', false)
                .order('like_count', ascending: false)
                .order('created_at', ascending: false)
                .range(offset, offset + limit - 1)
            as List<dynamic>;

    final rows = data.cast<Map<String, dynamic>>();
    final userId = _currentUserId;
    if (rows.isEmpty || userId == null) {
      return rows.map((m) => CommunityReply.fromMap(m)).toList();
    }

    final ids = rows
        .map((r) => r['id'] as String? ?? '')
        .where((id) => id.isNotEmpty)
        .toList();
    final liked = await _idSet(
      DatabaseTables.answerLikes,
      'answer_id',
      ids,
      userId,
    );

    return rows
        .map(
          (m) => CommunityReply.fromMap(
            m,
            isLiked: liked.contains(m['id'] as String? ?? ''),
          ),
        )
        .toList();
  }

  /// Active contributors for the Community screen (`community_memberships`).
  Future<List<CommunityMember>> fetchMembers({int limit = 50}) async {
    final data = await _client
        .from(DatabaseTables.communityMemberships)
        .select(
          'role, membership_status, joined_at, '
          'member:users!user_uid(display_name, username, photo_url, user_skills(skill_name))',
        )
        .eq('membership_status', 'active')
        .order('joined_at', ascending: false)
        .limit(limit);

    return (data as List<dynamic>)
        .map((m) => CommunityMember.fromMap(m as Map<String, dynamic>))
        .toList();
  }

  Future<List<CommunityProject>> fetchProjects({int limit = 20}) async {
    final data = await _client
        .from(DatabaseTables.projects)
        .select(
          'id, title, summary, status, github_url, live_url, cover_image_url, '
          'created_at, owner:users!owner_uid(display_name, username), '
          'project_tech_stack(tech_name)',
        )
        .eq('is_deleted', false)
        .neq('status', 'draft')
        .order('created_at', ascending: false)
        .limit(limit);

    return (data as List<dynamic>)
        .map((m) => CommunityProject.fromMap(m as Map<String, dynamic>))
        .toList();
  }

  /// Projects the signed-in user has submitted and are awaiting team review.
  Future<List<CommunityProject>> fetchMyProjectsPendingReview() async {
    final userId = _currentUserId;
    if (userId == null) return const [];

    final data = await _client
        .from(DatabaseTables.projects)
        .select(
          'id, title, summary, status, github_url, live_url, cover_image_url, '
          'created_at, owner:users!owner_uid(display_name, username), '
          'project_tech_stack(tech_name)',
        )
        .eq('is_deleted', false)
        .eq('owner_uid', userId)
        .eq('status', 'pending_review')
        .order('created_at', ascending: false);

    return (data as List<dynamic>)
        .map((m) => CommunityProject.fromMap(m as Map<String, dynamic>))
        .toList();
  }

  // ─── Engagement ───────────────────────────────────────────────────────────

  /// Adds or removes a like. Returns the resulting liked state.
  ///
  /// `questions.like_count` is maintained by a trigger (migration 004), so the
  /// client only touches the join table.
  Future<bool> toggleQuestionLike({
    required String questionId,
    required bool currentlyLiked,
  }) async {
    final userId = _requireUser();
    if (currentlyLiked) {
      await _client
          .from(DatabaseTables.questionLikes)
          .delete()
          .eq('question_id', questionId)
          .eq('user_uid', userId);
      return false;
    }
    await _client.from(DatabaseTables.questionLikes).insert({
      'question_id': questionId,
      'user_uid': userId,
    });
    return true;
  }

  Future<bool> toggleQuestionSave({
    required String questionId,
    required bool currentlySaved,
  }) async {
    final userId = _requireUser();
    if (currentlySaved) {
      await _client
          .from(DatabaseTables.questionSaves)
          .delete()
          .eq('question_id', questionId)
          .eq('user_uid', userId);
      return false;
    }
    await _client.from(DatabaseTables.questionSaves).insert({
      'question_id': questionId,
      'user_uid': userId,
    });
    return true;
  }

  // ─── Submit ───────────────────────────────────────────────────────────────

  Future<void> submitProject(CommunityProjectSubmission submission) async {
    final userId = _requireUser();

    final inserted =
        await _client.from(DatabaseTables.projects).insert({
              'slug': _slugFrom(submission.name),
              'title': submission.name,
              'summary': submission.description,
              'description': submission.description,
              'status': 'pending_review',
              'owner_uid': userId,
              'github_url': submission.githubUrl,
              'live_url': submission.liveDemoUrl,
              'cover_image_url': submission.screenshotUrl,
              'created_by': userId,
              'updated_by': userId,
            }).select('id').single();

    final projectId = inserted['id'] as String?;
    if (projectId == null || submission.techStack.isEmpty) return;

    // The two writes are not in one transaction, so a failure here would
    // otherwise strand a pending_review project with no tech stack and no way
    // for the user to retry cleanly. Roll the project back and surface the
    // original error.
    try {
      await _client
          .from(DatabaseTables.projectTechStack)
          .insert([
            for (final tech in submission.techStack)
              {'project_id': projectId, 'tech_name': tech},
          ]);
    } catch (_) {
      try {
        await _client
            .from(DatabaseTables.projects)
            .delete()
            .eq('id', projectId)
            .eq('owner_uid', userId);
      } catch (_) {
        // Best effort - the original error is the one worth reporting.
      }
      rethrow;
    }
  }

  Future<void> submitQuestion(CommunityQuestionDraft draft) async {
    final userId = _requireUser();

    await _client.from(DatabaseTables.questions).insert({
      'title': draft.title,
      'body': draft.details,
      'author_uid': userId,
      'status': 'open',
      'category': draft.category,
      'tags': draft.tags,
      'image_url': draft.imageUrl,
      'like_count': 0,
      'view_count': 0,
    });
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  /// Writes require a session. Previously these silently no-opped after a fake
  /// delay, so the UI reported success for a post that was never stored.
  String _requireUser() {
    final userId = _currentUserId;
    if (userId == null) {
      throw const CommunityAuthException();
    }
    return userId;
  }

  String _slugFrom(String value) {
    final base = value
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-|-$'), '');
    final slug = base.isEmpty ? 'community-project' : base;
    // Slugs are unique per project; suffix keeps re-submissions from colliding.
    return '$slug-${DateTime.now().millisecondsSinceEpoch % 100000}';
  }
}

/// Thrown when an action needs a signed-in user and there isn't one.
class CommunityAuthException implements Exception {
  const CommunityAuthException();

  @override
  String toString() => 'You need to be signed in to do that.';
}
