import 'package:flutter_knp_mobile_app_v2/modules/home/domain/entities/event_entity.dart';

class HomeState {
  const HomeState({
    this.isLoading = false,
    this.events = const [],
    this.selectedFilterIndex = 0,
    this.selectedFilters = const {},
    this.searchQuery = '',
    this.recentSearches = const [],
    this.currentAnnouncementPage = 0,
  });

  // Loading
  final bool isLoading;

  // Events
  final List<EventEntity> events;

  // Filter tabs
  final int selectedFilterIndex;

  // Applied filters
  final Map<String, Set<String>> selectedFilters;

  // Search
  final String searchQuery;
  final List<String> recentSearches;

  // Announcement carousel
  final int currentAnnouncementPage;

  int get selectedFiltersCount {
    return selectedFilters.values.fold(
      0,
      (total, filters) => total + filters.length,
    );
  }

  List<EventEntity> get filteredEvents {
    if (selectedFilters.isEmpty) {
      return events;
    }

    return events.where((event) {
      //STATUS-BASED

      final statusFilters = selectedFilters['Status-based'];

      if (statusFilters != null && statusFilters.isNotEmpty) {
        final matchesStatus = statusFilters.any((filter) {
          switch (filter) {
            case 'Upcoming':
              return event.isUpcoming && !event.isRunning;

            case 'Live':
              return event.isRunning;

            case 'Past':
              return event.isPast;

            default:
              return false;
          }
        });

        if (!matchesStatus) {
          return false;
        }
      }

      // MODE / FORMAT

      final modeFilters = selectedFilters['Mode / Format'];

      if (modeFilters != null && modeFilters.isNotEmpty) {
        final matchesMode = modeFilters.contains(event.mode);

        if (!matchesMode) {
          return false;
        }
      }

      // TIME-BASED

      final timeFilters = selectedFilters['Time-based'];

      if (timeFilters != null && timeFilters.isNotEmpty) {
        if (event.fromTime == null) {
          return false;
        }

        final now = DateTime.now();

        final matchesTime = timeFilters.any((filter) {
          switch (filter) {
            case 'This Week':
              final startOfWeek = DateTime(
                now.year,
                now.month,
                now.day,
              ).subtract(Duration(days: now.weekday - 1));

              final endOfWeek = startOfWeek.add(const Duration(days: 7));

              return !event.fromTime!.isBefore(startOfWeek) &&
                  event.fromTime!.isBefore(endOfWeek);

            case 'This Month':
              return event.fromTime!.year == now.year &&
                  event.fromTime!.month == now.month;

            default:
              return false;
          }
        });

        if (!matchesTime) {
          return false;
        }
      }

      // ACCESS

      final accessFilters = selectedFilters['Access'];

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

        if (!matchesAccess) {
          return false;
        }
      }

      final interestFilters = selectedFilters['Interest / Type'];

      if (interestFilters != null && interestFilters.isNotEmpty) {
        final matchesInterest = interestFilters.any(
          (filter) => event.interests.contains(filter),
        );

        if (!matchesInterest) {
          return false;
        }
      }

      // EVENT PASSES ALL ACTIVE FILTER GROUPS

      return true;
    }).toList();
  }

  HomeState copyWith({
    bool? isLoading,
    List<EventEntity>? events,
    int? selectedFilterIndex,
    Map<String, Set<String>>? selectedFilters,
    String? searchQuery,
    List<String>? recentSearches,
    int? currentAnnouncementPage,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      events: events ?? this.events,
      selectedFilterIndex: selectedFilterIndex ?? this.selectedFilterIndex,
      selectedFilters: selectedFilters ?? this.selectedFilters,
      searchQuery: searchQuery ?? this.searchQuery,
      recentSearches: recentSearches ?? this.recentSearches,
      currentAnnouncementPage:
          currentAnnouncementPage ?? this.currentAnnouncementPage,
    );
  }
}
