import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/router/route_names.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/application/community_provider.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/presentation/widgets/community_ask_banner.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/presentation/widgets/community_contribute_section.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/presentation/widgets/community_discussion_card.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/presentation/widgets/community_stats_panel.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/presentation/widgets/community_team_carousel.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_primary_button.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_screen.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_section_title.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';

class CommunityScreen extends ConsumerWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questionsAsync = ref.watch(questionsProvider);
    final membersAsync = ref.watch(communityMembersProvider);

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(questionsProvider.notifier).refresh();
        await ref.read(communityMembersProvider.notifier).refresh();
      },
      child: FkScreen(
        padding: EdgeInsets.fromLTRB(AppSpacing.h22, 0, AppSpacing.h22, 96),
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Community', style: AppTextStyles.titleLarge),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_outlined),
              ),
              IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
            ],
          ),
          SizedBox(height: AppSpacing.v18),
          CommunityAskBanner(
            onTap: () => context.go(RouteNames.communityAskQuestion),
          ),
          FkSectionTitle(
            title: 'Featured discussions',
            actionLabel: 'Explore all',
            onActionTap: () => context.go(RouteNames.communityDiscussions),
          ),
          questionsAsync.when(
            loading: () => const SizedBox(
              height: 200,
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => _ErrorTile(
              message: 'Could not load discussions.',
              onRetry: () => ref.read(questionsProvider.notifier).refresh(),
            ),
            data: (questions) {
              if (questions.isEmpty) {
                return const _EmptyTile(
                  message: 'No discussions yet. Start one!',
                );
              }
              return LayoutBuilder(
                builder: (context, constraints) {
                  final cardWidth = (constraints.maxWidth * 0.90);
                  return SizedBox(
                    height: 280,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      clipBehavior: Clip.none,
                      itemCount: questions.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(width: AppSpacing.h12),
                      itemBuilder: (_, i) => CommunityDiscussionCard(
                        question: questions[i],
                        width: cardWidth,
                        onTap: () => context.push(
                          '${RouteNames.communityDiscussionDetail}/${questions[i].id}',
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
                    onTap: () => context.go(RouteNames.communityUploadProject),
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
                          onTap: () => context.go(RouteNames.profile),
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
          FkPrimaryButton(label: 'Join us on discord', onPressed: () {}),
          SizedBox(height: AppSpacing.v22),
          const FkSectionTitle(title: 'Our team'),
          membersAsync.when(
            loading: () => const SizedBox(
              height: 72,
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (_, __) => const SizedBox.shrink(),
            data: (members) => CommunityTeamCarousel(members: members),
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

class _ErrorTile extends StatelessWidget {
  const _ErrorTile({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.all(AppSpacing.h16),
      decoration: BoxDecoration(
        color: AppColors.warning50,
        borderRadius: AppRadius.all03,
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.warning600),
          SizedBox(width: AppSpacing.h10),
          Expanded(
            child: Text(
              message,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.warning700),
            ),
          ),
          TextButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}

class _EmptyTile extends StatelessWidget {
  const _EmptyTile({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.v16),
      child: Center(
        child: Text(
          message,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.neutral500),
        ),
      ),
    );
  }
}
