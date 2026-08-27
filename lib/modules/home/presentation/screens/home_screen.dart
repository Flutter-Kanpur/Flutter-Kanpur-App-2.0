import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_knp_mobile_app_v2/common_widgets/search_bar.dart';
import 'package:flutter_knp_mobile_app_v2/modules/home/application/home_carousel_providers.dart';
import 'package:flutter_knp_mobile_app_v2/modules/home/application/home_providers.dart';
import 'package:flutter_knp_mobile_app_v2/modules/home/domain/entities/event_entity.dart';
import 'package:flutter_knp_mobile_app_v2/modules/home/presentation/screens/home_search_screen.dart';
import 'package:flutter_knp_mobile_app_v2/modules/home/presentation/widgets/event_card_component.dart';
import 'package:flutter_knp_mobile_app_v2/modules/home/presentation/widgets/home_announcement_carousel.dart';
import 'package:flutter_knp_mobile_app_v2/modules/home/presentation/widgets/home_app_bar.dart';
import 'package:flutter_knp_mobile_app_v2/modules/home/presentation/widgets/home_filter_bottom_sheet.dart';
import 'package:flutter_knp_mobile_app_v2/modules/home/presentation/widgets/home_filter_tabs.dart';
import 'package:flutter_knp_mobile_app_v2/modules/home/presentation/widgets/home_skeleton.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/gradiant_background.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeProvider);
    final homeNotifier = ref.read(homeProvider.notifier);
    final carouselAsync = ref.watch(homeCarouselSlidesProvider);

    final events = homeState.filteredEvents;

    final announcements = carouselAsync.maybeWhen(
      data: (slides) => slides,
      orElse: () => const <Map<String, String?>>[],
    );

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HomeAppBar(),

                // --------------------------------------------------
                // Search
                // --------------------------------------------------
                CommonSearchBar(
                  readOnly: true,
                  hintText: 'home.searchHint'.tr(),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const HomeSearchScreen(),
                      ),
                    );
                  },
                ),

                // --------------------------------------------------
                // Announcements
                // --------------------------------------------------
                HomeAnnouncementCarousel(
                  announcements: announcements,
                  currentPage: homeState.currentAnnouncementPage,
                  onPageChanged: homeNotifier.setAnnouncementPage,
                ),

                // --------------------------------------------------
                // Filter tabs
                // --------------------------------------------------
                HomeFilterTabs(
                  selectedFilterIndex: homeState.selectedFilterIndex,
                  selectedFiltersCount: homeState.selectedFiltersCount,
                  onFilterSelected: homeNotifier.selectFilterTab,
                  onFilterCleared: homeNotifier.clearFilterTab,
                  onFiltersTap: () async {
                    final filters = await HomeFilterBottomSheet.show(
                      context,
                      initialFilters: homeState.selectedFilters,
                    );

                    if (filters != null) {
                      homeNotifier.setFilters(filters);
                    }
                  },
                ),

                // --------------------------------------------------
                // What's New header
                // --------------------------------------------------
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.h22,
                    AppSpacing.h22,
                    AppSpacing.h22,
                    AppSpacing.h16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'home.whatsNew'.tr(),
                        style: AppTextStyles.titleLarge.copyWith(
                          color: AppColors.blackBase,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // TODO: Navigate to all events.
                        },
                        child: Row(
                          children: [
                            Text(
                              'home.seeAll'.tr(),
                              style: AppTextStyles.titleMedium.copyWith(
                                color: AppColors.neutral500,
                              ),
                            ),
                            SizedBox(width: AppSpacing.h2),
                            Icon(
                              Icons.chevron_right,
                              size: 20.sp,
                              color: AppColors.neutral500,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // --------------------------------------------------
                // Events
                // --------------------------------------------------
                if (homeState.isLoading)
                  const HomeSkeleton()
                else if (events.isEmpty)
                  _EmptyEventsState()
                else
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.h16),
                    child: Column(
                      children: [
                        for (int index = 0; index < events.length; index++) ...[
                          _buildEventCard(context, events[index]),
                          if (index < events.length - 1) 16.verticalSpace,
                        ],
                      ],
                    ),
                  ),

                24.verticalSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEventCard(BuildContext context, EventEntity event) {
    final status = event.eventStatus;

    return EventCardComponent(
      assetPath: event.cover ?? '',
      status: status['label'] as String,
      statusColor: Color(status['color'] as int),
      organization: event.hostName ?? 'Flutter Kanpur',
      title: event.title,
      description: event.shortDescription ?? event.description,
      dateTime: '${event.formattedDateShort} • ${event.formattedTime12Hour}',
      buttonText: 'home.events.button'.tr(),
      onButtonPressed: () {
        // TODO: Navigate to event details.
      },
      showEyeIcon: false,
    );
  }
}

class _EmptyEventsState extends StatelessWidget {
  const _EmptyEventsState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.h22,
        vertical: AppSpacing.v22,
      ),
      child: Center(
        child: Text(
          'No events found',
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.neutral500),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
