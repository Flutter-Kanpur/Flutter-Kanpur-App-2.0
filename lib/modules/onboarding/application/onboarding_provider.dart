import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_knp_mobile_app_v2/core/storage/app_prefs.dart';
import 'package:flutter_knp_mobile_app_v2/modules/onboarding/data/services/onboarding_service.dart';
import 'package:flutter_knp_mobile_app_v2/modules/onboarding/domain/onboarding_draft.dart';

final onboardingServiceProvider = Provider<OnboardingService>((ref) {
  return OnboardingService();
});

final onboardingProvider =
    NotifierProvider<OnboardingNotifier, OnboardingDraft>(
      OnboardingNotifier.new,
    );

class OnboardingNotifier extends Notifier<OnboardingDraft> {
  @override
  OnboardingDraft build() => const OnboardingDraft();

  Future<void> restoreFromPrefs() async {
    final draft = await AppPrefs.getOnboardingDraft();
    if (draft != null) {
      state = draft;
    }
  }

  Future<void> _persist() async {
    await AppPrefs.setOnboardingDraft(state);
  }

  Future<void> setStep(int step) async {
    state = state.copyWith(currentStep: step, clearError: true);
    await _persist();
  }

  Future<void> setFullName(String name) async {
    state = state.copyWith(fullName: name);
    await _persist();
  }

  Future<void> setPhotoPath(String? path) async {
    if (path == null || path.isEmpty) {
      state = state.copyWith(clearLocalPhotoPath: true);
    } else {
      state = state.copyWith(localPhotoPath: path);
    }
    await _persist();
  }

  Future<void> setRoles(List<String> roles) async {
    state = state.copyWith(selectedRoles: roles);
    await _persist();
  }

  Future<void> setSkills(List<String> skills) async {
    state = state.copyWith(selectedSkills: skills);
    await _persist();
  }

  Future<void> setYearsOfExperience(int? years) async {
    if (years == null) {
      state = state.copyWith(clearYearsOfExperience: true);
    } else {
      state = state.copyWith(yearsOfExperience: years);
    }
    await _persist();
  }

  Future<void> setLinks({
    String? githubUrl,
    String? linkedinUrl,
    String? websiteUrl,
  }) async {
    state = state.copyWith(
      githubUrl: githubUrl,
      linkedinUrl: linkedinUrl,
      websiteUrl: websiteUrl,
    );
    await _persist();
  }

  /// Uploads avatar + profile to Supabase, then clears local draft.
  Future<bool> finish() async {
    state = state.copyWith(isSubmitting: true, clearError: true);
    try {
      await ref.read(onboardingServiceProvider).submit(state);
      await AppPrefs.clearOnboardingDraft();
      state = state.copyWith(isSubmitting: false);
      return true;
    } catch (e) {
      state = state.copyWith(isSubmitting: false, error: e.toString());
      return false;
    }
  }
}
