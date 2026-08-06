import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_knp_mobile_app_v2/app/router/route_names.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/application/community_provider.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/application/notifications_provider.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/presentation/widgets/community_ask_banner.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/presentation/widgets/community_async_views.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/presentation/widgets/community_contribute_section.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/presentation/widgets/community_discussion_card.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/presentation/widgets/community_stats_panel.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/presentation/widgets/community_team_carousel.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_primary_button.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_screen.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_section_title.dart';
import 'package:flutter_knp_mobile_app_v2/utils/external_links.dart';

class CommunityScreen extends ConsumerWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questionsAsync = ref.watch(questionsProvider);
    final membersAsync = ref.watch(communityMembersProvider);

    return RefreshIndicator(
      onRefresh: () async {
        // Run both refreshes together instead of one after the other, so
        // pull-to-refresh finishes in one round trip's time, not two.
        await Future.wait([
          ref.read(questionFeedProvider.notifier).refresh(),
          ref.read(communityMembersProvider.notifier).refresh(),
          ref.read(notificationsProvider.notifier).refresh(),
        ]);
      },
      child: FkScreen(
        padding: EdgeInsets.fromLTRB(AppSpacing.h22, 0, AppSpacing.h22, 96),
        children: [
          const _CommunityAppBar(),
          SizedBox(height: AppSpacing.v18),

          CommunityAskBanner(
            onTap: () => context.push(RouteNames.communityAskQuestion),
          ),

          FkSectionTitle(
            title: 'Featured discussions',
            actionLabel: 'Explore all',
            onActionTap: () => context.push(RouteNames.communityDiscussions),
          ),
          questionsAsync.when(
            loading: () => const CommunityLoadingView(height: 280),
            error: (e, _) => CommunityErrorView(
              compact: true,
              message: 'Could not load discussions.',
              onRetry: () => ref.read(questionFeedProvider.notifier).refresh(),
            ),
            data: (questions) {
              if (questions.isEmpty) {
                return CommunityEmptyView(
                  message: 'No discussions yet.',
                  actionLabel: 'Start one',
                  onAction: () =>
                      context.push(RouteNames.communityAskQuestion),
                );
              }
              // Carousel shows the newest handful; "Explore all" has the rest.
              final featured = questions.take(10).toList();
              return LayoutBuilder(
                builder: (context, constraints) {
                  final cardWidth = constraints.maxWidth * 0.90;
                  return SizedBox(
                    height: 300,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      clipBehavior: Clip.none,
                      itemCount: featured.length,
                      separatorBuilder: (_, _) =>
                          SizedBox(width: AppSpacing.h12),
                      itemBuilder: (_, i) => CommunityDiscussionCard(
                        question: featured[i],
                        width: cardWidth,
                        onTap: () => context.push(
                          '${RouteNames.communityDiscussionDetail}/${featured[i].id}',
                        ),
                        onLike: () => ref
                            .read(communityEngagementProvider)
                            .toggleQuestionLike(featured[i]),
                        onSave: () => ref
                            .read(communityEngagementProvider)
                            .toggleQuestionSave(featured[i]),
                      ),
                    ),
                  );
                },
              );
            },
          ),

          SizedBox(height: AppSpacing.v22),
          const FkSectionTitle(title: 'Contribute'),
          SizedBox(
            height: 300,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 3,
                  child: CommunityContributeCard(
                    label: 'Open to all',
                    title: 'Upload Your Projects',
                    body:
                        'Share your projects with the community to showcase your work.',
                    onTap: () =>
                        context.push(RouteNames.communityUploadProject),
                  ),
                ),
                SizedBox(width: AppSpacing.h12),
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        flex: 6,
                        child: CommunityContributeCard(
                          label: 'Write for us',
                          body:
                              'Submit a blog request and contribute content that helps the community grow.',
                          onTap: () => context.go(RouteNames.blogs),
                        ),
                      ),
                      SizedBox(height: AppSpacing.v12),
                      Expanded(
                        flex: 4,
                        child: CommunityContributeCard(
                          label: 'Get involved',
                          body: 'Join as a Contributor',
                          // Was pointing at /profile, which is not the
                          // contributor flow.
                          onTap: () => context.push(RouteNames.joinContributor),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: AppSpacing.v22),
          const FkSectionTitle(title: 'Community Stats'),
          const CommunityStatsPanel(),
          SizedBox(height: AppSpacing.v12),
          FkPrimaryButton(
            label: 'Join us on discord',
            onPressed: () => openExternalUrlOrNotify(
              context,
              ExternalLinks.discordInvite,
              failureMessage: "Couldn't open Discord. Is it installed?",
            ),
          ),

          SizedBox(height: AppSpacing.v22),
          const FkSectionTitle(title: 'Our team'),
          membersAsync.when(
            loading: () => const CommunityLoadingView(height: 72),
            error: (_, _) => CommunityErrorView(
              compact: true,
              message: 'Could not load members.',
              onRetry: () =>
                  ref.read(communityMembersProvider.notifier).refresh(),
            ),
            data: (members) => members.isEmpty
                ? const CommunityEmptyView(message: 'No members listed yet.')
                : CommunityTeamCarousel(members: members),
          ),

          SizedBox(height: 4 * AppSpacing.v22),
          Text(
            'Built for the\nflutter\ncommunity!',
            style: AppTextStyles.displayMedium.copyWith(
              color: AppColors.neutral200,
            ),
          ),
          SizedBox(height: AppSpacing.v18),
          Row(
            children: [
              Text('Crafted with ', style: AppTextStyles.bodyMedium),
              const Icon(Icons.favorite, color: AppColors.warning600),
              Expanded(
                child: Text(
                  ' by the Flutter Kanpur Community',
                  style: AppTextStyles.bodyMedium,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Title, notification bell with unread badge, and overflow menu.
class _CommunityAppBar extends ConsumerWidget {
  const _CommunityAppBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unread = ref.watch(unreadNotificationCountProvider);

    return Row(
      children: [
        Expanded(
          child: Text(
            'Community',
            style: AppTextStyles.titleLarge.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.neutral950,
            ),
          ),
        ),
        IconButton(
          onPressed: () => context.push(RouteNames.communityNotifications),
          tooltip: 'Notifications',
          icon: Badge(
            isLabelVisible: unread > 0,
            label: Text(unread > 99 ? '99+' : '$unread'),
            backgroundColor: AppColors.warning600,
            child: const Icon(
              Icons.notifications_none_rounded,
              color: AppColors.neutral950,
            ),
          ),
        ),
        _CommunityOverflowMenu(),
      ],
    );
  }
}

class _CommunityOverflowMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: 'More',
      icon: const Icon(Icons.more_vert_rounded, color: AppColors.neutral950),
      shape: RoundedRectangleBorder(borderRadius: AppRadius.all03),
      onSelected: (value) {
        switch (value) {
          case 'guidelines':
            context.push(RouteNames.communityGuidelines);
          case 'members':
            context.push(RouteNames.communityMembers);
          case 'projects':
            context.push(RouteNames.communityProjects);
          case 'discord':
            openExternalUrlOrNotify(context, ExternalLinks.discordInvite);
        }
      },
      itemBuilder: (context) => const [
        PopupMenuItem(
          value: 'guidelines',
          child: ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.rule_rounded),
            title: Text('Community guidelines'),
          ),
        ),
        PopupMenuItem(
          value: 'members',
          child: ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.groups_outlined),
            title: Text('Members'),
          ),
        ),
        PopupMenuItem(
          value: 'projects',
          child: ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.folder_copy_outlined),
            title: Text('Projects'),
          ),
        ),
        PopupMenuItem(
          value: 'discord',
          child: ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.discord_outlined),
            title: Text('Join us on Discord'),
          ),
        ),
      ],
    );
  }
}
