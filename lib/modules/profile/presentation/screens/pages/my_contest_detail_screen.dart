import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kanpur_ui_kit/flutter_kanpur_ui_kit.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/gradiant_background.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../application/my_contests_provider.dart';
import '../../../application/my_contests_state.dart';

void _shareContest(MyContest contest) {
  final message = [
    contest.title,
    contest.categoryLabel,
    contest.scheduleLabel,
    '${contest.metaLabel} ${contest.metaValue}',
    contest.tags.join(' • '),
  ].join('\n');

  SharePlus.instance.share(ShareParams(text: message, subject: contest.title));
}

void _addToCalendar(MyContest contest) {
  final event = Event(
    title: contest.title,
    description: [contest.categoryLabel, ...contest.whatYoullDo].join('\n'),
    location: contest.tags.contains('Online') ? 'Online' : '',
    startDate: contest.startDate,
    endDate: contest.endDate,
  );
  Add2Calendar.addEvent2Cal(event);
}

class MyContestDetailScreen extends ConsumerWidget {
  const MyContestDetailScreen({super.key, required this.contestId});

  final String contestId;

  TextStyle _metaValueStyle(MyContestMetaTone tone) {
    return switch (tone) {
      MyContestMetaTone.urgent => textStyle_16RedRegular(),
      MyContestMetaTone.positive => textStyle_16RegularBlack().copyWith(
        color: AppColors.green,
      ),
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contest = ref.watch(myContestByIdProvider(contestId));

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          forceMaterialTransparency: true,
          centerTitle: true,
          leading: IconButton(
            onPressed: () => context.pop(),
            icon: Icon(
              Icons.arrow_back,
              size: 22.sp,
              color: AppColors.textBlack,
            ),
          ),
          title: Text('Contest details', style: textStyle_18BlackMedium()),
        ),
        body: contest == null
            ? Center(
                child: Text(
                  'Contest not found.',
                  style: textStyle_16RegularGrey(),
                ),
              )
            : SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 32.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(contest.title, style: textStyle_24BlackBold()),
                    SizedBox(height: 4.h),
                    Text(
                      contest.categoryLabel,
                      style: textStyle_16RegularGrey(),
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      children: [
                        _OutlinedPillButton(
                          icon: Icons.share_outlined,
                          label: 'Share',
                          onTap: () => _shareContest(contest),
                        ),
                        SizedBox(width: 12.w),
                        _OutlinedPillButton(
                          icon: contest.isSaved
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          label: contest.isSaved ? 'Saved' : 'Save',
                          onTap: () => ref
                              .read(myContestsProvider.notifier)
                              .toggleSaved(contest.id),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      contest.scheduleLabel,
                      style: textStyle_16RegularBlack(),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '${contest.metaLabel} ${contest.metaValue}',
                      style: _metaValueStyle(contest.metaTone),
                    ),
                    SizedBox(height: 16.h),
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: contest.tags
                          .map(
                            (tag) => Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 8.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.bgPrimary,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Text(
                                tag,
                                style: textStyle_14RegularBlack(),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    SizedBox(height: 20.h),
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: AppColors.communityBorder,
                    ),
                    SizedBox(height: 20.h),
                    Text('What You\'ll Do', style: textStyle_18BlackMedium()),
                    SizedBox(height: 12.h),
                    _BulletList(items: contest.whatYoullDo),
                    SizedBox(height: 20.h),
                    Text(
                      'Rewards & Outcomes',
                      style: textStyle_18BlackMedium(),
                    ),
                    SizedBox(height: 12.h),
                    _BulletList(items: contest.rewardsAndOutcomes),
                    SizedBox(height: 32.h),
                    GradientButton(
                      text: 'Add to Calendar',
                      height: 48.h,
                      onTap: () => _addToCalendar(contest),
                      textStyle: textStyle_14SemiBoldWhite(),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class _OutlinedPillButton extends StatelessWidget {
  const _OutlinedPillButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(100),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: AppColors.contributorFieldBorder),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18.sp, color: AppColors.textBlack),
              SizedBox(width: 6.w),
              Text(label, style: textStyle_16MediumBlack()),
            ],
          ),
        ),
      ),
    );
  }
}

class _BulletList extends StatelessWidget {
  const _BulletList({required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map(
            (item) => Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('•  ', style: textStyle_14RegularGrey()),
                  Expanded(child: Text(item, style: textStyle_14RegularGrey())),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
