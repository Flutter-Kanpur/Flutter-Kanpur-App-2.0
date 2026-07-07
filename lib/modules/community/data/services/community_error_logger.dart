import 'package:supabase_flutter/supabase_flutter.dart';

/// Logs all community API errors and successes to the database for debugging.
class CommunityErrorLogger {
  static const String _table = 'audit_logs';
  final SupabaseClient _supabase;

  CommunityErrorLogger(this._supabase);

  /// Log a successful API call
  Future<void> logSuccess({
    required String action,
    required String entityType,
    required String? entityId,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      await _supabase.from(_table).insert({
        'action': action,
        'entity_type': entityType,
        'entity_id': entityId,
        'status': 'success',
        'metadata': metadata,
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      // Silently fail — don't block app flow if logging fails
      print('CommunityErrorLogger: Failed to log success: $e');
    }
  }

  /// Log an error from API call or state management
  Future<void> logError({
    required String action,
    required String entityType,
    required String error,
    String? stackTrace,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      await _supabase.from(_table).insert({
        'action': action,
        'entity_type': entityType,
        'status': 'error',
        'metadata': {
          'error': error,
          'stack_trace': stackTrace,
          ...?metadata,
        },
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      // Silently fail
      print('CommunityErrorLogger: Failed to log error: $e');
    }
  }

  /// Log API request details
  Future<void> logApiCall({
    required String method,
    required String endpoint,
    required int statusCode,
    String? responseBody,
    String? errorMessage,
    int? durationMs,
  }) async {
    try {
      await _supabase.from(_table).insert({
        'action': 'api_call',
        'entity_type': 'community_api',
        'status': statusCode >= 200 && statusCode < 300 ? 'success' : 'error',
        'metadata': {
          'method': method,
          'endpoint': endpoint,
          'status_code': statusCode,
          'response_body': responseBody,
          'error_message': errorMessage,
          'duration_ms': durationMs,
        },
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('CommunityErrorLogger: Failed to log API call: $e');
    }
  }
}
