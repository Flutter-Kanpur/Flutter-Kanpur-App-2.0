import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:flutter_knp_mobile_app_v2/core/database/database_tables.dart';
import 'package:flutter_knp_mobile_app_v2/modules/profile/domain/profile_models.dart';

class ProfileRepository {
  ProfileRepository({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;
  static const _avatarBucket = 'avatars';

  Future<ProfileUser?> fetchMyProfile() async {
    final user = _client.auth.currentUser;
    if (user == null) return null;

    final data = await _client
        .from(DatabaseTables.users)
        .select('*, ${DatabaseTables.userSkills}(skill_name)')
        .eq('uid', user.id)
        .maybeSingle();

    if (data == null) {
      return _profileFromAuthUser(user);
    }

    final profile = ProfileUser.fromMap(data);

    if (!_rowMatchesAuthUser(profile, user)) {
      return _profileFromAuthUser(user);
    }

    return _mergeWithAuthUser(profile, user);
  }

  Future<ProfileUser?> fetchProfileForUid(String uid) async {
    final sessionUid = _client.auth.currentUser?.id;
    final effectiveUid = sessionUid ?? uid;

    final data = await _client
        .from(DatabaseTables.users)
        .select('*, ${DatabaseTables.userSkills}(skill_name)')
        .eq('uid', effectiveUid)
        .maybeSingle();

    if (data == null) {
      final user = _client.auth.currentUser;
      if (user != null && user.id == effectiveUid) {
        return _profileFromAuthUser(user);
      }
      return null;
    }

    final profile = ProfileUser.fromMap(data);
    final user = _client.auth.currentUser;
    if (user != null && user.id == effectiveUid) {
      if (!_rowMatchesAuthUser(profile, user)) {
        return _profileFromAuthUser(user);
      }
      return _mergeWithAuthUser(profile, user);
    }

    return profile;
  }

  bool _rowMatchesAuthUser(ProfileUser profile, User user) {
    if (profile.uid.isNotEmpty && profile.uid != user.id) return false;

    final authEmail = user.email?.trim().toLowerCase();
    final rowEmail = profile.email.trim().toLowerCase();
    if (authEmail == null || authEmail.isEmpty) return true;
    if (rowEmail.isEmpty) return true;
    return authEmail == rowEmail;
  }

  ProfileUser _profileFromAuthUser(User user) {
    final meta = user.userMetadata ?? const <String, dynamic>{};
    return ProfileUser(
      uid: user.id,
      email: user.email ?? '',
      displayName: _firstNonEmpty([
        meta['display_name'],
        meta['name'],
        meta['full_name'],
      ]),
      fullName: _firstNonEmpty([meta['full_name'], meta['name']]),
      username: meta['username'] as String?,
      photoUrl: _firstNonEmpty([
        meta['avatar_url'],
        meta['picture'],
        meta['photo_url'],
      ]),
      skills: const [],
    );
  }

  ProfileUser _mergeWithAuthUser(ProfileUser profile, User user) {
    final meta = user.userMetadata ?? const <String, dynamic>{};
    return ProfileUser(
      uid: user.id,
      email: user.email ?? profile.email,
      displayName: _firstNonEmpty([
        meta['display_name'],
        meta['name'],
        meta['full_name'],
        profile.displayName,
        profile.fullName,
      ]),
      fullName: _firstNonEmpty([
        meta['full_name'],
        meta['name'],
        profile.fullName,
      ]),
      username: _firstNonEmpty([profile.username, meta['username']]),
      photoUrl: _firstNonEmpty([
        profile.photoUrl,
        meta['avatar_url'],
        meta['picture'],
        meta['photo_url'],
      ]),
      bio: profile.bio,
      githubUrl: profile.githubUrl,
      linkedinUrl: profile.linkedinUrl,
      websiteUrl: profile.websiteUrl,
      yearsOfExperience: profile.yearsOfExperience,
      skills: profile.skills,
    );
  }

  String? _firstNonEmpty(List<dynamic> values) {
    for (final value in values) {
      if (value is String && value.trim().isNotEmpty) return value.trim();
    }
    return null;
  }

  Future<void> updateProfileDetails(
    ProfileDraft draft, {
    required ProfileUser? current,
    String? localPhotoPath,
    bool removePhoto = false,
  }) async {
    final user = _requireUser();
    final username = draft.username?.trim();

    final values = <String, dynamic>{
      ..._identity(user, isNewRow: current == null),
      'username': username,
      'bio': draft.bio,
      'github_url': draft.githubUrl,
      'linkedin_url': draft.linkedinUrl,
      'website_url': draft.websiteUrl,
      'years_of_experience': draft.yearsOfExperience,
      'updated_at': DateTime.now().toIso8601String(),
    };

    final hasDisplayName = (current?.displayName?.trim().isNotEmpty) ?? false;
    if (!hasDisplayName && username != null && username.isNotEmpty) {
      values['display_name'] = username;
    }

    if (removePhoto) {
      await _removeStoredAvatar(user.id);
      values['photo_url'] = null;
    } else if (localPhotoPath != null && localPhotoPath.trim().isNotEmpty) {
      final photoUrl = await uploadAvatar(user.id, localPhotoPath);
      if (photoUrl != null) {
        values['photo_url'] = photoUrl;
      }
    }

    await _client.from(DatabaseTables.users).upsert(values, onConflict: 'uid');
  }

  /// Uploads a local image to Supabase Storage and returns its public URL.
  Future<String?> uploadAvatar(String uid, String localPath) async {
    final file = File(localPath);
    if (!await file.exists()) return null;

    const storagePath = 'avatar.jpg';
    final bytes = await file.readAsBytes();

    await _client.storage.from(_avatarBucket).uploadBinary(
          '$uid/$storagePath',
          bytes,
          fileOptions: const FileOptions(
            upsert: true,
            contentType: 'image/jpeg',
          ),
        );

    final baseUrl =
        _client.storage.from(_avatarBucket).getPublicUrl('$uid/$storagePath');
    return '$baseUrl?v=${DateTime.now().millisecondsSinceEpoch}';
  }

  Future<void> _removeStoredAvatar(String uid) async {
    try {
      await _client.storage.from(_avatarBucket).remove(['$uid/avatar.jpg']);
    } catch (_) {
      // Storage cleanup is best-effort; the DB row is the source of truth.
    }
  }

  Future<void> updateSkillsAndExperience({
    required List<String> skills,
    required int yearsOfExperience,
    required ProfileUser? current,
  }) async {
    final user = _requireUser();

    await _client.from(DatabaseTables.users).upsert({
      ..._identity(user, isNewRow: current == null),
      'years_of_experience': yearsOfExperience,
      'updated_at': DateTime.now().toIso8601String(),
    }, onConflict: 'uid');

    await _replaceSkills(user.id, skills);
  }

  Future<void> _replaceSkills(String uid, List<String> skills) async {
    await _client.from(DatabaseTables.userSkills).delete().eq('user_uid', uid);

    final unique = <String>{
      for (final skill in skills)
        if (skill.trim().isNotEmpty) skill.trim(),
    };
    if (unique.isEmpty) return;

    await _client.from(DatabaseTables.userSkills).insert([
      for (final skill in unique) {'user_uid': uid, 'skill_name': skill},
    ]);
  }

  User _requireUser() {
    final user = _client.auth.currentUser;
    if (user == null) throw StateError('Not signed in');
    return user;
  }

  Map<String, dynamic> _identity(User user, {required bool isNewRow}) => {
    'uid': user.id,
    if (user.email != null) 'email': user.email,
    if (isNewRow) 'created_at': DateTime.now().toIso8601String(),
  };
}
