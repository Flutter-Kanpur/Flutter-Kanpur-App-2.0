import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/router/route_names.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/application/community_provider.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/presentation/widgets/community_filter_row.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/presentation/widgets/discussion_list_item.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_primary_button.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_screen.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';

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

class CommunityDiscussionsScreen extends ConsumerStatefulWidget {
  const CommunityDiscussionsScreen({super.key});

  @override
  ConsumerState<CommunityDiscussionsScreen> createState() =>
      _CommunityDiscussionsScreenState();
}

class _CommunityDiscussionsScreenState
    extends ConsumerState<CommunityDiscussionsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 500) {
      // User scrolled near bottom - could trigger load more here
      // For now, we load all at once via the provider
    }
  }

  @override
  Widget build(BuildContext context) {
    final questionsAsync = ref.watch(questionsProvider);
    final activeFilter = ref.watch(_discussionFilterProvider);

    return FkScreen(
      padding: EdgeInsets.fromLTRB(AppSpacing.s10, AppSpacing.s06, AppSpacing.s10, 96),
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
        SizedBox(height: AppSpacing.s10),
        FkPrimaryButton(
          label: 'Start a new discussion',
          onPressed: () => context.go(RouteNames.communityAskQuestion),
        ),
        SizedBox(height: AppSpacing.s08),
        CommunityFilterRow(
          selected: activeFilter,
          onSelected: (filter) {
            ref.read(_discussionFilterProvider.notifier).update(filter);
            ref.read(questionsProvider.notifier).setFilter(filter);
          },
        ),
        SizedBox(height: AppSpacing.s07),
        questionsAsync.when(
          loading: () =>  Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.s10),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (e, _) => _ErrorView(
            onRetry: () => ref.read(questionsProvider.notifier).refresh(),
          ),
          data: (questions) {
            if (questions.isEmpty) {
              return const _EmptyView();
            }
            return RefreshIndicator(
              onRefresh: () async {
                await ref.read(questionsProvider.notifier).refresh();
              },
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${questions.length} discussions',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppColors.neutral500,
                          ),
                    ),
                    SizedBox(height: AppSpacing.s07),
                    ...questions.map(
                      (q) => DiscussionListItem(
                        question: q,
                        onTap: () =>
                            context.push('${RouteNames.communityDiscussions}/${q.id}'),
                      ),
                    ),
                    SizedBox(height: AppSpacing.s10),
                  ],
                ),
              ),
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
      padding: EdgeInsets.symmetric(vertical: AppSpacing.s10),
      child: Column(
        children: [
          const Icon(Icons.wifi_off_rounded, size: 48, color: AppColors.neutral400),
          SizedBox(height: AppSpacing.s06),
          Text(
            'Could not load discussions',
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: AppColors.neutral500),
          ),
          SizedBox(height: AppSpacing.s07),
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
      padding: EdgeInsets.symmetric(vertical: AppSpacing.s10),
      child: Center(
        child: Text(
          'No discussions yet.\nBe the first to start one!',
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: AppColors.neutral500),
        ),
      ),
    );
  }
}
