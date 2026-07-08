import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/utils/text_styles.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/gradiant_background.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../application/my_events_provider.dart';
import '../widgets/my_event_card.dart';
import '../widgets/my_events_filter_tabs.dart';

class MyEventsScreen extends ConsumerWidget {
  const MyEventsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final events = ref.watch(myEventsFilteredProvider);
    final selectedTab = ref.watch(myEventsSelectedTabProvider);

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => context.pop(),
                      icon: Icon(
                        Icons.arrow_back,
                        size: 22.sp,
                        color: AppColors.textBlack,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text('My Events', style: textStyle_24BlackBold()),
                    SizedBox(height: 8.h),
                    Text(
                      "Events you've registered for and attended.",
                      style: textStyle_16RegularGrey(),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              MyEventsFilterTabs(
                selectedTab: selectedTab,
                onChanged: (tab) =>
                    ref.read(myEventsSelectedTabProvider.notifier).select(tab),
              ),
              SizedBox(height: 16.h),
              Expanded(
                child: events.isEmpty
                    ? Center(
                        child: Text(
                          'No events here yet.',
                          style: textStyle_16RegularGrey(),
                        ),
                      )
                    : ListView.separated(
                        padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 24.h),
                        itemCount: events.length,
                        separatorBuilder: (_, __) => SizedBox(height: 16.h),
                        itemBuilder: (context, index) {
                          final event = events[index];
                          return MyEventCard(
                            event: event,
                            onToggleSaved: () => ref
                                .read(myEventsProvider.notifier)
                                .toggleSaved(event.id),
                            onViewDetails: () {},
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
