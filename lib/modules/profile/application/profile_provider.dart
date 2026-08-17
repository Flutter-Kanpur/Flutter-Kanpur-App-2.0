import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  Future<ProfileUser?> build() =>
      ref.read(profileRepositoryProvider).fetchMyProfile();

  Future<void> refresh() async {
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
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref
          .read(profileRepositoryProvider)
          .updateProfileDetails(draft, current: current),
    );
    if (!state.hasError) ref.invalidate(myProfileProvider);
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
