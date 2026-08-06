import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_knp_mobile_app_v2/app/router/route_names.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/application/community_provider.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/domain/community_models.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/presentation/widgets/answer_card.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/presentation/widgets/answer_form.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/presentation/widgets/community_async_views.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/presentation/widgets/community_author_row.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_primary_button.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_screen.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_screen_top_bar.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_status_chip.dart';
import 'package:flutter_knp_mobile_app_v2/utils/count_format.dart';
import 'package:flutter_knp_mobile_app_v2/utils/external_links.dart';

class DiscussionDetailScreen extends ConsumerWidget {
  const DiscussionDetailScreen({super.key, required this.questionId});

  final String questionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questionAsync = ref.watch(questionDetailProvider(questionId));

    return questionAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              FkScreenTopBar(
                title: 'Discussion',
                fallbackPath: RouteNames.communityDiscussions,
              ),
              Expanded(
                child: CommunityErrorView(
                  message: 'Could not load this discussion.',
                  onRetry: () => ref
                      .read(questionDetailProvider(questionId).notifier)
                      .refresh(),
                ),
              ),
            ],
          ),
        ),
      ),
      data: (question) {
        if (question == null) {
          return Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  FkScreenTopBar(
                    title: 'Discussion',
                    fallbackPath: RouteNames.communityDiscussions,
                  ),
                  const Expanded(
                    child: CommunityEmptyView(
                      icon: Icons.help_outline_rounded,
                      message: 'This discussion is no longer available.',
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return _DetailBody(question: question);
      },
    );
  }
}

class _DetailBody extends ConsumerStatefulWidget {
  const _DetailBody({required this.question});

  final CommunityQuestion question;

  @override
  ConsumerState<_DetailBody> createState() => _DetailBodyState();
}

class _DetailBodyState extends ConsumerState<_DetailBody> {
  CommunityQuestion get _question => widget.question;

  Future<void> _toggleLike() async {
    final error = await ref
        .read(communityEngagementProvider)
        .toggleQuestionLike(_question);
    _notifyOnFailure(error, 'Could not update your like.');
  }

  Future<void> _toggleSave() async {
    final error = await ref
        .read(communityEngagementProvider)
        .toggleQuestionSave(_question);
    _notifyOnFailure(error, 'Could not update your bookmark.');
  }

  Future<void> _toggleAnswerLike(CommunityReply reply) async {
    final error = await ref
        .read(communityEngagementProvider)
        .toggleAnswerLike(questionId: _question.id, reply: reply);
    _notifyOnFailure(error, 'Could not update your like.');
  }

  void _notifyOnFailure(Object? error, String fallback) {
    if (error == null || !mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            // CommunityAuthException already reads as a sentence; anything
            // else is a raw Postgrest/socket dump, so use the fallback.
            error.toString().startsWith('You need to be signed in')
                ? error.toString()
                : fallback,
          ),
          backgroundColor: AppColors.warning600,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final repliesAsync = ref.watch(repliesProvider(_question.id));
    final currentUserId = ref.watch(currentUserIdProvider);
    final question = _question;

    return FkScreen(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.h16,
        AppSpacing.v12,
        AppSpacing.h16,
        96,
      ),
      children: [
        FkScreenTopBar(
          title: 'Discussion',
          fallbackPath: RouteNames.communityDiscussions,
          trailing: PopupMenuButton<String>(
            icon: const Icon(Icons.more_horiz, color: AppColors.neutral950),
            shape: RoundedRectangleBorder(borderRadius: AppRadius.all03),
            onSelected: (value) {
              switch (value) {
                case 'save':
                  _toggleSave();
                case 'guidelines':
                  context.push(RouteNames.communityGuidelines);
                case 'discord':
                  openExternalUrlOrNotify(
                    context,
                    ExternalLinks.discordInvite,
                  );
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'save',
                child: ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    question.isSaved
                        ? Icons.bookmark
                        : Icons.bookmark_outline,
                  ),
                  title: Text(question.isSaved ? 'Remove bookmark' : 'Save'),
                ),
              ),
              const PopupMenuItem(
                value: 'guidelines',
                child: ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.rule_rounded),
                  title: Text('Community guidelines'),
                ),
              ),
              const PopupMenuItem(
                value: 'discord',
                child: ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.discord_outlined),
                  title: Text('Ask on Discord'),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: AppSpacing.v18),

