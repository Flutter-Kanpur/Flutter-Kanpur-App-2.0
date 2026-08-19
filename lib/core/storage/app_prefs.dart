import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_knp_mobile_app_v2/modules/onboarding/domain/onboarding_draft.dart';

class AppPrefs {
  AppPrefs._();

  static const _hasSeenLandingKey = 'has_seen_landing';
  static const _onboardingDraftKey = 'onboarding_draft';
  static const _likedProjectIdsKey = 'liked_project_ids';

  static Future<bool> getHasSeenLanding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_hasSeenLandingKey) ?? false;
  }

  static Future<void> setHasSeenLanding(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hasSeenLandingKey, value);
  }

  static Future<OnboardingDraft?> getOnboardingDraft() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_onboardingDraftKey);
    if (raw == null || raw.isEmpty) return null;
    try {
      return OnboardingDraft.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
    } catch (_) {
      return null;
    }
  }

  static Future<void> setOnboardingDraft(OnboardingDraft draft) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_onboardingDraftKey, jsonEncode(draft.toJson()));
  }

  static Future<void> clearOnboardingDraft() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_onboardingDraftKey);
  }

  /// Ids of projects the user has liked - keyed by `projects.id`. There is no
  /// server-side like table for projects (unlike questions/answers), so this
  /// is purely local, client-side state.
  static Future<Set<String>> getLikedProjectIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_likedProjectIdsKey)?.toSet() ?? {};
  }

  static Future<void> setLikedProjectIds(Set<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_likedProjectIdsKey, ids.toList());
  }
}