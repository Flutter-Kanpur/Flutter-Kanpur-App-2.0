import 'dart:convert';

import 'package:Readme/core/network/readme_supabase.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_knp_mobile_app_v2/app/environments/env.dart';
import 'package:flutter_knp_mobile_app_v2/modules/auth/auth_constants.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

/// Bridges Kanpur (host) auth into the embedded ReadMe Supabase project.
///
/// Sessions are not portable across Supabase projects, so we mint a ReadMe
/// session via the ReadMe `sync-session` Edge Function using the Kanpur JWT.
class ReadmeAuthBridge {
  ReadmeAuthBridge._();

  static Future<void>? _inFlight;

  /// Ensures ReadMe has a session when the host user is signed in.
  ///
  /// No-op when ReadMe is already signed in, the host is a guest, or the
  /// sync URL / tokens are missing.
  static Future<void> ensureSignedIn({bool force = false}) {
    return _inFlight ??= _ensureSignedIn(force: force).whenComplete(() {
      _inFlight = null;
    });
  }

  static Future<void> _ensureSignedIn({required bool force}) async {
    if (!force && ReadmeSupabase.client.auth.currentSession != null) return;

    final hostSession = Supabase.instance.client.auth.currentSession;
    if (hostSession == null) return;

    final syncUrl = Env.readmeSyncSessionUrl.trim();
    final anonKey = Env.readmeSupabaseAnonKey.trim();
    if (syncUrl.isEmpty || anonKey.isEmpty) {
      debugPrint(
        'ReadmeAuthBridge: README_SYNC_SESSION_URL or README_SUPABASE_ANON_KEY missing.',
      );
      return;
    }

    try {
      final profilePayload = await _hostProfilePayload();

      final response = await http.post(
        Uri.parse(syncUrl),
        headers: {
          'Authorization': 'Bearer ${hostSession.accessToken}',
          'apikey': anonKey,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(profilePayload),
      );

      if (response.statusCode < 200 || response.statusCode >= 300) {
        debugPrint(
          'ReadmeAuthBridge: sync-session failed (${response.statusCode}): '
          '${response.body}',
        );
        return;
      }

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final refreshToken = body['refresh_token'] as String?;
      if (refreshToken == null || refreshToken.isEmpty) {
        debugPrint(
          'ReadmeAuthBridge: sync-session response missing refresh_token.',
        );
        return;
      }

      await ReadmeSupabase.client.auth.setSession(refreshToken);

      final user = ReadmeSupabase.client.auth.currentUser;
      debugPrint(
        'ReadmeAuthBridge: ReadMe session ready for ${user?.email ?? user?.id}',
      );
    } catch (error, stackTrace) {
      debugPrint('ReadmeAuthBridge: ensureSignedIn failed: $error');
      debugPrint('$stackTrace');
    }
  }

  /// Pulls identity fields from the host Kanpur `users` row (and auth metadata).
  static Future<Map<String, String?>> _hostProfilePayload() async {
    final authUser = Supabase.instance.client.auth.currentUser;
    final meta = authUser?.userMetadata ?? const <String, dynamic>{};

    String? name = _firstNonEmpty([
      meta['full_name'],
      meta['name'],
      meta['display_name'],
      meta['username'],
    ]);
    String? username = _firstNonEmpty([meta['username']]);
    String? avatarUrl = _firstNonEmpty([
      meta['avatar_url'],
      meta['picture'],
      meta['photo_url'],
    ]);
    String? bio = _firstNonEmpty([meta['bio']]);
    String? headline = _firstNonEmpty([meta['headline']]);

    final uid = authUser?.id;
    if (uid != null) {
      try {
        final row = await Supabase.instance.client
            .from(AuthConstants.usersTable)
            .select(
              '${AuthConstants.displayNameField}, '
              '${AuthConstants.fullNameField}, '
              '${AuthConstants.usernameField}, '
              '${AuthConstants.photoUrlField}, '
              '${AuthConstants.bioField}',
            )
            .eq(AuthConstants.uidField, uid)
            .maybeSingle();

        if (row != null) {
          name = _firstNonEmpty([
                row[AuthConstants.fullNameField],
                row[AuthConstants.displayNameField],
                row[AuthConstants.usernameField],
                name,
              ]);
          username = _firstNonEmpty([
                row[AuthConstants.usernameField],
                username,
              ]);
          avatarUrl = _firstNonEmpty([
                row[AuthConstants.photoUrlField],
                avatarUrl,
              ]);
          bio = _firstNonEmpty([row[AuthConstants.bioField], bio]);
        }
      } catch (error) {
        debugPrint('ReadmeAuthBridge: host profile lookup failed: $error');
      }
    }

    return {
      'name': name,
      'username': username,
      'avatar_url': avatarUrl,
      'bio': bio,
      'headline': headline,
    };
  }

  static String? _firstNonEmpty(List<dynamic> values) {
    for (final value in values) {
      if (value is String && value.trim().isNotEmpty) return value.trim();
    }
    return null;
  }

  /// Clears the ReadMe session when the host signs out.
  static Future<void> signOut() async {
    try {
      if (ReadmeSupabase.client.auth.currentSession == null) return;
      await ReadmeSupabase.client.auth.signOut();
    } catch (error) {
      debugPrint('ReadmeAuthBridge: signOut failed: $error');
    }
  }
}
