import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_knp_mobile_app_v2/utils/assets_path.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';

class HomeAnnouncementCarousel extends StatelessWidget {
  const HomeAnnouncementCarousel({
    super.key,
    required this.announcements,
    required this.currentPage,
    required this.onPageChanged,
  });

  /// Each map has keys: title, body, btn_text, btn_url, background_image (nullable).
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
    final bgImage = announcement['background_image'];
    final hasImage = bgImage != null && bgImage.isNotEmpty;

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
            // Background: SVG or network image
            if (hasImage)
              Image.network(
                bgImage,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => SvgPicture.asset(
                  AssetsPath.announcementcardbg,
                  fit: BoxFit.cover,
                ),
              )
            else
              SvgPicture.asset(
                AssetsPath.announcementcardbg,
                fit: BoxFit.cover,
              ),

            // Image-only mode: just a button anchored to the bottom-left
            if (hasImage)
              Positioned(
                left: 20.w,
                bottom: 20.h,
                child: ElevatedButton(
                  onPressed: ()  {},
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
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.blackBase,
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
                            style: AppTextStyles.titleLarge.copyWith(color: AppColors.whiteBase, fontWeight: FontWeight.w600, height: 1.2),
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
                        onPressed: () {},
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
                          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.blackBase,
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
