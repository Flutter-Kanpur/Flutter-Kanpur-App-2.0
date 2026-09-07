import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/router/community_upload_routes.dart';
import 'package:flutter_knp_mobile_app_v2/app/router/route_names.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_knp_mobile_app_v2/utils/assets_path.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/utils/external_links.dart';
import 'package:flutter_knp_mobile_app_v2/modules/home/presentation/utils/carousel_video_source.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class HomeAnnouncementCarousel extends StatelessWidget {
  const HomeAnnouncementCarousel({
    super.key,
    required this.announcements,
    required this.currentPage,
    required this.onPageChanged,
  });

  /// Each map has keys: title, body, btn_text, btn_url, background_image,
  /// video_url (nullable), content_type (image | video | text).
  final List<Map<String, String?>> announcements;
  final int currentPage;
  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context) {
    if (announcements.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: AppSpacing.vertical(AppSpacing.v20),
      child: Column(
        children: [
          CarouselSlider.builder(
            itemCount: announcements.length,
            itemBuilder: (context, index, realIndex) {
              final n = announcements.length;
              final safeIndex = ((realIndex % n) + n) % n;
              return _AnnouncementCard(
                announcement: announcements[safeIndex],
                isActive: safeIndex == currentPage,
              );
            },
            options: CarouselOptions(
              height: 190.h,
              viewportFraction: 1.0,
              initialPage: currentPage.clamp(0, announcements.length - 1),
              enableInfiniteScroll: announcements.length > 1,
              reverse: false,
              autoPlay: announcements.length > 1,
              autoPlayInterval: const Duration(seconds: 8),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: false,
              onPageChanged: (index, reason) {
                final n = announcements.length;
                onPageChanged(((index % n) + n) % n);
              },
              scrollDirection: Axis.horizontal,
            ),
          ),
          if (announcements.length > 1) ...[
            12.verticalSpace,
            _CarouselIndicators(
              count: announcements.length,
              currentPage: currentPage,
            ),
          ],
        ],
      ),
    );
  }
}

class _AnnouncementCard extends StatelessWidget {
  const _AnnouncementCard({
    required this.announcement,
    required this.isActive,
  });

  final Map<String, String?> announcement;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final title = announcement['title'] ?? '';
    final body = announcement['body'] ?? '';
    final btnText = announcement['btn_text'] ?? '';
    final btnUrl = announcement['btn_url']?.trim();
    final contentType = announcement['content_type'] ?? 'text';
    final bgImage = announcement['background_image']?.trim();
    final videoUrl = announcement['video_url']?.trim();
    final hasVideo =
        contentType == 'video' && videoUrl != null && videoUrl.isNotEmpty;
    final hasImage = !hasVideo && bgImage != null && bgImage.isNotEmpty;
    final hasMedia = hasVideo || hasImage;

