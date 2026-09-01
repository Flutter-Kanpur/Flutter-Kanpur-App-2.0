import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_knp_mobile_app_v2/app/router/community_upload_routes.dart';
import 'package:flutter_knp_mobile_app_v2/app/router/route_names.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/application/community_provider.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/application/notifications_provider.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/data/community_error_message.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/presentation/widgets/community_ask_banner.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/presentation/widgets/community_async_views.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/presentation/widgets/community_contribute_section.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/presentation/widgets/community_discussion_card.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/presentation/widgets/community_stats_panel.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/presentation/widgets/community_team_carousel.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_primary_button.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_screen.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_section_title.dart';
import 'package:flutter_knp_mobile_app_v2/utils/assets_path.dart';
import 'package:flutter_knp_mobile_app_v2/utils/external_links.dart';

/// Runs a like / bookmark toggle and reports failure.
///
/// [CommunityEngagement] rolls its optimistic update back on error and returns
/// the error rather than throwing, so without this the icon would silently
/// flip back with no explanation.
Future<void> _runEngagement(
  BuildContext context,
  Future<Object?> Function() action,
  String fallback,
) async {
  // Captured before the await so context is not used across the async gap.
  final messenger = ScaffoldMessenger.of(context);
  final error = await action();
  if (error == null) return;

  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(describeCommunityError(error, fallback: fallback)),
        backgroundColor: AppColors.warning600,
      ),
    );
}

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
        padding: EdgeInsets.fromLTRB(
          AppSpacing.h22,
          AppSpacing.h20,
          AppSpacing.h8,
          AppSpacing.h8,
        ),
        children: [
          const _CommunityAppBar(),
          SizedBox(height: AppSpacing.v18),

          CommunityAskBanner(
            onAskQuestion: () => context.push(RouteNames.communityAskQuestion),
            // Real member photos when they have loaded; the stack is simply
            // omitted until then rather than showing placeholder faces.
            memberPhotoUrls:
                membersAsync.value
                    ?.map((m) => m.photoUrl)
                    .whereType<String>()
                    .where((url) => url.isNotEmpty)
                    .take(4)
                    .toList() ??
                const [],
          ),
          SizedBox(height: AppSpacing.v12),
          FkSectionTitle(
            title: 'Featured discussions',
            actionLabel: 'Explore all',
            onActionTap: () => context.push(RouteNames.communityDiscussions),
          ),
          questionsAsync.when(
            loading: () => const CommunityLoadingView(height: 280),
            error: (e, _) => CommunityErrorView(
              compact: true,
              error: e,
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
                        onLike: () => _runEngagement(
                          context,
                          () => ref
                              .read(communityEngagementProvider)
                              .toggleQuestionLike(featured[i]),
                          'Could not update your like.',
                        ),
                        onSave: () => _runEngagement(
                          context,
                          () => ref
                              .read(communityEngagementProvider)
                              .toggleQuestionSave(featured[i]),
                          'Could not update your bookmark.',
                        ),
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
                        openCommunityUploadProject(context),
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
          const FkSectionTitle(title: 'Active Contributors'),
          membersAsync.when(
            loading: () => const CommunityLoadingView(height: 72),
            error: (e, _) => CommunityErrorView(
              compact: true,
              error: e,
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
              color: AppColors.neutral950,
            ),
          ),
        ),
        // IconButton(
        //   onPressed: () => context.push(RouteNames.notifications),
        //   tooltip: 'Notifications',
        //   icon: Badge(
        //     isLabelVisible: unread > 0,
        //     label: Text(unread > 99 ? '99+' : '$unread'),
        //     backgroundColor: AppColors.warning600,
        //     child: SvgPicture.asset(
        //       AssetsPath.notificationIcon,
        //       width: 24,
        //       height: 24,
        //     ),
        //   ),
        // ),
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
