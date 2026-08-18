import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/router/route_names.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_knp_mobile_app_v2/modules/explore/application/explore_providers.dart';
import 'package:flutter_knp_mobile_app_v2/modules/explore/presentation/widgets/community_projects_preview_section.dart';
import 'package:flutter_knp_mobile_app_v2/modules/explore/presentation/widgets/core_team_preview_section.dart';
import 'package:flutter_knp_mobile_app_v2/modules/explore/presentation/widgets/participation_activities_section.dart';
import 'package:flutter_knp_mobile_app_v2/modules/home/presentation/widgets/home_announcement_carousel.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/gradiant_background.dart';
import 'package:flutter_knp_mobile_app_v2/utils/assets_path.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  // Mirrors HomeScreen's own state for HomeAnnouncementCarousel, which is
  // reused as-is here rather than a separate Explore-specific hero widget.
  int _currentAnnouncementPage = 0;

  @override
  Widget build(BuildContext context) {
    final heroSlides = ref.watch(heroBannerSlidesProvider);

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ExploreAppBar(
                  onNotificationsTap: () =>
                      context.push(RouteNames.notifications),
                ),
                HomeAnnouncementCarousel(
                  announcements: heroSlides,
                  currentPage: _currentAnnouncementPage,
                  onPageChanged: (page) =>
                      setState(() => _currentAnnouncementPage = page),
                ),
                Padding(
                  padding: AppSpacing.horizontal(AppSpacing.h20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ParticipationActivitiesSection(
                        onEventsTap: () => context.push(RouteNames.events),
                        onContestsTap: () {},
                        onOpenCallsTap: () {},
                      ),
                      SizedBox(height: AppSpacing.v12),
                      CommunityProjectsPreviewSection(
                        onViewAllTap: () =>
                            context.push(RouteNames.communityProjects),
                      ),
                      SizedBox(height: AppSpacing.v12),
                      CoreTeamPreviewSection(onViewAllTap: () {}),
                      SizedBox(height: AppSpacing.v12),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ExploreAppBar extends StatelessWidget {
  const _ExploreAppBar({required this.onNotificationsTap});

  final VoidCallback onNotificationsTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.h22,
        AppSpacing.h20,
        AppSpacing.h8,
        AppSpacing.h8,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Explore',
              style: AppTextStyles.titleLarge.copyWith(
                color: AppColors.blackBase,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          IconButton(
            onPressed: onNotificationsTap,
            icon: SvgPicture.asset(AssetsPath.notification),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
            color: AppColors.blackBase,
          ),
        ],
      ),
    );
  }
}
