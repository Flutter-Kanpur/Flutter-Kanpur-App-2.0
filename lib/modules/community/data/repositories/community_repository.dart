import 'package:flutter_knp_mobile_app_v2/modules/community/domain/community_models.dart';
import 'package:flutter_knp_mobile_app_v2/core/database/database_tables.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CommunityRepository {
  CommunityRepository({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  // ─── Fetch ────────────────────────────────────────────────────────────────

  Future<List<CommunityQuestion>> fetchQuestions({
    String? filter,
    int limit = 20,
  }) async {
    var query = _client
        .from(DatabaseTables.questions)
        .select('''id, title, body, image_url, status, answer_count, like_count,
             view_count, created_at, author_uid,
             author:users!author_uid(uid, display_name, username, photo_url)''')
        .eq('is_deleted', false);

    if (filter == 'unanswered') query = query.eq('answer_count', 0);
    if (filter == 'my_questions') {
      final userId = _client.auth.currentUser?.id;
      if (userId != null) {
        query = query.eq('author_uid', userId);
      }
    }

    final data = await query.order('created_at', ascending: false).limit(limit);

    return (data as List<dynamic>)
        .map((m) => CommunityQuestion.fromMap(m as Map<String, dynamic>))
        .toList();
  }

  Future<CommunityQuestion?> fetchQuestionById(String questionId) async {
    try {
      final data = await _client
          .from(DatabaseTables.questions)
          .select(
            '''id, title, body, image_url, status, answer_count, like_count,
               view_count, created_at, author_uid,
               author:users!author_uid(uid, display_name, username, photo_url)''',
          )
          .eq('id', questionId)
          .eq('is_deleted', false)
          .single();

      return CommunityQuestion.fromMap(data);
    } catch (e) {
      return null;
    }
  }

  Future<List<CommunityReply>> fetchReplies(
    String questionId, {
    int limit = 5,
    int offset = 0,
  }) async {
    final data = await _client
        .from(DatabaseTables.answers)
        .select('''id, body, like_count, view_count, created_at,
             author_uid,
             author:users!author_uid(uid, display_name, username, photo_url)''')
        .eq('question_id', questionId)
        .eq('is_deleted', false)
        .order('like_count', ascending: false)
        .range(offset, offset + limit - 1);

    return (data as List)
        .map((m) => CommunityReply.fromMap(m as Map<String, dynamic>))
        .toList();
  }

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
          'id, title, summary, status, github_url, created_at, '
          'owner:users!owner_uid(display_name, username), '
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

  // ─── Submit ───────────────────────────────────────────────────────────────

  Future<void> submitProject(CommunityProjectSubmission submission) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      await Future<void>.delayed(const Duration(milliseconds: 350));
      return;
    }

    await _client.from(DatabaseTables.projects).insert({
      'slug': _slugFrom(submission.name),
      'title': submission.name,
      'summary': submission.description,
      'description': submission.description,
      'status': 'pending_review',
      'owner_uid': userId,
      'github_url': submission.links.isEmpty ? null : submission.links.first,
      'created_by': userId,
      'updated_by': userId,
    });
  }

  Future<void> submitQuestion(CommunityQuestionDraft draft) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      await Future<void>.delayed(const Duration(milliseconds: 350));
      return;
    }

    await _client.from(DatabaseTables.questions).insert({
      'title': draft.title,
      'body': draft.details,
      'author_uid': userId,
      'status': 'open',
      'category': draft.category,
      'image_url': draft.imageUrl,
      'like_count': 0,
      'view_count': 0,
    });
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  String _slugFrom(String value) {
    final slug = value
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-|-$'), '');
    return slug.isEmpty ? 'community-project' : slug;
  }
}
