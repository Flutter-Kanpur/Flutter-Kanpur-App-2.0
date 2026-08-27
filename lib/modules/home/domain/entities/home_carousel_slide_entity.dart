import 'package:equatable/equatable.dart';

enum HomeCarouselContentType { image, video, text }

enum HomeCarouselScreen { home, explore }

class HomeCarouselSlideEntity extends Equatable {
  const HomeCarouselSlideEntity({
    required this.id,
    required this.screen,
    required this.contentType,
    this.imageUrl,
    this.videoUrl,
    this.title = '',
    this.body = '',
    this.btnText = '',
    this.btnUrl,
    this.sortOrder = 0,
    this.isActive = true,
  });

  final String id;
  final HomeCarouselScreen screen;
  final HomeCarouselContentType contentType;
  final String? imageUrl;
  final String? videoUrl;
  final String title;
  final String body;
  final String btnText;
  final String? btnUrl;
  final int sortOrder;
  final bool isActive;

  bool get hasVideo => videoUrl != null && videoUrl!.trim().isNotEmpty;

  bool get hasImage => imageUrl != null && imageUrl!.trim().isNotEmpty;

  /// Shape expected by [HomeAnnouncementCarousel].
  Map<String, String?> toCarouselMap() {
    return {
      'content_type': contentType.name,
      'title': title,
      'body': body,
      'btn_text': btnText,
      'btn_url': btnUrl,
      'background_image': hasImage ? imageUrl : null,
      'video_url': hasVideo ? videoUrl : null,
    };
  }

  static HomeCarouselSlideEntity fromMap(Map<String, dynamic> map) {
    return HomeCarouselSlideEntity(
      id: map['id']?.toString() ?? '',
      screen: _parseScreen(map['screen']?.toString()),
      contentType: _parseContentType(map['content_type']?.toString()),
      imageUrl: _nullableString(map['image_url']),
      videoUrl: _nullableString(map['video_url']),
      title: map['title']?.toString() ?? '',
      body: map['body']?.toString() ?? '',
      btnText: map['btn_text']?.toString() ?? '',
      btnUrl: _nullableString(map['btn_url']),
      sortOrder: map['sort_order'] as int? ?? 0,
      isActive: map['is_active'] as bool? ?? true,
    );
  }

  static HomeCarouselScreen _parseScreen(String? value) {
    switch (value) {
      case 'explore':
        return HomeCarouselScreen.explore;
      case 'home':
      default:
        return HomeCarouselScreen.home;
    }
  }

  static HomeCarouselContentType _parseContentType(String? value) {
    switch (value) {
      case 'image':
        return HomeCarouselContentType.image;
      case 'video':
        return HomeCarouselContentType.video;
      case 'text':
      default:
        return HomeCarouselContentType.text;
    }
  }

  static String? _nullableString(dynamic value) {
    if (value == null) return null;
    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }

  @override
  List<Object?> get props => [
    id,
    screen,
    contentType,
    imageUrl,
    videoUrl,
    title,
    body,
    btnText,
    btnUrl,
    sortOrder,
    isActive,
  ];
}
