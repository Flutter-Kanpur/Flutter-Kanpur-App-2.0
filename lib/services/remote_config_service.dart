import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';

/// Service to read app feature flags and config from Firebase Remote Config.
/// Expects a parameter [appConfig] with JSON shape: { "profile_community": { "enable": "true" } }
class RemoteConfigService {
  RemoteConfigService._();
  static final RemoteConfigService instance = RemoteConfigService._();

  static const String _paramAppConfig = 'appConfig';

  FirebaseRemoteConfig get _remoteConfig => FirebaseRemoteConfig.instance;

  /// Initialize Remote Config with in-app defaults. Call once after Firebase.initializeApp().
  Future<void> initialize() async {
    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: Duration.zero,
    ));
    await _remoteConfig.setDefaults(<String, dynamic>{
      _paramAppConfig: jsonEncode({
        'profile_community': {'enable': 'true'},
        'onboarding': {
          'screen2': {
            'options':
                '[Web Developer, Community Contributor, Student, Flutter Developer, UI / UX Designer, Backend Developer]',
          },
        },
        'trending_search': {
          'searches': {
            'tags':
                '[hackathon, events, framework, articles, flutter, firebase]',
          },
        },
        'home_screen_carousel_data': {
          'announcement_1': {
            'background_image': null,
            'title': 'Join the ultimate design challenge.',
            'body':
                'Registrations are now open for you to showcase your skills, collaborate with fellow innovators, and stand a chance to win exciting prizes that could propel your career to new heights.',
            'btn_text': 'Register Now',
            'btn_url': '',
          },
          'announcement_2': {
            'background_image': null,
            'title': 'Congratulations to our top participant.',
            'body':
                'We are thrilled to recognize and celebrate the outstanding contributions of our top community members this month.',
            'btn_text': 'View Details',
            'btn_url': '',
          },
          'announcement_3': {
            'background_image': null,
            'title': 'New Blog Alert: Mastering Flutter UI',
            'body':
                'Dive into our latest blog post where industry experts share invaluable tips and best practices for Flutter development.',
            'btn_text': 'Read Blog',
            'btn_url': '',
          },
        },
      }),
    });
    await _remoteConfig.fetchAndActivate();
  }

  /// Whether the profile community section (My Contributions, Join as Contributor, etc.) should be shown.
  bool get isProfileCommunityEnabled {
    try {
      final jsonString = _remoteConfig.getString(_paramAppConfig);
      final map = jsonDecode(jsonString) as Map<String, dynamic>?;
      if (map == null) return true;
      final profileCommunity =
          map['profile_community'] as Map<String, dynamic>?;
      if (profileCommunity == null) return true;
      final enable = profileCommunity['enable'];
      if (enable == null) return true;
      if (enable is bool) return enable;
      if (enable is String) return enable.toLowerCase() == 'true';
      return true;
    } catch (_) {
      return true;
    }
  }

  /// Options for onboarding screen 2 chips (roles/skills). Parses [onboarding.screen2.options] string.
  /// Format expected: "[Web Developer, App Developer, Flutter, ...]" (comma-separated, optional brackets).
  List<String> get onboardingScreen2Options {
    try {
      final jsonString = _remoteConfig.getString(_paramAppConfig);
      final map = jsonDecode(jsonString) as Map<String, dynamic>?;
      if (map == null) return _defaultOnboardingScreen2Options;
      final onboarding = map['onboarding'] as Map<String, dynamic>?;
      if (onboarding == null) return _defaultOnboardingScreen2Options;
      final screen2 = onboarding['screen2'] as Map<String, dynamic>?;
      if (screen2 == null) return _defaultOnboardingScreen2Options;
      final optionsRaw = screen2['options'];
      if (optionsRaw == null) return _defaultOnboardingScreen2Options;
      final String optionsStr =
          optionsRaw is String ? optionsRaw : optionsRaw.toString();
      final trimmed = optionsStr.trim();
      final withoutBrackets = trimmed
          .replaceFirst(RegExp(r'^\s*\['), '')
          .replaceFirst(RegExp(r'\]\s*$'), '');
      final list = withoutBrackets
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
      return list.isEmpty ? _defaultOnboardingScreen2Options : list;
    } catch (_) {
      return _defaultOnboardingScreen2Options;
    }
  }

  List<String> get onboardingScreen3Options {
    try {
      final jsonString = _remoteConfig.getString(_paramAppConfig);
      final map = jsonDecode(jsonString) as Map<String, dynamic>?;
      if (map == null) return _defaultOnboardingScreen3Options;
      final onboarding = map['onboarding'] as Map<String, dynamic>?;
      if (onboarding == null) return _defaultOnboardingScreen3Options;
      final screen3 = onboarding['screen3'] as Map<String, dynamic>?;
      if (screen3 == null) return _defaultOnboardingScreen3Options;
      final optionsRaw = screen3['options'];
      if (optionsRaw == null) return _defaultOnboardingScreen3Options;
      final String optionsStr =
          optionsRaw is String ? optionsRaw : optionsRaw.toString();
      final trimmed = optionsStr.trim();
      final withoutBrackets = trimmed
          .replaceFirst(RegExp(r'^\s*\['), '')
          .replaceFirst(RegExp(r'\]\s*$'), '');
      final list = withoutBrackets
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
      return list.isEmpty ? _defaultOnboardingScreen3Options : list;
    } catch (_) {
      return _defaultOnboardingScreen3Options;
    }
  }

  /// Parses [home_screen_carousel_data] and returns an ordered list of announcements.
  /// Each map contains: title, body, btn_text, btn_url, background_image (nullable).
  List<Map<String, String?>> get homeScreenCarouselAnnouncements {
    try {
      final jsonString = _remoteConfig.getString(_paramAppConfig);
      // ignore: avoid_print
      print('[RemoteConfig] appConfig raw: ${jsonString.substring(0, jsonString.length.clamp(0, 200))}');
      final map = jsonDecode(jsonString) as Map<String, dynamic>?;
      if (map == null) return [];
      final carouselData =
          map['home_screen_carousel_data'] as Map<String, dynamic>?;
      // ignore: avoid_print
      print('[RemoteConfig] home_screen_carousel_data keys: ${carouselData?.keys.toList()}');
      if (carouselData == null) return [];

      // Sort keys (announcement_1, announcement_2, …) to maintain order.
      final keys = carouselData.keys.toList()..sort();

      return keys.map((key) {
        final entry = carouselData[key] as Map<String, dynamic>?;
        if (entry == null) return null;
        final bgRaw = entry['background_image'];
        final bgImage =
            (bgRaw != null && bgRaw.toString().isNotEmpty) ? bgRaw.toString() : null;
        return <String, String?>{
          'title': entry['title']?.toString() ?? '',
          'body': entry['body']?.toString() ?? '',
          'btn_text': entry['btn_text']?.toString() ?? '',
          'btn_url': entry['btn_url']?.toString() ?? '',
          'background_image': bgImage,
        };
      }).whereType<Map<String, String?>>().toList();
    } catch (_) {
      return [];
    }
  }

  /// Tags for the trending search section. Parses [trending_search.searches.tags].
  /// Format expected: "[hackathon, events, flutter, ...]"
  List<String> get trendingSearchTags {
    try {
      final jsonString = _remoteConfig.getString(_paramAppConfig);
      final map = jsonDecode(jsonString) as Map<String, dynamic>?;
      if (map == null) return _defaultTrendingSearchTags;
      final trendingSearch = map['trending_search'] as Map<String, dynamic>?;
      if (trendingSearch == null) return _defaultTrendingSearchTags;
      final searches = trendingSearch['searches'] as Map<String, dynamic>?;
      if (searches == null) return _defaultTrendingSearchTags;
      final tagsRaw = searches['tags'];
      if (tagsRaw == null) return _defaultTrendingSearchTags;
      final String tagsStr = tagsRaw is String ? tagsRaw : tagsRaw.toString();
      final trimmed = tagsStr.trim();
      final withoutBrackets = trimmed
          .replaceFirst(RegExp(r'^\s*\['), '')
          .replaceFirst(RegExp(r'\]\s*$'), '');
      final list = withoutBrackets
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
      return list.isEmpty ? _defaultTrendingSearchTags : list;
    } catch (_) {
      return _defaultTrendingSearchTags;
    }
  }

  static const List<String> _defaultTrendingSearchTags = [
    'hackathon',
    'events',
    'framework',
    'articles',
    'flutter',
    'firebase',
  ];

  static const List<String> _defaultOnboardingScreen2Options = [
    'Web Developer',
    'Community Contributor',
    'Student',
    'Flutter Developer',
    'UI / UX Designer',
    'Backend Developer',
  ];

  static const List<String> _defaultOnboardingScreen3Options = [
    'Flutter',
    'Dart',
    'JavaScript',
    'Mongo',
    'Docker',
    'Kubernetes',
    'Postgres',
    'Figma',
  ];
}
