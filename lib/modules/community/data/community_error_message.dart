import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:flutter_knp_mobile_app_v2/modules/community/data/repositories/community_repository.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/data/services/upload_service.dart';

/// Turns a thrown error into something worth showing a user.
///
/// Schema errors in particular used to surface as a flat "Could not load",
/// which hides the single most common cause: a migration that has not been
/// applied to the Supabase project yet. PostgREST reports those as 42703
/// (undefined column) or PGRST20x (relation missing from the schema cache),
/// and no amount of retrying will clear them.
String describeCommunityError(Object? error, {required String fallback}) {
  if (error == null) return fallback;

  if (error is CommunityAuthException) return error.toString();
  if (error is UploadException) return error.message;

  if (error is StorageException) {
    if (error.message.toLowerCase().contains('bucket not found')) {
      return 'Storage bucket "${UploadService.communityBucket}" was not found '
          'in this Supabase project.';
    }
    return error.message;
  }

  if (error is PostgrestException) {
    if (isSchemaMismatch(error)) {
      return 'The app is ahead of the database. Apply the pending migration '
          '(supabase/004_community_engagement.sql), then try again.';
    }
    // 42501 = insufficient privilege, i.e. an RLS policy rejected this.
    if (error.code == '42501') {
      return 'You do not have permission to do that.';
    }
    return error.message;
  }

  if (isOffline(error)) {
    return 'You appear to be offline. Check your connection and try again.';
  }

  return fallback;
}

/// True when the failure is a missing column / table rather than bad data.
bool isSchemaMismatch(Object? error) {
  if (error is! PostgrestException) return false;
  const schemaCodes = {
    '42703', // undefined_column
    '42P01', // undefined_table
    'PGRST204', // column not found in schema cache
    'PGRST205', // relation not found in schema cache
  };
  if (schemaCodes.contains(error.code)) return true;

  final message = error.message.toLowerCase();
  return message.contains('schema cache') ||
      message.contains('does not exist') && message.contains('column');
}

/// True for transport-level failures, where a retry is actually worth offering.
bool isOffline(Object? error) {
  final text = error.toString().toLowerCase();
  return text.contains('socketexception') ||
      text.contains('failed host lookup') ||
      text.contains('network is unreachable') ||
      text.contains('connection refused') ||
      text.contains('connection closed') ||
      text.contains('timeoutexception') ||
      text.contains('clientexception');
}
