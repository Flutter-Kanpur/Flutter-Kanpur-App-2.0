import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/router/route_names.dart';
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
        padding: const EdgeInsets.fromLTRB(22, 0, 22, 96),
        children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Community',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_outlined),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_vert),
            ),
          ],
        ),
        const SizedBox(height: 18),
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
              return const _EmptyTile(message: 'No discussions yet. Start one!');
            }
            return LayoutBuilder(
              builder: (context, constraints) {
                final cardWidth =
                    (constraints.maxWidth * 0.86).clamp(272.0, 300.0);
                return SizedBox(
                  height: 280,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    clipBehavior: Clip.none,
                    itemCount: questions.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 12),
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
        const SizedBox(height: 24),
        const FkSectionTitle(title: 'Contribute'),
        SizedBox(
          height: 232,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: CommunityContributeCard(
                  label: 'Open to all',
                  title: 'Upload Your Projects',
                  body: 'Share your projects with the community to showcase your work.',
                  onTap: () => context.go(RouteNames.communityUploadProject),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 6,
                      child: CommunityContributeCard(
                        label: 'Write for us',
                        body: 'Submit a blog request and contribute content that helps the community grow.',
                        onTap: () => context.go(RouteNames.blogs),
                      ),
                    ),
                    const SizedBox(height: 12),
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
        const SizedBox(height: 24),
        const FkSectionTitle(title: 'Community Stats'),
        const CommunityStatsPanel(),
        const SizedBox(height: 12),
        FkPrimaryButton(label: 'Join us on discord', onPressed: () {}),
        const SizedBox(height: 24),
        const FkSectionTitle(title: 'Our team'),
        membersAsync.when(
          loading: () => const SizedBox(
            height: 72,
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (_, __) => const SizedBox.shrink(),
          data: (members) => CommunityTeamCarousel(members: members),
        ),
        const SizedBox(height: 90),
        Text(
          'Built for the\nflutter\ncommunity!',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: AppColors.lightGrayText,
                fontWeight: FontWeight.w800,
                height: 1.28,
              ),
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Text('Crafted with ',
                style: Theme.of(context).textTheme.bodyMedium),
            const Icon(Icons.favorite, color: Colors.red, size: 18),
            Expanded(
              child: Text(
                ' by the Flutter Kanpur Community',
                style: Theme.of(context).textTheme.bodyMedium,
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red),
          const SizedBox(width: 10),
          Expanded(
            child: Text(message,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.red.shade700)),
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
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: Text(message,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppColors.subtitleTextDarkGrey)),
      ),
    );
  }
}
