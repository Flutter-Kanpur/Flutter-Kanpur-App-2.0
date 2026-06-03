import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/application/community_provider.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_card.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_header.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_screen.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_section_title.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_status_chip.dart';
import 'package:flutter_knp_mobile_app_v2/utils/colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_knp_mobile_app_v2/common_widgets/gradiant_background.dart';
import 'package:flutter_knp_mobile_app_v2/common_widgets/search_bar.dart';
import 'package:flutter_knp_mobile_app_v2/modules/home/presentation/widgets/home_app_bar.dart';
import 'package:flutter_knp_mobile_app_v2/modules/home/presentation/widgets/home_announcement_carousel.dart';
import 'package:flutter_knp_mobile_app_v2/modules/home/presentation/widgets/home_filter_tabs.dart';
import 'package:flutter_knp_mobile_app_v2/modules/home/presentation/widgets/event_card_component.dart';
import 'package:flutter_knp_mobile_app_v2/utils/assets_path.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _currentAnnouncementPage = 0;
  late int _selectedFilterIndex = 1;
  late int _selectedFiltersCount = 0;

  @override
  Widget build(BuildContext context) {
    final announcements = [
      {
        'title': 'home.announcements.first.title'.tr(),
        'body': 'home.announcements.first.body'.tr(),
        'btn_text': 'home.announcements.first.button'.tr(),
        'btn_url': '',
        'background_image': null,
      },
      {
        'title': 'home.announcements.second.title'.tr(),
        'body': 'home.announcements.second.body'.tr(),
        'btn_text': 'home.announcements.second.button'.tr(),
        'btn_url': '',
        'background_image': null,
      },
      {
        'title': 'home.announcements.third.title'.tr(),
        'body': 'home.announcements.third.body'.tr(),
        'btn_text': 'home.announcements.third.button'.tr(),
        'btn_url': '',
        'background_image': null,
      },
    ];

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
                CommonSearchBar(
                  readOnly: true,
                  hintText: 'home.searchHint'.tr(),
                  onTap: () {
                    // Handle search navigation
                  },
                ),
                HomeAnnouncementCarousel(
                  announcements: announcements,
                  currentPage: _currentAnnouncementPage,
                  onPageChanged: (page) {
                    setState(() {
                      _currentAnnouncementPage = page;
                    });
                  },
                ),

                HomeFilterTabs(
                  selectedFilterIndex: _selectedFilterIndex,
                  onFilterSelected: (index) {
                    setState(() {
                      _selectedFilterIndex = index;
                    });
                  },
                  onFiltersTap: () {
                    // Handle filters bottom sheet
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'home.filtersBottomSheetPlaceholder'.tr(),
                        ),
                      ),
                    );
                  },
                  selectedFiltersCount: _selectedFiltersCount,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 16.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'home.whatsNew'.tr(),
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Handle see all navigation
                        },
                        child: Row(
                          children: [
                            Text(
                              'home.seeAll'.tr(),
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(width: 2.w),
                            Icon(
                              Icons.chevron_right,
                              size: 20.sp,
                              color: Colors.grey[600],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    children: [
                      // First Event Card
                      EventCardComponent(
                        assetPath: AssetsPath.launcheventpng,
                        status: 'home.events.upcoming'.tr(),
                        statusColor: const Color(0xFF10B981),
                        organization: 'home.events.organization'.tr(),
                        title: 'home.events.first.title'.tr(),
                        description: 'home.events.first.description'.tr(),
                        dateTime: 'home.events.first.dateTime'.tr(),
                        buttonText: 'home.events.button'.tr(),
                        onButtonPressed: () {},
                        showEyeIcon: true,
                        onEyeIconPressed: () {},
                      ),
                      16.verticalSpace,
                      // Second Event Card
                      EventCardComponent(
                        assetPath: AssetsPath.fkcard,
                        status: 'home.events.upcoming'.tr(),
                        statusColor: const Color(0xFF10B981),
                        organization: 'home.events.organization'.tr(),
                        title: 'home.events.second.title'.tr(),
                        description: 'home.events.second.description'.tr(),
                        dateTime: 'home.events.second.dateTime'.tr(),
                        buttonText: 'home.events.button'.tr(),
                        onButtonPressed: () {},
                        showEyeIcon: true,
                        onEyeIconPressed: () {},
                      ),
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
