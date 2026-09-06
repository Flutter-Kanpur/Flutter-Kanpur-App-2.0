import 'dart:convert';

import 'package:Readme/core/network/readme_supabase.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_knp_mobile_app_v2/app/environments/env.dart';
import 'package:flutter_knp_mobile_app_v2/modules/auth/auth_constants.dart';
import 'package:flutter_knp_mobile_app_v2/utils/network_connectivity_service.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

/// Bridges Kanpur (host) auth into the embedded ReadMe Supabase project.
///
/// Sessions are not portable across Supabase projects, so we mint a ReadMe
/// session via the ReadMe `sync-session` Edge Function using the Kanpur JWT.
class ReadmeAuthBridge {
  ReadmeAuthBridge._();

  static Future<bool>? _inFlight;

  /// Ensures ReadMe has a session when the host user is signed in.
  ///
  /// Returns `true` when ReadMe has a valid session after this call.
  /// Returns `false` when sync was skipped or failed (see debug console).
  static Future<bool> ensureSignedIn({bool force = false}) {
    if (_inFlight != null) return _inFlight!;
    final future = _ensureSignedIn(force: force);
    _inFlight = future.whenComplete(() => _inFlight = null);
    return future;
  }

  static Future<bool> _ensureSignedIn({required bool force}) async {
    final online =
        await NetworkConnectivityService.instance.checkInternetConnection();
    if (!online) {
      debugPrint('ReadmeAuthBridge: device is offline — skipping sync.');
      return false;
    }

    if (!ReadmeSupabase.isBound) {
      debugPrint(
        'ReadmeAuthBridge: ReadMe Supabase client not bound. '
        'Set README_SUPABASE_URL and README_SUPABASE_ANON_KEY in .env.',
      );
      return false;
    }

    if (!force && ReadmeSupabase.client.auth.currentSession != null) {
      if (_readmeSessionMatchesHost()) {
        return true;
      }
      debugPrint(
        'ReadmeAuthBridge: ReadMe session does not match host user — re-syncing.',
      );
      await ReadmeSupabase.client.auth.signOut();
    }

    final hostSession = Supabase.instance.client.auth.currentSession;
    if (hostSession == null) {
      debugPrint('ReadmeAuthBridge: host user is not signed in — skipping sync.');
      return false;
    }

    final syncUrl = Env.readmeSyncSessionUrl.trim();
    final anonKey = Env.readmeSupabaseAnonKey.trim();
    if (syncUrl.isEmpty || anonKey.isEmpty) {
      debugPrint(
        'ReadmeAuthBridge: README_SYNC_SESSION_URL or README_SUPABASE_ANON_KEY missing.',
      );
      return false;
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
        return false;
      }

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final refreshToken = body['refresh_token'] as String?;
      if (refreshToken == null || refreshToken.isEmpty) {
        debugPrint(
          'ReadmeAuthBridge: sync-session response missing refresh_token.',
        );
        return false;
      }

      await ReadmeSupabase.client.auth.setSession(refreshToken);

      final user = ReadmeSupabase.client.auth.currentUser;
      if (user == null) {
        debugPrint('ReadmeAuthBridge: setSession completed but no ReadMe user.');
        return false;
      }

      debugPrint(
        'ReadmeAuthBridge: ReadMe session ready for ${user.email ?? user.id}',
      );
      return true;
    } catch (error, stackTrace) {
      debugPrint('ReadmeAuthBridge: ensureSignedIn failed: $error');
      debugPrint('$stackTrace');
      return false;
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

  static bool readmeSessionMatchesHost() => _readmeSessionMatchesHost();

  static bool _readmeSessionMatchesHost() {
    final host = Supabase.instance.client.auth.currentUser;
    final readme = ReadmeSupabase.client.auth.currentUser;
    if (host == null) return readme == null;
    if (readme == null) return false;

    final hostEmail = host.email?.trim().toLowerCase();
    final readmeEmail = readme.email?.trim().toLowerCase();
    if (hostEmail != null &&
        readmeEmail != null &&
        hostEmail.isNotEmpty &&
        readmeEmail.isNotEmpty) {
      return hostEmail == readmeEmail;
    }

    return host.id == readme.id;
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
