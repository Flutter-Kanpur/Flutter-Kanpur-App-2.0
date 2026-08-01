import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_knp_mobile_app_v2/modules/auth/data/services/auth_service.dart';

class AnswerService {
  final SupabaseClient _client = Supabase.instance.client;
  final AuthService _authService = AuthService();

  Future<bool> submitAnswer({
    required String questionId,
    required String body,
    String? codeSnippet,
    String? imageUrl,
  }) async {
    try {
      final currentUser = _authService.getCurrentUser();
      if (currentUser == null) throw Exception('User not authenticated');

      await _client.from('answers').insert({
        'question_id': questionId,
        'author_uid': currentUser.id,
        'body': body,
        'code_snippet': codeSnippet,
        'image_url': imageUrl,
        'like_count': 0,
        'view_count': 0,
        'created_at': DateTime.now().toIso8601String(),
      });

      return true;
    } catch (e) {
      print('❌ Error submitting answer: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getAnswersForQuestion(
    String questionId,
  ) async {
    try {
      final data = await _client
          .from('answers')
          .select('''
            id,
            question_id,
            body,
            code_snippet,
            image_url,
            author_uid,
            author:author_uid(id, display_name, username, photo_url),
            like_count,
            view_count,
            created_at,
            updated_at
          ''')
          .eq('question_id', questionId)
          .eq('is_deleted', false)
          .order('like_count', ascending: false)
          .order('created_at', ascending: false);

      print('✅ Fetched ${(data as List).length} answers');
      return List<Map<String, dynamic>>.from(data as List);
    } catch (e) {
      print('❌ Error fetching answers: $e');
      rethrow;
    }
  }

  Future<bool> likeAnswer({required String answerId}) async {
    try {
      final currentUser = _authService.getCurrentUser();
      if (currentUser == null) throw Exception('User not authenticated');

      // Check if already liked
      final existing = await _client
          .from('answer_likes')
          .select()
          .eq('answer_id', answerId)
          .eq('user_id', currentUser.id);

      if ((existing as List).isNotEmpty) {
        print('⚠️ Already liked this answer');
        return false;
      }

      // Insert like
      await _client.from('answer_likes').insert({
        'answer_id': answerId,
        'user_id': currentUser.id,
        'created_at': DateTime.now().toIso8601String(),
      });

      // Increment like count
      await _client.rpc(
        'increment_answer_likes',
        params: {'answer_id': answerId},
      );

      print('✅ Answer liked successfully');
      return true;
    } catch (e) {
      print('❌ Error liking answer: $e');
      rethrow;
    }
  }

  Future<bool> unlikeAnswer({required String answerId}) async {
    try {
      final currentUser = _authService.getCurrentUser();
      if (currentUser == null) throw Exception('User not authenticated');

      await _client
          .from('answer_likes')
          .delete()
          .eq('answer_id', answerId)
          .eq('user_id', currentUser.id);

      // Decrement like count
      await _client.rpc(
        'decrement_answer_likes',
        params: {'answer_id': answerId},
      );

      print('✅ Answer unliked successfully');
      return true;
    } catch (e) {
      print('❌ Error unliking answer: $e');
      rethrow;
    }
  }

  Future<bool> deleteAnswer(String answerId) async {
    try {
      final currentUser = _authService.getCurrentUser();
      if (currentUser == null) throw Exception('User not authenticated');

      // Soft delete - mark as deleted
      await _client
          .from('answers')
          .update({'is_deleted': true})
          .eq('id', answerId)
          .eq('author_uid', currentUser.id);

      print('✅ Answer deleted successfully');
      return true;
    } catch (e) {
      print('❌ Error deleting answer: $e');
      rethrow;
    }
  }

  Future<bool> updateAnswer({
    required String answerId,
    required String body,
    String? codeSnippet,
    String? imageUrl,
  }) async {
    try {
      final currentUser = _authService.getCurrentUser();
      if (currentUser == null) throw Exception('User not authenticated');

      await _client
          .from('answers')
          .update({
            'body': body,
            'code_snippet': codeSnippet,
            'image_url': imageUrl,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', answerId)
          .eq('author_uid', currentUser.id);

      print('✅ Answer updated successfully');
      return true;
    } catch (e) {
      print('❌ Error updating answer: $e');
      rethrow;
    }
  }

  Future<bool> checkIfUserLikedAnswer({required String answerId}) async {
    try {
      final currentUser = _authService.getCurrentUser();
      if (currentUser == null) return false;

      final data = await _client
          .from('answer_likes')
          .select()
          .eq('answer_id', answerId)
          .eq('user_id', currentUser.id);

      return (data as List).isNotEmpty;
    } catch (e) {
      print('❌ Error checking like status: $e');
      return false;
    }
  }
}
