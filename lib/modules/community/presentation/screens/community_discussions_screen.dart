import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/router/route_names.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/application/community_provider.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/presentation/widgets/community_filter_row.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/presentation/widgets/discussion_list_item.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_primary_button.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_screen.dart';
import 'package:flutter_knp_mobile_app_v2/utils/colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Local filter state for the discussions screen.
final _discussionFilterProvider =
    NotifierProvider<DiscussionFilterNotifier, String?>(
  DiscussionFilterNotifier.new,
);

class DiscussionFilterNotifier extends Notifier<String?> {
  @override
  String? build() => null;
  void update(String? value) => state = value;
}

class CommunityDiscussionsScreen extends ConsumerWidget {
  const CommunityDiscussionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questionsAsync = ref.watch(questionsProvider);
    final activeFilter = ref.watch(_discussionFilterProvider);

    return FkScreen(
      padding: const EdgeInsets.fromLTRB(22, 12, 22, 96),
      children: [
        // Top bar
        Row(
          children: [
            IconButton(
              onPressed: () => context.go(RouteNames.community),
              icon: const Icon(Icons.arrow_back),
            ),
            Expanded(
              child: Text(
                'Discussions',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_horiz),
            ),
          ],
        ),
        const SizedBox(height: 28),
        FkPrimaryButton(
          label: 'Start a new discussion',
          onPressed: () => context.go(RouteNames.communityAskQuestion),
        ),
        const SizedBox(height: 18),
        CommunityFilterRow(
          selected: activeFilter,
          onSelected: (filter) {
            ref.read(_discussionFilterProvider.notifier).state = filter;
            ref.read(questionsProvider.notifier).setFilter(filter);
          },
        ),
        const SizedBox(height: 16),
        questionsAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 48),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (e, _) => _ErrorView(
            onRetry: () => ref.read(questionsProvider.notifier).refresh(),
          ),
          data: (questions) {
            if (questions.isEmpty) {
              return const _EmptyView();
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${questions.length} discussions',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.subtitleTextDarkGrey,
                      ),
                ),
                const SizedBox(height: 16),
                ...questions.map(
                  (q) => DiscussionListItem(
                    question: q,
                    onTap: () =>
                        context.go(RouteNames.communityDiscussionDetail),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          const Icon(Icons.wifi_off_rounded, size: 48, color: Colors.grey),
          const SizedBox(height: 12),
          Text(
            'Could not load discussions',
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: AppColors.subtitleTextDarkGrey),
          ),
          const SizedBox(height: 16),
          TextButton(onPressed: onRetry, child: const Text('Try again')),
        ],
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Center(
        child: Text(
          'No discussions yet.\nBe the first to start one!',
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: AppColors.subtitleTextDarkGrey),
        ),
      ),
    );
  }
}
