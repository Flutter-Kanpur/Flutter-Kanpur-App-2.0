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
      'btn_url': '/community',
      'background_image': null,
    },
    {
      'title': 'Share what you build',
      'body':
          'Upload your projects, get feedback from the community, and get '
          'discovered by other builders in Flutter Kanpur.',
      'btn_text': 'Upload a project',
      'btn_url': '/community/upload-project',
      'background_image': null,
    },
  ];
}
