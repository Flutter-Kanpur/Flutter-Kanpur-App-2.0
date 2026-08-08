import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_knp_mobile_app_v2/core/database/database_tables.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/data/repositories/community_repository.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/domain/community_models.dart';

/// Reads and writes for answers (replies) and their likes / comments.
///
/// Note on columns: the join tables key off `user_uid`, not `user_id` — an
/// earlier version used the latter, so every like failed against Postgres.
///
/// Like and comment counters are maintained by triggers (migration 004), so
/// nothing here writes `like_count` / `comment_count` directly.
class AnswerService {
  AnswerService({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  String? get _currentUserId => _client.auth.currentUser?.id;

  String _requireUser() {
    final id = _currentUserId;
    if (id == null) throw const CommunityAuthException();
    return id;
  }

  Future<void> submitAnswer({
    required String questionId,
    required String body,
    String? codeSnippet,
    String? imageUrl,
  }) async {
    final userId = _requireUser();

    await _client.from(DatabaseTables.answers).insert({
      'question_id': questionId,
      'author_uid': userId,
      'body': body,
      'code_snippet': codeSnippet,
      'image_url': imageUrl,
    });
  }

  /// Adds or removes a like. Returns the resulting liked state.
  Future<bool> toggleLike({
    required String answerId,
    required bool currentlyLiked,
  }) async {
    final userId = _requireUser();

    if (currentlyLiked) {
      await _client
          .from(DatabaseTables.answerLikes)
          .delete()
          .eq('answer_id', answerId)
          .eq('user_uid', userId);
      return false;
    }

    await _client.from(DatabaseTables.answerLikes).insert({
      'answer_id': answerId,
      'user_uid': userId,
    });
    return true;
  }

  Future<bool> hasLiked(String answerId) async {
    final userId = _currentUserId;
    if (userId == null) return false;
    try {
      final data =
          await _client
                  .from(DatabaseTables.answerLikes)
                  .select('id')
                  .eq('answer_id', answerId)
                  .eq('user_uid', userId)
              as List<dynamic>;
      return data.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  /// Soft delete — the row stays for audit, `is_deleted` hides it and the
  /// trigger decrements the parent question's answer_count.
  Future<void> deleteAnswer(String answerId) async {
    final userId = _requireUser();

    await _client
        .from(DatabaseTables.answers)
        .update({'is_deleted': true, 'updated_at': _now()})
        .eq('id', answerId)
        .eq('author_uid', userId);
  }

  Future<void> updateAnswer({
    required String answerId,
    required String body,
    String? codeSnippet,
    String? imageUrl,
  }) async {
    final userId = _requireUser();

    await _client
        .from(DatabaseTables.answers)
        .update({
          'body': body,
          'code_snippet': codeSnippet,
          'image_url': imageUrl,
          'updated_at': _now(),
        })
        .eq('id', answerId)
        .eq('author_uid', userId);
  }

  // ─── Comments on an answer ────────────────────────────────────────────────

  Future<List<CommunityReply>> fetchComments(String answerId) async {
    final data =
        await _client
                .from(DatabaseTables.answerComments)
                .select('''id, body, created_at, author_uid,
                   author:users!author_uid(uid, display_name, username, photo_url)''')
                .eq('answer_id', answerId)
                .eq('is_deleted', false)
                .order('created_at', ascending: true)
            as List<dynamic>;

    return data
        .map((m) => CommunityReply.fromMap(m as Map<String, dynamic>))
        .toList();
  }

  Future<void> submitComment({
    required String answerId,
    required String body,
  }) async {
    final userId = _requireUser();

    await _client.from(DatabaseTables.answerComments).insert({
      'answer_id': answerId,
      'author_uid': userId,
      'body': body,
    });
  }

  Future<void> deleteComment(String commentId) async {
    final userId = _requireUser();

    await _client
        .from(DatabaseTables.answerComments)
        .update({'is_deleted': true, 'updated_at': _now()})
        .eq('id', commentId)
        .eq('author_uid', userId);
  }

  String _now() => DateTime.now().toUtc().toIso8601String();
}
