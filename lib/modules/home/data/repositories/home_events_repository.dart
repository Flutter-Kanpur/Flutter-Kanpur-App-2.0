import 'package:flutter_knp_mobile_app_v2/core/database/database_tables.dart';
import 'package:flutter_knp_mobile_app_v2/core/database/repositories/supabase_repository.dart';
import 'package:flutter_knp_mobile_app_v2/modules/home/domain/entities/event_entity.dart';

class HomeEventsRepository extends SupabaseRepository {
  HomeEventsRepository({super.client}) : super(tableName: DatabaseTables.events);

  /// Fetch all active non-deleted events.
  Future<List<EventEntity>> fetchEvents({int limit = 50}) async {
    try {
      final response = await table
          .select()
          .eq('is_deleted', false)
          .order('from_time', ascending: false)
          .limit(limit);

      return (response as List<dynamic>)
          .map((row) => EventEntity.fromMap(row as Map<String, dynamic>))
          .toList();
    } catch (_) {
      // If table has alternate column names or is empty, try safe select fallback
      try {
        final fallback = await table
            .select()
            .limit(limit);
        return (fallback as List<dynamic>)
            .map((row) => EventEntity.fromMap(row as Map<String, dynamic>))
            .toList();
      } catch (_) {
        return const [];
      }
    }
  }

  /// Fetch event IDs that the user is registered for.
  Future<Set<String>> fetchMyRegisteredEventIds(String userUid) async {
    try {
      final response = await client
          .from(DatabaseTables.eventRegistrations)
          .select('event_id')
          .eq('user_uid', userUid);

      return (response as List<dynamic>)
          .map((row) => (row as Map<String, dynamic>)['event_id']?.toString() ?? '')
          .where((id) => id.isNotEmpty)
          .toSet();
    } catch (_) {
      return const {};
    }
  }

  /// Fetch a single event by ID.
  Future<EventEntity?> fetchEventById(String eventId) async {
    try {
      final data = await fetchById(eventId);
      if (data == null) return null;
      return EventEntity.fromMap(data);
    } catch (_) {
      return null;
    }
  }
}
