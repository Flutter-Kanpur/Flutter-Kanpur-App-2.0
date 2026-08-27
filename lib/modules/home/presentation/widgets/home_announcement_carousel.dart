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
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';

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
              return _AnnouncementCard(announcement: announcements[safeIndex]);
            },
            options: CarouselOptions(
              height: 190.h,
              viewportFraction: 1.0,
              initialPage: 0,
              enableInfiniteScroll: announcements.length > 1,
              reverse: false,
              autoPlay: announcements.length > 1,
              autoPlayInterval: const Duration(seconds: 5),
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
  const _AnnouncementCard({required this.announcement});

  final Map<String, String?> announcement;

  @override
  Widget build(BuildContext context) {
    final title = announcement['title'] ?? '';
    final body = announcement['body'] ?? '';
    final btnText = announcement['btn_text'] ?? '';
    final btnUrl = announcement['btn_url']?.trim();
    final bgImage = announcement['background_image'];
    final videoUrl = announcement['video_url']?.trim();
    final hasVideo = videoUrl != null && videoUrl.isNotEmpty;
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
            // Background: video, network image, or default SVG.
            if (hasVideo)
              _CarouselVideoBackground(videoUrl: videoUrl)
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

            // Media mode: button anchored to the bottom-left.
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
            // Text + button mode
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

class _CarouselVideoBackground extends StatefulWidget {
  const _CarouselVideoBackground({required this.videoUrl});

  final String videoUrl;

  @override
  State<_CarouselVideoBackground> createState() =>
      _CarouselVideoBackgroundState();
}

class _CarouselVideoBackgroundState extends State<_CarouselVideoBackground> {
  late final VideoPlayerController _controller;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..setLooping(true)
      ..setVolume(0)
      ..initialize().then((_) {
        if (!mounted) return;
        setState(() => _initialized = true);
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return SvgPicture.asset(
        AssetsPath.announcementcardbg,
        fit: BoxFit.cover,
      );
    }

    return FittedBox(
      fit: BoxFit.cover,
      clipBehavior: Clip.hardEdge,
      child: SizedBox(
        width: _controller.value.size.width,
        height: _controller.value.size.height,
        child: VideoPlayer(_controller),
      ),
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
