import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_knp_mobile_app_v2/app/router/route_names.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/application/community_provider.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/data/repositories/community_repository.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/presentation/widgets/community_async_views.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/presentation/widgets/community_filter_row.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/presentation/widgets/discussion_list_item.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_primary_button.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_screen_top_bar.dart';
import 'package:flutter_knp_mobile_app_v2/utils/count_format.dart';

class CommunityDiscussionsScreen extends ConsumerStatefulWidget {
  const CommunityDiscussionsScreen({super.key});

  @override
  ConsumerState<CommunityDiscussionsScreen> createState() =>
      _CommunityDiscussionsScreenState();
}

class _CommunityDiscussionsScreenState
    extends ConsumerState<CommunityDiscussionsScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  /// Fetches the next page once the user is within 400px of the bottom.
  /// The notifier itself guards against overlapping calls.
  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 400) {
      ref.read(questionFeedProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final feedAsync = ref.watch(questionFeedProvider);

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header stays outside the scroll view so the filter chips and the
          // "Start a new discussion" action remain reachable while paging.
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.h16,
              AppSpacing.v12,
              AppSpacing.h16,
              0,
            ),
            child: Column(
              children: [
                FkScreenTopBar(
                  title: 'Discussion',
                  fallbackPath: RouteNames.community,
                ),
                SizedBox(height: AppSpacing.v18),
                FkPrimaryButton(
                  label: 'Start a new discussion',
                  onPressed: () =>
                      context.push(RouteNames.communityAskQuestion),
                ),
                SizedBox(height: AppSpacing.v18),
                CommunityFilterRow(
                  selected: feedAsync.value?.filter,
                  onSelected: (filter) =>
                      ref.read(questionFeedProvider.notifier).setFilter(filter),
                ),
                SizedBox(height: AppSpacing.v16),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () =>
                  ref.read(questionFeedProvider.notifier).refresh(),
              child: feedAsync.when(
                loading: () => const CommunityLoadingView(height: 320),
                error: (e, _) => ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    CommunityErrorView(
                      message: 'Could not load discussions.',
                      onRetry: () =>
                          ref.read(questionFeedProvider.notifier).refresh(),
                    ),
                  ],
                ),
                data: (feed) {
                  if (feed.questions.isEmpty) {
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        CommunityEmptyView(
                          icon: Icons.forum_outlined,
                          message: feed.filter == null
                              ? 'No discussions yet.\nBe the first to start one!'
                              : 'Nothing matches "${CommunityFilter.labelOf(feed.filter!)}".',
                          actionLabel: feed.filter == null
                              ? 'Ask a question'
                              : 'Clear filter',
                          onAction: () => feed.filter == null
                              ? context.push(RouteNames.communityAskQuestion)
                              : ref
                                    .read(questionFeedProvider.notifier)
                                    .setFilter(null),
                        ),
                      ],
                    );
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.h16,
                      0,
                      AppSpacing.h16,
                      96,
                    ),
                    // +1 header row, +1 footer row.
                    itemCount: feed.questions.length + 2,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: AppSpacing.v16),
                          child: Text(
                            '${formatCount(feed.questions.length)}'
                            '${feed.hasMore ? '+' : ''} '
                            '${feed.questions.length == 1 ? 'question' : 'questions'}',
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: AppColors.neutral500,
                            ),
                          ),
                        );
                      }

                      if (index == feed.questions.length + 1) {
                        return CommunityLoadMoreFooter(
                          isLoading: feed.isLoadingMore,
                          hasMore: feed.hasMore,
                          error: feed.loadMoreError,
                          onRetry: () =>
                              ref.read(questionFeedProvider.notifier).loadMore(),
                        );
                      }

                      final question = feed.questions[index - 1];
                      return DiscussionListItem(
                        question: question,
                        onTap: () => context.push(
                          '${RouteNames.communityDiscussionDetail}/${question.id}',
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
