import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:device_info_plus/device_info_plus.dart';

class UserService {
  final SupabaseClient _client;
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  UserService({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  // ─── Get Current User ────────────────────────────────────────────────

  Future<Map<String, dynamic>?> getCurrentUserProfile() async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) return null;

      print('👤 [UserService] Fetching profile for: ${user.email}');

      final data = await _client
          .from('users')
          .select()
          .eq('uid', user.id)
          .single();

      print('✅ [UserService] Profile loaded: ${user.email}');
      return data;
    } catch (e) {
      print('❌ [UserService] Error fetching profile: $e');
      return null;
    }
  }

  Future<bool> isOnboardingCompleted() async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) return false;

      final data = await _client
          .from('users')
          .select('onboarding_completed')
          .eq('uid', user.id)
          .maybeSingle();

      return data?['onboarding_completed'] == true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> markOnboardingCompleted() async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) return false;

      await _client
          .from('users')
          .update({
            'onboarding_completed': true,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('uid', user.id);

      return true;
    } catch (_) {
      return false;
    }
  }

  // ─── Save User Profile ───────────────────────────────────────────────

  Future<bool> saveUserProfile({
    required String displayName,
    required String username,
    String? photoUrl,
  }) async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) {
        print('❌ [UserService] No authenticated user');
        return false;
      }

      print('💾 [UserService] Saving profile: $displayName');

      await _client.from('users').upsert({
        'uid': user.id,
        'email': user.email,
        'display_name': displayName,
        'username': username,
        'photo_url': photoUrl,
        'updated_at': DateTime.now().toIso8601String(),
      }, onConflict: 'uid');

      print('✅ [UserService] Profile saved');
      return true;
    } catch (e) {
      print('❌ [UserService] Error saving profile: $e');
      return false;
    }
  }

  // ─── Track Device ────────────────────────────────────────────────────

  Future<bool> trackDevice() async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) {
        print('❌ [UserService] No authenticated user for device tracking');
        return false;
      }

      print('📱 [UserService] Tracking device for: ${user.email}');

      final deviceId = await _getDeviceId();
      final deviceInfo = await _getDeviceInfo();

      await _client.from('user_devices').upsert({
        'user_uid': user.id,
        'device_id': deviceId,
        'device_name': deviceInfo['deviceName'],
        'device_os': deviceInfo['deviceOs'],
        'device_model': deviceInfo['deviceModel'],
        'last_login': DateTime.now().toIso8601String(),
      }, onConflict: 'device_id');

      print('✅ [UserService] Device tracked: $deviceId');
      return true;
    } catch (e) {
      print('❌ [UserService] Error tracking device: $e');
      return false;
    }
  }

  // ─── Get Device Info ─────────────────────────────────────────────────

  Future<String> _getDeviceId() async {
    try {
      final info = _deviceInfo;
      // Generate a unique device ID based on device info
      final androidInfo = await info.androidInfo;
      return androidInfo.id; // Unique device ID
    } catch (e) {
      print('❌ [UserService] Error getting device ID: $e');
      return 'unknown_device_${DateTime.now().millisecondsSinceEpoch}';
    }
  }

  Future<Map<String, String>> _getDeviceInfo() async {
    try {
      final info = _deviceInfo;
      final androidInfo = await info.androidInfo;

      return {
        'deviceName': androidInfo.host,
        'deviceOs': androidInfo.version.release,
        'deviceModel': androidInfo.model,
      };
    } catch (e) {
      print('❌ [UserService] Error getting device info: $e');
      return {
        'deviceName': 'Unknown Device',
        'deviceOs': 'Unknown OS',
        'deviceModel': 'Unknown Model',
      };
    }
  }

  // ─── Logout (Cleanup) ────────────────────────────────────────────────

  Future<bool> logout() async {
    try {
      final user = _client.auth.currentUser;
      if (user != null) {
        print('🔐 [UserService] Logging out: ${user.email}');
      }
      return true;
    } catch (e) {
      print('❌ [UserService] Error during logout: $e');
      return false;
    }
  }

  // ─── Clear User Data (On Logout) ─────────────────────────────────────

  Future<void> clearUserData() async {
    try {
      print('🗑️  [UserService] Clearing user data...');
      // Services will be cleared by Riverpod invalidation
      // This is just for logging
      print('✅ [UserService] User data cleared');
    } catch (e) {
      print('❌ [UserService] Error clearing data: $e');
    }
  }

  // ─── Get User Devices ────────────────────────────────────────────────

  Future<List<Map<String, dynamic>>> getUserDevices() async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) return [];

      print('📱 [UserService] Fetching devices for: ${user.email}');

      final data = await _client
          .from('user_devices')
          .select()
          .eq('user_uid', user.id);

      print('✅ [UserService] Devices loaded: ${data.length}');
      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      print('❌ [UserService] Error fetching devices: $e');
      return [];
    }
  }
}
