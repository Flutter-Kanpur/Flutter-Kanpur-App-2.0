import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/router/route_names.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/utils/text_styles.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/gradiant_background.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../application/my_contests_provider.dart';
import '../../../application/my_contests_state.dart';
import '../widgets/my_contest_card.dart';
import '../widgets/pill_filter_tabs.dart';

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
                    Text('My Contests', style: textStyle_24BlackBold()),
                    SizedBox(height: 8.h),
                    Text(
                      "Contests you've participated in or registered for.",
                      style: textStyle_16RegularGrey(),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              PillFilterTabs(
                labels: MyContestsTab.values.map((tab) => tab.label).toList(),
                selectedIndex: selectedTab.index,
                onChanged: (index) => ref
                    .read(myContestsSelectedTabProvider.notifier)
                    .select(MyContestsTab.values[index]),
              ),
              SizedBox(height: 16.h),
              Expanded(
                child: contests.isEmpty
                    ? Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 32.w),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'No contests yet',
                                style: textStyle_18BoldBlack(),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                "You haven't participated in any contests yet. "
                                'Join one to get started.',
                                textAlign: TextAlign.center,
                                style: textStyle_16RegularGrey(),
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 24.h),
                        itemCount: contests.length,
                        separatorBuilder: (_, __) => SizedBox(height: 16.h),
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
