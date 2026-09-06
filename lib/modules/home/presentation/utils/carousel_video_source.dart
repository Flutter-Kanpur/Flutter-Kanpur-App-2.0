/// Parses carousel video URLs into direct files or YouTube embed ids.
class CarouselVideoSource {
  const CarouselVideoSource.direct(this.url)
    : youtubeVideoId = null;

  const CarouselVideoSource.youtube(this.youtubeVideoId) : url = null;

  final String? url;
  final String? youtubeVideoId;

  bool get isYoutube => youtubeVideoId != null && youtubeVideoId!.isNotEmpty;

  static CarouselVideoSource? parse(String rawUrl) {
    final trimmed = rawUrl.trim();
    if (trimmed.isEmpty) return null;

    final youtubeId = _extractYoutubeVideoId(trimmed);
    if (youtubeId != null) {
      return CarouselVideoSource.youtube(youtubeId);
    }

    if (_isDirectVideoUrl(trimmed)) {
      return CarouselVideoSource.direct(trimmed);
    }

    return null;
  }

  static String? _extractYoutubeVideoId(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return null;

    final host = uri.host.toLowerCase();
    if (host == 'youtu.be') {
      return uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null;
    }

    if (!host.contains('youtube.com')) return null;

    final segments = uri.pathSegments;
    if (segments.contains('shorts')) {
      final index = segments.indexOf('shorts');
      if (index + 1 < segments.length) {
        return segments[index + 1];
      }
    }

    if (segments.contains('embed')) {
      final index = segments.indexOf('embed');
      if (index + 1 < segments.length) {
        return segments[index + 1];
      }
    }

    final fromQuery = uri.queryParameters['v'];
    if (fromQuery != null && fromQuery.isNotEmpty) {
      return fromQuery;
    }

    return null;
  }

  static bool _isDirectVideoUrl(String url) {
    final lower = url.toLowerCase();
    if (lower.contains('instagram.com') || lower.contains('vimeo.com')) {
      return false;
    }
    return lower.endsWith('.mp4') ||
        lower.endsWith('.webm') ||
        lower.endsWith('.mov') ||
        lower.contains('.m3u8') ||
        lower.contains('/storage/v1/object/public/');
  }
}
