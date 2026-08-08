import 'package:flutter/material.dart';
import 'package:flutter_kanpur_ui_kit/flutter_kanpur_ui_kit.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/gradiant_background.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../application/my_events_provider.dart';
import '../../../application/my_events_state.dart';
import '../widgets/my_event_card.dart';
import '../widgets/pill_filter_tabs.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';

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
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.h20,
                  AppSpacing.h8,
                  AppSpacing.h20,
                  0,
                ),
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
                        color: AppColors.blackBase,
                      ),
                    ),
                    SizedBox(height: AppSpacing.v16),
                    Text(
                      'My Events',
                      style: AppTextStyles.headlineSmall.copyWith(
                        color: AppColors.blackBase,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: AppSpacing.v8),
                    Text(
                      "Events you've registered for and attended.",
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.neutral500,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.v20),
              PillFilterTabs(
                labels: MyEventsTab.values.map((tab) => tab.label).toList(),
                selectedIndex: selectedTab.index,
                onChanged: (index) => ref
                    .read(myEventsSelectedTabProvider.notifier)
                    .select(MyEventsTab.values[index]),
              ),
              SizedBox(height: AppSpacing.v16),
              Expanded(
                child: events.isEmpty
                    ? Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSpacing.h22,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                selectedTab.emptyHeading,
                                textAlign: TextAlign.center,
                                style: AppTextStyles.titleLarge.copyWith(
                                  color: AppColors.blackBase,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: AppSpacing.v8),
                              Text(
                                selectedTab.emptySubheading,
                                textAlign: TextAlign.center,
                                style: AppTextStyles.bodyLarge.copyWith(
                                  color: AppColors.neutral500,
                                ),
                              ),
                              SizedBox(height: AppSpacing.v20),
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
                        padding: EdgeInsets.fromLTRB(
                          AppSpacing.h20,
                          0,
                          AppSpacing.h20,
                          AppSpacing.h22,
                        ),
                        itemCount: events.length,
                        separatorBuilder: (_, __) =>
                            SizedBox(height: AppSpacing.v16),
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
