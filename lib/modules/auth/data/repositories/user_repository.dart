import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/api_response.dart';
import '../../domain/models/user_model.dart';

class UserRepository {
  final _supabase = Supabase.instance.client;

  /// Get current user from Supabase `users` table
  /// GET /users/{uid}
  Future<ApiResponse<UserModel>> getCurrentUser(String uid) async {
    try {
      final response = await _supabase
          .from('users')
          .select()
          .eq('uid', uid)
          .single();

      final user = UserModel.fromJson(response as Map<String, dynamic>);
      return ApiResponse<UserModel>.success(user);
    } on PostgrestException catch (e) {
      return ApiResponse<UserModel>.error(
        statusCode: e.code ?? '500',
        message: e.message,
      );
    } catch (e) {
      return ApiResponse<UserModel>.error(message: e.toString());
    }
  }

  /// Create user in Supabase `users` table
  /// POST /users
  Future<ApiResponse<UserModel>> createUser({
    required String uid,
    required String email,
    String? displayName,
    String? fullName,
  }) async {
    try {
      final now = DateTime.now().toIso8601String();
      final response = await _supabase
          .from('users')
          .insert({
            'uid': uid,
            'email': email,
            'display_name': displayName,
            'full_name': fullName,
            'status': 'active',
            'created_at': now,
            'updated_at': now,
          })
          .select()
          .single();

      final user = UserModel.fromJson(response as Map<String, dynamic>);
      return ApiResponse<UserModel>.success(user);
    } on PostgrestException catch (e) {
      return ApiResponse<UserModel>.error(
        statusCode: e.code ?? '500',
        message: e.message,
      );
    } catch (e) {
      return ApiResponse<UserModel>.error(message: e.toString());
    }
  }

  /// Update user in Supabase `users` table
  /// PUT /users/{uid}
  Future<ApiResponse<UserModel>> updateUser({
    required String uid,
    String? displayName,
    String? fullName,
    String? username,
    String? photoUrl,
    String? bio,
    String? githubUrl,
    String? linkedinUrl,
    String? websiteUrl,
    int? yearsOfExperience,
  }) async {
    try {
      final data = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (displayName != null) data['display_name'] = displayName;
      if (fullName != null) data['full_name'] = fullName;
      if (username != null) data['username'] = username;
      if (photoUrl != null) data['photo_url'] = photoUrl;
      if (bio != null) data['bio'] = bio;
      if (githubUrl != null) data['github_url'] = githubUrl;
      if (linkedinUrl != null) data['linkedin_url'] = linkedinUrl;
      if (websiteUrl != null) data['website_url'] = websiteUrl;
      if (yearsOfExperience != null) {
        data['years_of_experience'] = yearsOfExperience;
      }

      final response = await _supabase
          .from('users')
          .update(data)
          .eq('uid', uid)
          .select()
          .single();

      final user = UserModel.fromJson(response as Map<String, dynamic>);
      return ApiResponse<UserModel>.success(user);
    } on PostgrestException catch (e) {
      return ApiResponse<UserModel>.error(
        statusCode: e.code ?? '500',
        message: e.message,
      );
    } catch (e) {
      return ApiResponse<UserModel>.error(message: e.toString());
    }
  }

  /// Update last login timestamp
  /// PATCH /users/{uid}/last-login
  Future<ApiResponse<void>> updateLastLogin(String uid) async {
    try {
      await _supabase
          .from('users')
          .update({'last_login_at': DateTime.now().toIso8601String()})
          .eq('uid', uid);

      return ApiResponse<void>.success(null);
    } on PostgrestException catch (e) {
      return ApiResponse<void>.error(
        statusCode: e.code ?? '500',
        message: e.message,
      );
    } catch (e) {
      return ApiResponse<void>.error(message: e.toString());
    }
  }

  /// Delete user data (not auth)
  /// DELETE /users/{uid}
  Future<ApiResponse<void>> deleteUser(String uid) async {
    try {
      await _supabase.from('users').delete().eq('uid', uid);
      return ApiResponse<void>.success(null);
    } on PostgrestException catch (e) {
      return ApiResponse<void>.error(
        statusCode: e.code ?? '500',
        message: e.message,
      );
    } catch (e) {
      return ApiResponse<void>.error(message: e.toString());
    }
  }

  /// Check if username exists
  /// GET /users/username/{username}
  Future<bool> usernameExists(String username) async {
    try {
      final response = await _supabase
          .from('users')
          .select('uid')
          .eq('username', username)
          .maybeSingle();

      return response != null;
    } catch (e) {
      return false;
    }
  }
}
