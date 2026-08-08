import 'package:supabase_flutter/supabase_flutter.dart';

class DeviceService {
  final SupabaseClient _supabase;

  DeviceService(this._supabase);

  /// Save device info and FCM token
  Future<void> saveDeviceInfo({
    required String fcmToken,
    required String platform,
    String? appVersion,
  }) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return;

      // Check if device already registered
      final existing = await _supabase
          .from('user_devices')
          .select()
          .eq('user_uid', userId)
          .eq('platform', platform)
          .maybeSingle();

      if (existing != null) {
        // Update existing device
        await _supabase
            .from('user_devices')
            .update({
              'fcm_token': fcmToken,
              'active': true,
              'updated_at': DateTime.now().toIso8601String(),
            })
            .eq('id', existing['id']);
      } else {
        // Insert new device
        await _supabase.from('user_devices').insert({
          'user_uid': userId,
          'fcm_token': fcmToken,
          'platform': platform,
          'active': true,
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        });
      }
    } catch (e) {
      print('[DeviceService] Error saving device info: $e');
    }
  }

  /// Log user login time
  Future<void> logLoginTime() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return;

      await _supabase
          .from('users')
          .update({'last_login_at': DateTime.now().toIso8601String()})
          .eq('uid', userId);
    } catch (e) {
      print('[DeviceService] Error logging login: $e');
    }
  }

  /// Mark device as inactive
  Future<void> deactivateDevice() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return;

      await _supabase
          .from('user_devices')
          .update({'active': false})
          .eq('user_uid', userId);
    } catch (e) {
      print('[DeviceService] Error deactivating device: $e');
    }
  }
}