    return Container(
      margin: AppSpacing.horizontal(AppSpacing.h16),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: AppRadius.all07,
      ),
      child: ClipRRect(
        borderRadius: AppRadius.all07,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (hasVideo)
              _CarouselVideoBackground(
                videoUrl: videoUrl,
                posterUrl: bgImage,
                isActive: isActive,
              )
            else if (hasImage)
              CachedNetworkImage(
                imageUrl: bgImage,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => SvgPicture.asset(
                  AssetsPath.announcementcardbg,
                  fit: BoxFit.cover,
                ),
              )
            else
              SvgPicture.asset(
                AssetsPath.announcementcardbg,
                fit: BoxFit.cover,
              ),
            if (hasMedia)
              Positioned(
                left: 20.w,
                bottom: 20.h,
                child: ElevatedButton(
                  onPressed: btnUrl == null || btnUrl.isEmpty
                      ? null
                      : () => _onAnnouncementAction(context, btnUrl),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.whiteBase,
                    foregroundColor: AppColors.primary600,
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.h16,
                      vertical: AppSpacing.v10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.all07,
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    btnText.isNotEmpty ? btnText : 'View Details',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.blackBase,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              )
            else
              Padding(
                padding: AppSpacing.all(AppSpacing.h22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: AppTextStyles.titleLarge.copyWith(
                              color: AppColors.whiteBase,
                              fontWeight: FontWeight.w600,
                              height: 1.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          8.verticalSpace,
                          Text(
                            body,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.whiteBase,
                              height: 1.2,
                            ),
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    8.verticalSpace,
                    if (btnText.isNotEmpty)
                      ElevatedButton(
                        onPressed: btnUrl == null || btnUrl.isEmpty
                            ? null
                            : () => _onAnnouncementAction(context, btnUrl),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.whiteBase,
                          foregroundColor: AppColors.primary600,
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSpacing.h16,
                            vertical: AppSpacing.v10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: AppRadius.all07,
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          btnText,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.blackBase,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _CarouselVideoBackground extends StatelessWidget {
  const _CarouselVideoBackground({
    required this.videoUrl,
    required this.isActive,
    this.posterUrl,
  });

  final String videoUrl;
  final String? posterUrl;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final source = CarouselVideoSource.parse(videoUrl);
    if (source == null) {
      return _CarouselPosterFallback(posterUrl: posterUrl, showLoading: false);
    }

    if (source.isYoutube) {
      return _CarouselYoutubeBackground(
        videoId: source.youtubeVideoId!,
        posterUrl: posterUrl,
        isActive: isActive,
      );
    }

    return _CarouselDirectVideoBackground(
      videoUrl: source.url!,
      posterUrl: posterUrl,
      isActive: isActive,
    );
  }
}

class _CarouselDirectVideoBackground extends StatefulWidget {
  const _CarouselDirectVideoBackground({
    required this.videoUrl,
    required this.isActive,
    this.posterUrl,
  });

  final String videoUrl;
  final String? posterUrl;
  final bool isActive;

  @override
  State<_CarouselDirectVideoBackground> createState() =>
      _CarouselDirectVideoBackgroundState();
}

class _CarouselDirectVideoBackgroundState
    extends State<_CarouselDirectVideoBackground> {
  VideoPlayerController? _controller;
  bool _initialized = false;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  @override
  void didUpdateWidget(covariant _CarouselDirectVideoBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoUrl != widget.videoUrl) {
      _disposeController();
      _failed = false;
      _initialized = false;
      _initController();
      return;
    }
    if (oldWidget.isActive != widget.isActive) {
      _syncPlayback();
    }
  }

  void _initController() {
    final controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoUrl),
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );
    _controller = controller
      ..setLooping(true)
      ..setVolume(0)
      ..initialize().then((_) {
        if (!mounted || _controller != controller) return;
        setState(() => _initialized = true);
        _syncPlayback();
      }).catchError((Object error, StackTrace stackTrace) {
        debugPrint('Carousel video failed to load: ${widget.videoUrl}');
        debugPrint('$error');
        if (!mounted || _controller != controller) return;
        setState(() {
          _failed = true;
          _initialized = false;
        });
      });
  }

  void _syncPlayback() {
    final controller = _controller;
    if (!_initialized || controller == null) return;
    if (widget.isActive) {
      controller.play();
    } else {
      controller.pause();
    }
  }

  void _disposeController() {
    _controller?.dispose();
    _controller = null;
  }

  @override
  void dispose() {
    _disposeController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_initialized && _controller != null) {
      return FittedBox(
        fit: BoxFit.cover,
        clipBehavior: Clip.hardEdge,
        child: SizedBox(
          width: _controller!.value.size.width,
          height: _controller!.value.size.height,
          child: VideoPlayer(_controller!),
        ),
      );
    }

    final poster = widget.posterUrl?.trim();
    if (poster != null && poster.isNotEmpty) {
      return _CarouselPosterFallback(posterUrl: poster, showLoading: false);
    }

    if (_failed) {
      return _CarouselPosterFallback(posterUrl: widget.posterUrl, showLoading: false);
    }

    return _CarouselPosterFallback(posterUrl: widget.posterUrl, showLoading: true);
  }
}

class _CarouselYoutubeBackground extends StatefulWidget {
  const _CarouselYoutubeBackground({
    required this.videoId,
    required this.isActive,
    this.posterUrl,
  });

  final String videoId;
  final String? posterUrl;
  final bool isActive;

  @override
  State<_CarouselYoutubeBackground> createState() =>
      _CarouselYoutubeBackgroundState();
}

class _CarouselYoutubeBackgroundState extends State<_CarouselYoutubeBackground> {
  YoutubePlayerController? _controller;
  bool _ready = false;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  @override
  void didUpdateWidget(covariant _CarouselYoutubeBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoId != widget.videoId) {
      _disposeController();
      _ready = false;
      _failed = false;
      _initController();
      return;
    }
    if (oldWidget.isActive != widget.isActive) {
      _syncPlayback();
    }
  }

  void _initController() {
    final controller = YoutubePlayerController.fromVideoId(
      videoId: widget.videoId,
      autoPlay: widget.isActive,
      params: const YoutubePlayerParams(
        mute: true,
        showControls: false,
        showFullscreenButton: false,
        enableCaption: false,
        loop: true,
        playsInline: true,
        pointerEvents: PointerEvents.none,
      ),
    );

    _controller = controller;
    controller.listen((value) {
      if (!mounted || _controller != controller) return;
      if (value.hasError && !_failed) {
        setState(() => _failed = true);
        return;
      }
      if (!_ready &&
          value.playerState != PlayerState.unknown &&
          value.playerState != PlayerState.unStarted) {
        setState(() => _ready = true);
        _syncPlayback();
      }
    });
  }

  void _syncPlayback() {
    final controller = _controller;
    if (controller == null || !_ready) return;
    if (widget.isActive) {
      controller.playVideo();
    } else {
      controller.pauseVideo();
    }
  }

  Future<void> _disposeController() async {
    await _controller?.close();
    _controller = null;
  }

  @override
  void dispose() {
    unawaited(_disposeController());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    if (_failed || controller == null) {
      return _CarouselPosterFallback(
        posterUrl: widget.posterUrl ?? _youtubeThumbnail(widget.videoId),
        showLoading: false,
      );
    }

    if (!_ready) {
      return _CarouselPosterFallback(
        posterUrl: widget.posterUrl ?? _youtubeThumbnail(widget.videoId),
        showLoading: true,
      );
    }

    return ClipRect(
      child: OverflowBox(
        alignment: Alignment.center,
        minWidth: 0,
        minHeight: 0,
        maxWidth: double.infinity,
        maxHeight: double.infinity,
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: 16 * 42,
            height: 9 * 42,
            child: YoutubePlayer(
              controller: controller,
              backgroundColor: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  String _youtubeThumbnail(String videoId) {
    return 'https://img.youtube.com/vi/$videoId/hqdefault.jpg';
  }
}

class _CarouselPosterFallback extends StatelessWidget {
  const _CarouselPosterFallback({
    required this.showLoading,
    this.posterUrl,
  });

  final String? posterUrl;
  final bool showLoading;

  @override
  Widget build(BuildContext context) {
    final poster = posterUrl?.trim();
    if (poster != null && poster.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: poster,
        fit: BoxFit.cover,
        errorWidget: (_, __, ___) => _defaultBackground(),
      );
    }

    if (!showLoading) return _defaultBackground();

    return Stack(
      fit: StackFit.expand,
      children: [
        _defaultBackground(),
        const Center(
          child: SizedBox(
            width: 28,
            height: 28,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ],
    );
  }

  Widget _defaultBackground() {
    return SvgPicture.asset(
      AssetsPath.announcementcardbg,
      fit: BoxFit.cover,
    );
  }
}

void _onAnnouncementAction(BuildContext context, String target) {
  if (target == RouteNames.communityUploadProject ||
      target.startsWith('${RouteNames.communityUploadProject}/')) {
    openCommunityUploadProject(context);
    return;
  }

  if (target.startsWith('http://') || target.startsWith('https://')) {
    openInAppUrlOrNotify(context, target);
    return;
  }

  if (target == RouteNames.home ||
      target == RouteNames.community ||
      target == RouteNames.explore ||
      target == RouteNames.blogs ||
      target == RouteNames.profile) {
    context.go(target);
    return;
  }

  context.push(target);
}

class _CarouselIndicators extends StatelessWidget {
  const _CarouselIndicators({required this.count, required this.currentPage});

  final int count;
  final int currentPage;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: AppSpacing.horizontal(AppSpacing.h2),
          width: isActive ? 24.w : 8.w,
          height: 8.h,
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.blackBase
                : AppColors.blackBase.withOpacity(0.2),
            borderRadius: AppRadius.all01,
          ),
        );
      }),
    );
  }
}
