import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_knp_mobile_app_v2/common_widgets/search_bar.dart';
import 'package:flutter_knp_mobile_app_v2/modules/home/application/home_providers.dart';
import 'package:flutter_knp_mobile_app_v2/modules/home/domain/entities/event_entity.dart';
import 'package:flutter_knp_mobile_app_v2/modules/home/presentation/widgets/search_event_result_tile.dart';

class HomeSearchScreen extends ConsumerStatefulWidget {
  const HomeSearchScreen({super.key});

  @override
  ConsumerState<HomeSearchScreen> createState() => _HomeSearchScreenState();
}

class _HomeSearchScreenState extends ConsumerState<HomeSearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<EventEntity> _getSearchResults(List<EventEntity> events, String query) {
    final searchQuery = query.trim().toLowerCase();

    if (searchQuery.isEmpty) {
      return [];
    }

    return events.where((event) {
      final searchableText = [
        event.title,
        event.description,
        event.shortDescription ?? '',
        event.category,
        event.hostName ?? '',
        event.speakerName ?? '',
        event.mode,
        ...event.interests,
      ].join(' ').toLowerCase();

      return searchableText.contains(searchQuery);
    }).toList();
  }

  void _submitSearch(String value) {
    final query = value.trim();

    if (query.isEmpty) {
      return;
    }

    final notifier = ref.read(homeProvider.notifier);

    notifier.setSearchQuery(query);
    notifier.addRecentSearch(query);
  }

  void _removeRecentSearch(String search) {
    ref.read(homeProvider.notifier).removeRecentSearch(search);
  }

  void _clearRecentSearches() {
    ref.read(homeProvider.notifier).clearRecentSearches();
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeProvider);

    final searchResults = _getSearchResults(
      homeState.events,
      homeState.searchQuery,
    );

    return Scaffold(
      backgroundColor: AppColors.whiteBase,
      appBar: AppBar(
        backgroundColor: AppColors.whiteBase,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back, color: AppColors.blackBase, size: 22.sp),
        ),
        title: Text(
          'home.search.title'.tr(),
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.blackBase,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: AppSpacing.v22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --------------------------------------------------
              // Search
              // --------------------------------------------------
              CommonSearchBar(
                controller: _searchController,
                hintText: 'home.searchHint'.tr(),
                onChanged: (value) {
                  ref.read(homeProvider.notifier).setSearchQuery(value);
                },
                onSubmitted: _submitSearch,
              ),

              // --------------------------------------------------
              // Search results
              // --------------------------------------------------
              if (homeState.searchQuery.trim().isNotEmpty) ...[
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.h20,
                    AppSpacing.v22,
                    AppSpacing.h20,
                    AppSpacing.v12,
                  ),
                  child: Text(
                    'home.search.results'.tr(),
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColors.blackBase,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                if (searchResults.isEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.h20,
                      vertical: AppSpacing.v22,
                    ),
                    child: Center(
                      child: Text(
                        'home.search.noResults'.tr(),
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.neutral500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                else
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.h20),
                    child: Column(
                      children: [
                        for (
                          int index = 0;
                          index < searchResults.length;
                          index++
                        ) ...[
                          _buildEventResultTile(searchResults[index]),
                          if (index < searchResults.length - 1)
                            SizedBox(height: AppSpacing.v12),
                        ],
                      ],
                    ),
                  ),
              ] else ...[
                // --------------------------------------------------
                // Trending searches
                // --------------------------------------------------
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.h20,
                    AppSpacing.v22,
                    AppSpacing.h20,
                    AppSpacing.v12,
                  ),
                  child: Text(
                    'home.search.trending'.tr(),
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColors.blackBase,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.h20),
                  child: Wrap(
                    spacing: AppSpacing.h8,
                    runSpacing: AppSpacing.v8,
                    children: ['Flutter', 'Firebase', 'React Native'].map((
                      search,
                    ) {
                      return GestureDetector(
                        onTap: () {
                          _searchController.text = search;
                          _searchController
                              .selection = TextSelection.fromPosition(
                            TextPosition(offset: _searchController.text.length),
                          );

                          _submitSearch(search);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSpacing.h12,
                            vertical: AppSpacing.v8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.neutral100,
                            borderRadius: AppRadius.all03,
                          ),
                          child: Text(
                            search,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.neutral700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                // --------------------------------------------------
                // Recent searches
                // --------------------------------------------------
                if (homeState.recentSearches.isNotEmpty) ...[
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.h20,
                      AppSpacing.v22,
                      AppSpacing.h20,
                      AppSpacing.v12,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'home.search.recent'.tr(),
                          style: AppTextStyles.titleMedium.copyWith(
                            color: AppColors.blackBase,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextButton(
                          onPressed: _clearRecentSearches,
                          child: Text(
                            'home.search.clearAll'.tr(),
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.primary500,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.h20),
                    child: Column(
                      children: homeState.recentSearches.map((search) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: AppSpacing.v8),
                          child: Row(
                            children: [
                              Icon(
                                Icons.history,
                                size: 18.sp,
                                color: AppColors.neutral500,
                              ),
                              SizedBox(width: AppSpacing.h10),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    _searchController.text = search;
                                    _searchController
                                        .selection = TextSelection.fromPosition(
                                      TextPosition(
                                        offset: _searchController.text.length,
                                      ),
                                    );

                                    _submitSearch(search);
                                  },
                                  child: Text(
                                    search,
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColors.neutral700,
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  _removeRecentSearch(search);
                                },
                                icon: Icon(
                                  Icons.close,
                                  size: 18.sp,
                                  color: AppColors.neutral500,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],

                // --------------------------------------------------
                // Explore more
                // --------------------------------------------------
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.h20,
                    AppSpacing.v22,
                    AppSpacing.h20,
                    AppSpacing.v12,
                  ),
                  child: Text(
                    'home.search.exploreMore'.tr(),
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColors.blackBase,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.h20),
                  child: Column(
                    children: [
                      for (
                        int index = 0;
                        index < homeState.events.length;
                        index++
                      ) ...[
                        _buildEventResultTile(homeState.events[index]),
                        if (index < homeState.events.length - 1)
                          SizedBox(height: AppSpacing.v12),
                      ],
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEventResultTile(EventEntity event) {
    final status = event.eventStatus;

    final imageUrl = event.coverImageUrl;

    return SearchEventResultTile(
      title: event.title,
      date: event.fromTime == null
          ? event.formattedDateShort
          : '${event.formattedDateShort} • ${event.formattedTime12Hour}',
      status: status['label'] as String,
      description: event.shortDescription ?? event.description,
      imageUrl: imageUrl,
      onTap: () {
        // TODO: Navigate to event details.
      },
    );
  }
}
