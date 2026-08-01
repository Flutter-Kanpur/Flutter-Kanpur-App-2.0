import 'dart:io';

import 'package:flutter_knp_mobile_app_v2/modules/auth/auth_constants.dart';
import 'package:flutter_knp_mobile_app_v2/modules/onboarding/domain/onboarding_draft.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Persists completed onboarding data to Supabase.
/// Call only from the last-screen Finish action — not while drafting mid-flow.
class OnboardingService {
  OnboardingService({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  static const _avatarBucket = 'avatars';

  Future<void> submit(OnboardingDraft draft) async {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw Exception('No authenticated user');
    }

    String? photoUrl;
    final localPath = draft.localPhotoPath;
    if (localPath != null && localPath.isNotEmpty) {
      photoUrl = await _uploadAvatar(user.id, localPath);
    }

    final updateData = <String, dynamic>{
      AuthConstants.fullNameField: draft.fullName.trim(),
      AuthConstants.displayNameField: draft.fullName.trim(),
      AuthConstants.githubUrlField: draft.githubUrl.trim().isEmpty
          ? null
          : draft.githubUrl.trim(),
      AuthConstants.linkedinUrlField: draft.linkedinUrl.trim().isEmpty
          ? null
          : draft.linkedinUrl.trim(),
      AuthConstants.websiteUrlField: draft.websiteUrl.trim().isEmpty
          ? null
          : draft.websiteUrl.trim(),
      AuthConstants.onboardingCompletedField: true,
      AuthConstants.updatedAtField: DateTime.now().toIso8601String(),
    };

    if (draft.yearsOfExperience != null) {
      updateData[AuthConstants.yoeField] = draft.yearsOfExperience;
    }
    if (photoUrl != null) {
      updateData[AuthConstants.photoUrlField] = photoUrl;
    }

    await _client
        .from(AuthConstants.usersTable)
        .update(updateData)
        .eq(AuthConstants.uidField, user.id);

    await _syncSkills(user.id, draft.selectedSkills);
  }

  Future<String?> _uploadAvatar(String uid, String localPath) async {
    final file = File(localPath);
    if (!await file.exists()) return null;

    final path = '$uid/avatar.jpg';
    final bytes = await file.readAsBytes();

    await _client.storage
        .from(_avatarBucket)
        .uploadBinary(
          path,
          bytes,
          fileOptions: const FileOptions(
            upsert: true,
            contentType: 'image/jpeg',
          ),
        );

    return _client.storage.from(_avatarBucket).getPublicUrl(path);
  }

  Future<void> _syncSkills(String uid, List<String> skills) async {
    if (skills.isEmpty) return;

    try {
      await _client.from('user_skills').delete().eq('user_uid', uid);

      final rows = skills
          .map((skill) => {'user_uid': uid, 'skill_name': skill})
          .toList();

      await _client.from('user_skills').insert(rows);
    } catch (_) {
      // Skills table may differ by environment — profile update still succeeds.
    }
  }
}
