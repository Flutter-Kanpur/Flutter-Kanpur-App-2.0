import 'package:flutter_knp_mobile_app_v2/core/database/database_tables.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/contributor_application_draft.dart';

class ContributorRepository {
  ContributorRepository({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;
  static const String _tableName = 'contributor_applications';

  /// Submits a new contributor application for the currently authenticated user.
  Future<void> submitApplication(ContributorApplicationDraft draft) async {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw const AuthException('You must be logged in to submit an application.');
    }

    final payload = draft.toSupabaseMap(user.id);
    await _client.from(_tableName).insert(payload);
  }

  /// Fetches the latest application submitted by the currently authenticated user.
  /// Returns null if the user has not submitted an application yet.
  Future<Map<String, dynamic>?> fetchMyApplication() async {
    final user = _client.auth.currentUser;
    if (user == null) return null;

    final data = await _client
        .from(_tableName)
        .select()
        .eq('user_uid', user.id)
        .order('created_at', ascending: false)
        .limit(1)
        .maybeSingle();

    return data;
  }

  /// Fetches active membership if user is already an active community member.
  Future<Map<String, dynamic>?> fetchMyMembership() async {
    final user = _client.auth.currentUser;
    if (user == null) return null;

    try {
      final data = await _client
          .from(DatabaseTables.communityMemberships)
          .select()
          .eq('user_uid', user.id)
          .eq('membership_status', 'active')
          .maybeSingle();

      return data;
    } catch (_) {
      return null;
    }
  }

  /// Fetches projects owned or contributed to by the authenticated user.
  Future<List<Map<String, dynamic>>> fetchMyProjects() async {
    final user = _client.auth.currentUser;
    if (user == null) return [];

    try {
      final data = await _client
          .from(DatabaseTables.projects)
          .select('id, title, summary, status, created_at')
          .eq('owner_uid', user.id)
          .eq('is_deleted', false)
          .order('created_at', ascending: false)
          .limit(5);

      return (data as List<dynamic>).cast<Map<String, dynamic>>();
    } catch (_) {
      return [];
    }
  }
}

