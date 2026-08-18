import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_knp_mobile_app_v2/modules/home/application/home_state.dart';
import 'package:flutter_knp_mobile_app_v2/modules/home/application/data/mock/home_mock_data.dart';
import 'package:flutter_knp_mobile_app_v2/modules/home/domain/entities/event_entity.dart';

final homeProvider = NotifierProvider<HomeNotifier, HomeState>(
  HomeNotifier.new,
);

class HomeNotifier extends Notifier<HomeState> {
  @override
  HomeState build() {
    final initialEvents = HomeMockData.events;

    return HomeState(events: initialEvents, isLoading: false);
  }

  // --------------------------------------------------
  // Loading
  // --------------------------------------------------

  void setLoading(bool value) {
    state = state.copyWith(isLoading: value);
  }

  // --------------------------------------------------
  // Announcement carousel
  // --------------------------------------------------

  void setAnnouncementPage(int page) {
    state = state.copyWith(currentAnnouncementPage: page);
  }

  // --------------------------------------------------
  // Filter tabs
  // --------------------------------------------------

  void selectFilterTab(int index) {
    if (state.selectedFilterIndex == index) {
      state = state.copyWith(selectedFilterIndex: 0);
    } else {
      state = state.copyWith(selectedFilterIndex: index);
    }
  }

  void clearFilterTab(int index) {
    String? filterToRemove;

    switch (index) {
      case 3:
        filterToRemove = 'Upcoming';
        break;

      case 4:
        filterToRemove = 'Past';
        break;

      default:
        return;
    }

    final updatedFilters = <String, Set<String>>{
      for (final entry in state.selectedFilters.entries)
        entry.key: Set<String>.from(entry.value),
    };

    final statusFilters = updatedFilters['Status-based'];

    if (statusFilters != null) {
      statusFilters.remove(filterToRemove);

      if (statusFilters.isEmpty) {
        updatedFilters.remove('Status-based');
      }
    }

    state = state.copyWith(
      selectedFilterIndex: 0,
      selectedFilters: updatedFilters,
    );
  }

  // --------------------------------------------------
  // Filters
  // --------------------------------------------------

  void toggleFilter(String section, String option) {
    final updatedFilters = <String, Set<String>>{...state.selectedFilters};

    final selectedOptions = <String>{
      ...(updatedFilters[section] ?? <String>{}),
    };

    if (selectedOptions.contains(option)) {
      selectedOptions.remove(option);
    } else {
      selectedOptions.add(option);
    }

    if (selectedOptions.isEmpty) {
      updatedFilters.remove(section);
    } else {
      updatedFilters[section] = selectedOptions;
    }

    state = state.copyWith(selectedFilters: updatedFilters);
  }

  void setFilters(Map<String, Set<String>> filters) {
    state = state.copyWith(
      selectedFilters: {
        for (final entry in filters.entries)
          entry.key: Set<String>.from(entry.value),
      },
    );
  }

  void clearFilters() {
    state = state.copyWith(selectedFilters: const {});
  }

  List<EventEntity> get filteredEvents {
    final filters = state.selectedFilters;

    if (filters.isEmpty) {
      return state.events;
    }

    return state.events.where((event) {
      // --------------------------------------------
      // Status-based
      // OR within the same section
      // --------------------------------------------
      final statusFilters = filters['Status-based'];

      if (statusFilters != null && statusFilters.isNotEmpty) {
        final matchesStatus = statusFilters.any((filter) {
          switch (filter) {
            case 'Upcoming':
              return event.isUpcoming;

            case 'Live':
              return event.isRunning;

            case 'Past':
              return event.isPast;

            default:
              return false;
          }
        });

        if (!matchesStatus) return false;
      }

      // --------------------------------------------
      // Mode / Format
      // --------------------------------------------
      final modeFilters = filters['Mode / Format'];

      if (modeFilters != null && modeFilters.isNotEmpty) {
        final matchesMode = modeFilters.any((filter) => event.mode == filter);

        if (!matchesMode) return false;
      }

      // --------------------------------------------
      // Time-based
      // --------------------------------------------
      final timeFilters = filters['Time-based'];

      if (timeFilters != null && timeFilters.isNotEmpty) {
        final matchesTime = timeFilters.any(
          (filter) => _matchesTimeFilter(event, filter),
        );

        if (!matchesTime) return false;
      }

      // --------------------------------------------
      // Access
      // --------------------------------------------
      final accessFilters = filters['Access'];

      if (accessFilters != null && accessFilters.isNotEmpty) {
        final matchesAccess = accessFilters.any((filter) {
          switch (filter) {
            case 'Free':
              return event.isFree;

            case 'Open to All':
              return event.isOpenToAll;

            default:
              return false;
          }
        });

        if (!matchesAccess) return false;
      }

      // --------------------------------------------
      // Interest / Type
      // --------------------------------------------
      final interestFilters = filters['Interest / Type'];

      if (interestFilters != null && interestFilters.isNotEmpty) {
        final matchesInterest = interestFilters.any(
          (filter) => event.interests.contains(filter),
        );

        if (!matchesInterest) return false;
      }

      return true;
    }).toList();
  }

  bool _matchesTimeFilter(EventEntity event, String filter) {
    final date = event.fromTime;

    if (date == null) {
      return false;
    }

    final now = DateTime.now();

    switch (filter) {
      case 'This Week':
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));

        final start = DateTime(
          startOfWeek.year,
          startOfWeek.month,
          startOfWeek.day,
        );

        final end = start.add(const Duration(days: 7));

        return !date.isBefore(start) && date.isBefore(end);

      case 'This Month':
        final start = DateTime(now.year, now.month);
        final end = DateTime(now.year, now.month + 1);

        return !date.isBefore(start) && date.isBefore(end);

      default:
        return false;
    }
  }

  // --------------------------------------------------
  // Search
  // --------------------------------------------------

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void addRecentSearch(String search) {
    final value = search.trim();

    if (value.isEmpty) {
      return;
    }

    final updated = [
      value,
      ...state.recentSearches.where((item) => item != value),
    ];

    state = state.copyWith(recentSearches: updated);
  }

  void removeRecentSearch(String search) {
    final updated = [...state.recentSearches]..remove(search);

    state = state.copyWith(recentSearches: updated);
  }

  void clearRecentSearches() {
    state = state.copyWith(recentSearches: const []);
  }

  // --------------------------------------------------
  // Events
  // --------------------------------------------------

  void setEvents(List<EventEntity> events) {
    state = state.copyWith(events: List<EventEntity>.from(events));
  }
}
