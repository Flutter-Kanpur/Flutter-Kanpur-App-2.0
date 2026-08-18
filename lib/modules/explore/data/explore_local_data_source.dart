import 'package:flutter_knp_mobile_app_v2/modules/explore/domain/suggested_job.dart';

/// Sample-data source for the Explore dashboard preview sections. Mirrors the
/// shape of a real repository (one method per list) so a future Supabase-backed
/// version can replace just this class without touching the providers/widgets
/// that consume it.
class ExploreLocalDataSource {
  ExploreLocalDataSource._();

  /// Same shape HomeAnnouncementCarousel expects (title/body/btn_text/
  /// btn_url/background_image) - Explore reuses that widget as-is.
  static List<Map<String, String?>> fetchHeroBannerSlides() => const [
    {
      'title': 'Be part of the community',
      'body':
          'Connect with developers, designers, and learners. Participate in '
          'events, learn together, and contribute to community projects.',
      'btn_text': 'Join community',
      'btn_url': '',
      'background_image': null,
    },
    {
      'title': 'Share what you build',
      'body':
          'Upload your projects, get feedback from the community, and get '
          'discovered by other builders in Flutter Kanpur.',
      'btn_text': 'Upload a project',
      'btn_url': '',
      'background_image': null,
    },
  ];

  /// Async + artificial delay - keeps the loading/skeleton state visible
  /// during manual testing and matches the provider architecture a real
  /// API-backed version would need.
  static Future<List<SuggestedJob>> fetchSuggestedJobs() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return const [
      SuggestedJob(
        title: 'Lead Product Designer',
        tags: ['On-site', 'Full-time', 'Paid'],
        companyName: 'Superkalam',
        companyLogoUrl: 'https://picsum.photos/seed/fk-job-1/80/80',
        location: 'Bangalore',
        isSaved: true,
      ),
      SuggestedJob(
        title: 'Flutter Developer/ UI/UX',
        tags: ['Hybrid', 'Full-time', 'Un-paid'],
        companyName: 'Quickgik',
        companyLogoUrl: 'https://picsum.photos/seed/fk-job-2/80/80',
        location: 'Delhi',
        isSaved: true,
      ),
    ];
  }
}
