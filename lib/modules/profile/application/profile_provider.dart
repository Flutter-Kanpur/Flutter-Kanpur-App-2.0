import 'dart:async';

import 'package:flutter_knp_mobile_app_v2/modules/blogs/data/readme_auth_bridge.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:flutter_knp_mobile_app_v2/modules/auth/application/auth_session_provider.dart';
import 'package:flutter_knp_mobile_app_v2/modules/profile/data/repositories/profile_repository.dart';
import 'package:flutter_knp_mobile_app_v2/modules/profile/domain/profile_models.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository();
});

final myProfileProvider =
    AsyncNotifierProvider<MyProfileNotifier, ProfileUser?>(
      MyProfileNotifier.new,
    );

class MyProfileNotifier extends AsyncNotifier<ProfileUser?> {
  @override
  Future<ProfileUser?> build() async {
    // Rebuild whenever the signed-in user changes.
    final auth = ref.watch(authUserIdProvider);
    if (auth.isLoading && !auth.hasValue) {
      await ref.watch(authUserIdProvider.future);
    } else if (auth.asData?.value == null) {
      return null;
    }

    // Always load from the live Supabase session, not a cached uid.
    return ref.read(profileRepositoryProvider).fetchMyProfile();
  }

  Future<void> refresh() async {
    final uid = Supabase.instance.client.auth.currentUser?.id;
    if (uid == null) {
      state = const AsyncData(null);
      return;
    }

    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(profileRepositoryProvider).fetchMyProfile(),
    );
  }
}

final profileActionControllerProvider =
    AsyncNotifierProvider<ProfileActionController, void>(
      ProfileActionController.new,
    );

class ProfileActionController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<bool> saveProfileDetails(
    ProfileDraft draft, {
    required ProfileUser? current,
    String? localPhotoPath,
    bool removePhoto = false,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(profileRepositoryProvider).updateProfileDetails(
            draft,
            current: current,
            localPhotoPath: localPhotoPath,
            removePhoto: removePhoto,
          ),
    );
    if (!state.hasError) {
      ref.invalidate(myProfileProvider);
      if (localPhotoPath != null || removePhoto) {
        unawaited(ReadmeAuthBridge.ensureSignedIn(force: true));
      }
    }
    return !state.hasError;
  }

  Future<bool> saveSkillsAndExperience({
    required List<String> skills,
    required int yearsOfExperience,
    required ProfileUser? current,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref
          .read(profileRepositoryProvider)
          .updateSkillsAndExperience(
            skills: skills,
            yearsOfExperience: yearsOfExperience,
            current: current,
          ),
    );
    if (!state.hasError) ref.invalidate(myProfileProvider);
    return !state.hasError;
  }
}
