import 'package:flutter/material.dart';
import 'package:flutter_kanpur_ui_kit/flutter_kanpur_ui_kit.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/utils/text_styles.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/gradiant_background.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../application/my_events_provider.dart';
import '../../../application/my_events_state.dart';
import '../widgets/my_event_card.dart';
import '../widgets/pill_filter_tabs.dart';

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
              PillFilterTabs(
                labels: MyEventsTab.values.map((tab) => tab.label).toList(),
                selectedIndex: selectedTab.index,
                onChanged: (index) => ref
                    .read(myEventsSelectedTabProvider.notifier)
                    .select(MyEventsTab.values[index]),
              ),
              SizedBox(height: 16.h),
              Expanded(
                child: events.isEmpty
                    ? Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 32.w),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                selectedTab.emptyHeading,
                                textAlign: TextAlign.center,
                                style: textStyle_18BoldBlack(),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                selectedTab.emptySubheading,
                                textAlign: TextAlign.center,
                                style: textStyle_16RegularGrey(),
                              ),
                              SizedBox(height: 20.h),
                              SizedBox(
                                width: 220.w,
                                child: GradientButton(
                                  text: selectedTab.emptyActionLabel,
                                  height: 48.h,
                                  onTap: () => ref
                                      .read(
                                        myEventsSelectedTabProvider.notifier,
                                      )
                                      .select(selectedTab.emptyActionTarget),
                                ),
                              ),
                            ],
                          ),
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
                            onPreview: () {},
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
