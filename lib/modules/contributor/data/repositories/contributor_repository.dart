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
}
