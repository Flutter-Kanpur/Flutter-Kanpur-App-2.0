import 'package:flutter_knp_mobile_app_v2/core/database/database_tables.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/data/models/community_request.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/domain/community_models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// API service for community data — handles all REST calls to Supabase.
/// All methods return proper Dart models ready for Riverpod state management.
class CommunityApiService {
  final SupabaseClient _supabase;

  CommunityApiService(this._supabase);

  // ── Questions ────────────────────────────────────────────────────────────

  /// Fetch all questions with optional filtering by status or answer count.
  /// Returns up to [limit] questions, offset by [offset].
  Future<List<CommunityQuestion>> getQuestions({
    String? filter,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      var query = _supabase
          .from(DatabaseTables.questions)
          .select(
            'id, title, body, status, answer_count, created_at, '
            'author:users!author_uid(display_name, username, photo_url)',
          )
          .eq('is_deleted', false);

      // Apply optional filters
      if (filter == 'unanswered') {
        query = query.eq('answer_count', 0);
      } else if (filter == 'active') {
        query = query.eq('status', 'open');
      }

      final data = await query
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      return (data as List<dynamic>)
          .map((m) => CommunityQuestion.fromMap(m as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      throw 'Failed to fetch questions: ${e.message}';
    } catch (e) {
      throw 'Unexpected error fetching questions: $e';
    }
  }

  /// Fetch a single question by ID with author details.
  Future<CommunityQuestion?> getQuestion(String questionId) async {
    try {
      final response = await _supabase
          .from(DatabaseTables.questions)
          .select(
            'id, title, body, status, answer_count, created_at, '
            'author:users!author_uid(display_name, username, photo_url)',
          )
          .eq('id', questionId)
          .eq('is_deleted', false)
          .maybeSingle();

      if (response == null) return null;
      return CommunityQuestion.fromMap(response as Map<String, dynamic>);
    } catch (e) {
      throw 'Failed to fetch question: $e';
    }
  }

  /// Create a new question. Requires authenticated user.
  /// Returns the newly created question with author details.
  Future<CommunityQuestion> createQuestion(CreateQuestionRequest request) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw 'User not authenticated';

      final response = await _supabase
          .from(DatabaseTables.questions)
          .insert({
            'title': request.title,
            'body': request.body,
            'author_uid': userId,
            'status': 'open',
          })
          .select(
            'id, title, body, status, answer_count, created_at, '
            'author:users!author_uid(display_name, username, photo_url)',
          )
          .single();

      return CommunityQuestion.fromMap(response as Map<String, dynamic>);
    } on PostgrestException catch (e) {
      throw 'Database error: ${e.message}';
    } catch (e) {
      throw 'Failed to create question: $e';
    }
  }

  // ── Answers ──────────────────────────────────────────────────────────────

  /// Fetch all answers for a specific question, ordered by acceptance status.
  Future<List<CommunityReply>> getAnswers(
    String questionId, {
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final data = await _supabase
          .from(DatabaseTables.answers)
          .select(
            'id, body, created_at, is_accepted, is_deleted, '
            'author:users!author_uid(display_name, username, photo_url)',
          )
          .eq('question_id', questionId)
          .eq('is_deleted', false)
          .order('is_accepted', ascending: false)
          .order('created_at', ascending: true)
          .range(offset, offset + limit - 1);

      return (data as List<dynamic>)
          .map((m) => CommunityReply.fromMap(m as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw 'Failed to fetch answers: $e';
    }
  }

  /// Create a new answer to a question. Requires authenticated user.
  Future<CommunityReply> createAnswer(CreateAnswerRequest request) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw 'User not authenticated';

      final response = await _supabase
          .from(DatabaseTables.answers)
          .insert({
            'question_id': request.questionId,
            'author_uid': userId,
            'body': request.body,
          })
          .select(
            'id, body, created_at, is_accepted, '
            'author:users!author_uid(display_name, username, photo_url)',
          )
          .single();

      return CommunityReply.fromMap(response as Map<String, dynamic>);
    } on PostgrestException catch (e) {
      throw 'Database error: ${e.message}';
    } catch (e) {
      throw 'Failed to create answer: $e';
    }
  }

  // ── Projects ─────────────────────────────────────────────────────────────

  /// Fetch all published community projects.
  Future<List<CommunityProject>> getProjects({
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final data = await _supabase
          .from(DatabaseTables.projects)
          .select(
            'id, title, summary, status, github_url, created_at, '
            'owner:users!owner_uid(display_name, username), '
            'project_tech_stack(tech_name)',
          )
          .eq('is_deleted', false)
          .neq('status', 'draft')
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      return (data as List<dynamic>)
          .map((m) => CommunityProject.fromMap(m as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw 'Failed to fetch projects: $e';
    }
  }

  /// Create a new project. Requires authenticated user.
  /// Tech stack items are inserted separately after project creation.
  Future<CommunityProject> createProject(CreateProjectRequest request) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw 'User not authenticated';

      final response = await _supabase
          .from(DatabaseTables.projects)
          .insert({
            'title': request.title,
            'summary': request.summary,
            'description': request.description,
            'owner_uid': userId,
            'github_url': request.githubUrl,
            'live_url': request.liveUrl,
            'status': 'draft',
          })
          .select(
            'id, title, summary, status, github_url, created_at, '
            'owner:users!owner_uid(display_name, username), '
            'project_tech_stack(tech_name)',
          )
          .single();

      final project =
          CommunityProject.fromMap(response as Map<String, dynamic>);

      // Insert tech stack items if provided
      if (request.techStack != null && request.techStack!.isNotEmpty) {
        await _supabase.from(DatabaseTables.projectTechStack).insert(
          request.techStack!
              .map((tech) => {
                    'project_id': project.id,
                    'tech_name': tech,
                  })
              .toList(),
        );
      }

      return project;
    } on PostgrestException catch (e) {
      throw 'Database error: ${e.message}';
    } catch (e) {
      throw 'Failed to create project: $e';
    }
  }

  // ── Community Members ────────────────────────────────────────────────────

  /// Fetch all active/approved community members with their skills.
  Future<List<CommunityMember>> getMembers({
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final data = await _supabase
          .from(DatabaseTables.communityMemberships)
          .select(
            'role, membership_status, joined_at, '
            'member:users!user_uid(display_name, username, photo_url, user_skills(skill_name))',
          )
          .eq('membership_status', 'approved')
          .order('joined_at', ascending: false)
          .range(offset, offset + limit - 1);

      return (data as List<dynamic>)
          .map((m) => CommunityMember.fromMap(m as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw 'Failed to fetch members: $e';
    }
  }

  // ── Auth Helpers ─────────────────────────────────────────────────────────

  /// Get the current authenticated user's ID, or null if not authenticated.
  String? getCurrentUserId() => _supabase.auth.currentUser?.id;

  /// Check if a user is currently authenticated.
  bool isAuthenticated() => _supabase.auth.currentUser != null;
}
