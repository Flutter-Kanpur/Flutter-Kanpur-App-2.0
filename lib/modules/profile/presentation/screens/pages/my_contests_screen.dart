import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/router/route_names.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/gradiant_background.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../application/my_contests_provider.dart';
import '../../../application/my_contests_state.dart';
import '../widgets/my_contest_card.dart';
import '../widgets/pill_filter_tabs.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';

class MyContestsScreen extends ConsumerWidget {
  const MyContestsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contests = ref.watch(myContestsFilteredProvider);
    final selectedTab = ref.watch(myContestsSelectedTabProvider);

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(AppSpacing.h20, AppSpacing.h8, AppSpacing.h20, 0),
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
                    Text('My Contests', style: AppTextStyles.headlineSmall.copyWith(color: AppColors.blackBase, fontWeight: FontWeight.bold)),
                    SizedBox(height: AppSpacing.v8),
                    Text(
                      "Contests you've participated in or registered for.",
                      style: AppTextStyles.bodyLarge.copyWith(color: AppColors.neutral500),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.v20),
              PillFilterTabs(
                labels: MyContestsTab.values.map((tab) => tab.label).toList(),
                selectedIndex: selectedTab.index,
                onChanged: (index) => ref
                    .read(myContestsSelectedTabProvider.notifier)
                    .select(MyContestsTab.values[index]),
              ),
              SizedBox(height: AppSpacing.v16),
              Expanded(
                child: contests.isEmpty
                    ? Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: AppSpacing.h22),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'No contests yet',
                                style: AppTextStyles.titleLarge.copyWith(color: AppColors.blackBase, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: AppSpacing.v8),
                              Text(
                                "You haven't participated in any contests yet. "
                                'Join one to get started.',
                                textAlign: TextAlign.center,
                                style: AppTextStyles.bodyLarge.copyWith(color: AppColors.neutral500),
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: EdgeInsets.fromLTRB(AppSpacing.h20, 0, AppSpacing.h20, AppSpacing.h22),
                        itemCount: contests.length,
                        separatorBuilder: (_, __) => SizedBox(height: AppSpacing.v16),
                        itemBuilder: (context, index) {
                          final contest = contests[index];
                          return MyContestCard(
                            contest: contest,
                            onToggleSaved: () => ref
                                .read(myContestsProvider.notifier)
                                .toggleSaved(contest.id),
                            onAction: () {},
                            onTap: () => context.push(
                              '${RouteNames.myContests}/${contest.id}',
                            ),
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
