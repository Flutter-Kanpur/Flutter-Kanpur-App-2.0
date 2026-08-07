import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:flutter_knp_mobile_app_v2/core/database/database_tables.dart';
import 'package:flutter_knp_mobile_app_v2/modules/profile/domain/profile_models.dart';
class ProfileRepository {
  ProfileRepository({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;
 Future<ProfileUser?> fetchMyProfile() async {
    final uid = _client.auth.currentUser?.id;
    if (uid == null) return null;

    final data = await _client
        .from(DatabaseTables.users)
        .select('*, ${DatabaseTables.userSkills}(skill_name)')
        .eq('uid', uid)
        .maybeSingle();

    if (data == null) return null;
    return ProfileUser.fromMap(data);
  }


  Future<void> updateProfileDetails(
    ProfileDraft draft, {
    required ProfileUser? current,
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

    await _client.from(DatabaseTables.users).upsert(values, onConflict: 'uid');
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
