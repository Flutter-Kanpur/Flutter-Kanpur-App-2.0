import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:flutter_knp_mobile_app_v2/core/database/database_tables.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/domain/app_notification.dart';

final notificationsProvider =
    AsyncNotifierProvider<NotificationsNotifier, List<AppNotification>>(
      NotificationsNotifier.new,
    );

class NotificationsNotifier extends AsyncNotifier<List<AppNotification>> {
  SupabaseClient get _client => Supabase.instance.client;

  @override
  Future<List<AppNotification>> build() => _fetch();

  Future<List<AppNotification>> _fetch() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return const [];

    final data =
        await _client
                .from(DatabaseTables.notifications)
                .select('id, module, title, body, read_at, created_at')
                .eq('user_uid', userId)
                .order('created_at', ascending: false)
                .limit(50)
            as List<dynamic>;

    return data
        .map((m) => AppNotification.fromMap(m as Map<String, dynamic>))
        .toList();
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(_fetch);
  }

  Future<void> markAllRead() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return;

    await _client
        .from(DatabaseTables.notifications)
        .update({'read_at': DateTime.now().toUtc().toIso8601String()})
        .eq('user_uid', userId)
        .isFilter('read_at', null);

    await refresh();
  }
}

/// Unread badge count for the community app bar bell.
final unreadNotificationCountProvider = Provider<int>((ref) {
  return ref
      .watch(notificationsProvider)
      .maybeWhen(
        data: (items) => items.where((n) => !n.isRead).length,
        orElse: () => 0,
      );
});
