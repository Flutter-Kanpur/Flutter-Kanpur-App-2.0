import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/application/community_provider.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_card.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_header.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_screen.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_section_title.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_status_chip.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/gradiant_background.dart';
import 'package:flutter_knp_mobile_app_v2/common_widgets/search_bar.dart';
import 'package:flutter_knp_mobile_app_v2/modules/home/presentation/widgets/home_app_bar.dart';
import 'package:flutter_knp_mobile_app_v2/modules/home/presentation/widgets/home_announcement_carousel.dart';
import 'package:flutter_knp_mobile_app_v2/modules/home/presentation/widgets/home_filter_tabs.dart';
import 'package:flutter_knp_mobile_app_v2/modules/home/presentation/widgets/event_card_component.dart';
import 'package:flutter_knp_mobile_app_v2/utils/assets_path.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentAnnouncementPage = 0;
  int _selectedFilterIndex = 1;

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
                    setState(() => _currentAnnouncementPage = page);
                  },
                ),
                HomeFilterTabs(
                  selectedFilterIndex: _selectedFilterIndex,
                  onFilterSelected: (index) {
                    setState(() => _selectedFilterIndex = index);
                  },
                  onFiltersTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('home.filtersBottomSheetPlaceholder'.tr())),
                    );
                  },
                  selectedFiltersCount: 0,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(AppSpacing.s10, AppSpacing.s10, AppSpacing.s10, AppSpacing.s07),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'home.whatsNew'.tr(),
                        style: AppTextStyles.titleLarge.copyWith(color: AppColors.blackBase, fontWeight: FontWeight.w600),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Handle see all navigation
                        },
                        child: Row(
                          children: [
                            Text(
                              'home.seeAll'.tr(),
                              style: AppTextStyles.titleMedium.copyWith(color: AppColors.neutral500),
                            ),
                            SizedBox(width: AppSpacing.s01),
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
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.s07),
                  child: Column(
                    children: [
                      EventCardComponent(
                        assetPath: AssetsPath.launcheventpng,
                        status: 'home.events.upcoming'.tr(),
                        statusColor: AppColors.success500,
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
                      EventCardComponent(
                        assetPath: AssetsPath.fkcard,
                        status: 'home.events.upcoming'.tr(),
                        statusColor: AppColors.success500,
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