        FkPrimaryButton(
          label: 'Start a new discussion',
          onPressed: () => context.push(RouteNames.communityAskQuestion),
        ),
        SizedBox(height: AppSpacing.v22),

        Text(
          question.title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
            height: 1.25,
          ),
        ),

        if (question.tags.isNotEmpty) ...[
          SizedBox(height: AppSpacing.v16),
          Wrap(
            spacing: AppSpacing.h8,
            runSpacing: AppSpacing.v8,
            children: question.tags
                .map((tag) => FkStatusChip(label: tag))
                .toList(),
          ),
        ],

        SizedBox(height: AppSpacing.v18),
        Text(
          question.body,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.neutral500,
            height: 1.45,
          ),
        ),

        if (question.imageUrl != null && question.imageUrl!.isNotEmpty) ...[
          SizedBox(height: AppSpacing.v18),
          ClipRRect(
            borderRadius: AppRadius.all03,
            child: Image.network(
              question.imageUrl!,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const SizedBox.shrink(),
            ),
          ),
        ],

        SizedBox(height: AppSpacing.v18),
        CommunityAuthorRow(
          name: question.authorName,
          subtitle: 'Posted ${question.createdLabel}',
          photoUrl: question.authorPhotoUrl,
        ),

        SizedBox(height: AppSpacing.v12),
        Row(
          children: [
            _QuestionAction(
              icon: question.isLiked
                  ? Icons.favorite
                  : Icons.favorite_border_outlined,
              color: question.isLiked
                  ? AppColors.warning600
                  : AppColors.neutral500,
              label: formatCount(question.likeCount),
              onTap: _toggleLike,
            ),
            SizedBox(width: AppSpacing.h16),
            _QuestionAction(
              icon: Icons.chat_bubble_outline,
              color: AppColors.neutral500,
              label: formatCount(question.answerCount),
              onTap: null,
            ),
            const Spacer(),
            _QuestionAction(
              icon: question.isSaved
                  ? Icons.bookmark
                  : Icons.bookmark_outline,
              color: AppColors.primary500,
              label: formatCount(question.saveCount),
              onTap: _toggleSave,
            ),
          ],
        ),

        const Divider(height: 30),

        Text(
          'Responses ${formatCount(question.answerCount)}',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        SizedBox(height: AppSpacing.v16),

        AnswerForm(questionId: question.id),
        SizedBox(height: AppSpacing.v22),

        repliesAsync.when(
          loading: () => const CommunityLoadingView(height: 160),
          error: (e, _) => CommunityErrorView(
            message: 'Could not load replies.',
            onRetry: () =>
                ref.read(repliesProvider(question.id).notifier).refresh(),
          ),
          data: (feed) {
            if (feed.replies.isEmpty) {
              return const CommunityEmptyView(
                icon: Icons.mode_comment_outlined,
                message: 'No replies yet.\nBe the first to answer!',
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ...feed.replies.map(
                  (reply) => AnswerCard(
                    reply: reply,
                    isOwnAnswer: reply.authorId == currentUserId,
                    onLike: () => _toggleAnswerLike(reply),
                    onDelete: reply.authorId == currentUserId
                        ? () => ref
                              .read(communityActionControllerProvider.notifier)
                              .deleteAnswer(reply.id, question.id)
                        : null,
                  ),
                ),
                // "Show replies" pages in five at a time rather than loading
                // every answer up front.
                if (feed.hasMore)
                  TextButton(
                    onPressed: feed.isLoadingMore
                        ? null
                        : () => ref
                              .read(repliesProvider(question.id).notifier)
                              .loadMore(),
                    child: feed.isLoadingMore
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Show replies'),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _QuestionAction extends StatelessWidget {
  const _QuestionAction({
    required this.icon,
    required this.color,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.all02,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.h6,
          vertical: AppSpacing.v6,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: color),
            SizedBox(width: AppSpacing.h6),
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.neutral600),
            ),
          ],
        ),
      ),
    );
  }
}
