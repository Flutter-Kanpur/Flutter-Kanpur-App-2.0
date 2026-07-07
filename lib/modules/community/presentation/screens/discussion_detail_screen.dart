import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/router/route_names.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/application/community_provider.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/domain/community_models.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/presentation/widgets/answer_card.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/presentation/widgets/answer_form.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_screen.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_status_chip.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DiscussionDetailScreen extends ConsumerStatefulWidget {
  final String questionId;

  const DiscussionDetailScreen({
    super.key,
    required this.questionId,
  });

  @override
  ConsumerState<DiscussionDetailScreen> createState() =>
      _DiscussionDetailScreenState();
}

class _DiscussionDetailScreenState extends ConsumerState<DiscussionDetailScreen> {
  bool _showAnswerForm = false;
  int _currentPage = 0;
  final int _answersPerPage = 5;

  @override
  Widget build(BuildContext context) {
    final questionAsync = ref.watch(questionDetailProvider(widget.questionId));
    final currentUserIdAsync = ref.watch(currentUserIdProvider);

    return questionAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () => context.go(RouteNames.communityDiscussions),
          ),
        ),
        body: Center(child: Text('Error: $e')),
      ),
      data: (question) {
        if (question == null) {
          return Scaffold(
            appBar: AppBar(
              leading: BackButton(
                onPressed: () => context.go(RouteNames.communityDiscussions),
              ),
            ),
            body: const Center(child: Text('Question not found')),
          );
        }
        return _DetailBody(
          question: question,
          currentUserId: currentUserIdAsync.maybeWhen(
            data: (id) => id,
            orElse: () => null,
          ),
          showAnswerForm: _showAnswerForm,
          onToggleAnswerForm: () {
            setState(() => _showAnswerForm = !_showAnswerForm);
          },
          currentPage: _currentPage,
          answersPerPage: _answersPerPage,
          onPageChanged: (page) {
            setState(() => _currentPage = page);
          },
        );
      },
    );
  }
}

class _DetailBody extends ConsumerWidget {
  const _DetailBody({
    required this.question,
    required this.showAnswerForm,
    required this.onToggleAnswerForm,
    required this.currentPage,
    required this.answersPerPage,
    required this.onPageChanged,
    this.currentUserId,
  });

  final CommunityQuestion question;
  final bool showAnswerForm;
  final VoidCallback onToggleAnswerForm;
  final int currentPage;
  final int answersPerPage;
  final Function(int) onPageChanged;
  final String? currentUserId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repliesAsync = ref.watch(repliesProvider(question.id));

    return FkScreen(
      padding: const EdgeInsets.fromLTRB(22, 12, 22, 96),
      children: [
        _TopBar(
          title: 'Discussion',
          onBack: () => context.go(RouteNames.communityDiscussions),
        ),
        const SizedBox(height: 28),
        Text(
          question.title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w500,
            height: 1.25,
          ),
        ),
        const SizedBox(height: 14),
        if (question.tag.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [FkStatusChip(label: question.tag)],
          ),
        const SizedBox(height: 18),
        Text(
          question.body,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.subtitleTextDarkGrey,
            height: 1.45,
          ),
        ),
        const SizedBox(height: 18),
        _AuthorRow(
          name: question.authorName,
          subtitle: question.createdLabel,
          photoUrl: question.authorPhotoUrl,
        ),
        const Divider(height: 30),

        // Answers Section
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Answers',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            ElevatedButton.icon(
              onPressed: onToggleAnswerForm,
              icon: const Icon(Icons.add),
              label: const Text('Answer'),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Answer Form
        if (showAnswerForm) ...[
          AnswerForm(
            questionId: question.id,
            onSubmitted: onToggleAnswerForm,
          ),
          const SizedBox(height: 24),
        ],

        // Answers List
        repliesAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(
            child: Text('Error loading answers: $e'),
          ),
          data: (replies) {
            if (replies.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Center(
                  child: Text('No answers yet. Be the first to answer!'),
                ),
              );
            }

            final pageSize = answersPerPage;
            final totalPages = (replies.length / pageSize).ceil();
            final startIndex = currentPage * pageSize;
            final endIndex = (startIndex + pageSize).clamp(0, replies.length);
            final pageReplies = replies.sublist(startIndex, endIndex);

            return Column(
              children: [
                Text(
                  'Responses ${replies.length}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.subtitleTextDarkGrey,
                  ),
                ),
                const SizedBox(height: 16),
                ...pageReplies.map((reply) => AnswerCard(
                  answerId: reply.id,
                  authorName: reply.authorName,
                  authorPhotoUrl: reply.authorPhotoUrl,
                  body: reply.body,
                  createdAt: reply.createdLabel,
                  likeCount: reply.likeCount,
                  isOwnAnswer: reply.authorId == currentUserId,
                  onLike: () {
                    ref
                        .read(communityActionControllerProvider.notifier)
                        .likeAnswer(reply.id, question.id);
                  },
                  onDelete: reply.authorId == currentUserId
                      ? () {
                          ref
                              .read(communityActionControllerProvider.notifier)
                              .deleteAnswer(reply.id, question.id);
                        }
                      : null,
                )),

                if (totalPages > 1) ...[
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (currentPage > 0)
                        ElevatedButton(
                          onPressed: () => onPageChanged(currentPage - 1),
                          child: const Text('← Previous'),
                        ),
                      const SizedBox(width: 16),
                      Text('Page ${currentPage + 1} of $totalPages'),
                      const SizedBox(width: 16),
                      if (currentPage < totalPages - 1)
                        ElevatedButton(
                          onPressed: () => onPageChanged(currentPage + 1),
                          child: const Text('Next →'),
                        ),
                    ],
                  ),
                ],
              ],
            );
          },
        ),
      ],
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.title, required this.onBack});

  final String title;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(onPressed: onBack, icon: const Icon(Icons.arrow_back)),
        Expanded(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        IconButton(onPressed: () {}, icon: const Icon(Icons.more_horiz)),
      ],
    );
  }
}

class _AuthorRow extends StatelessWidget {
  const _AuthorRow({
    required this.name,
    required this.subtitle,
    this.photoUrl,
  });

  final String name;
  final String subtitle;
  final String? photoUrl;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: const Color(0xFFFFB5C8),
          backgroundImage:
              photoUrl != null ? NetworkImage(photoUrl!) : null,
          child: photoUrl == null
              ? Text(name.isNotEmpty ? name[0].toUpperCase() : '?',
                  style: const TextStyle(color: Colors.white))
              : null,
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            Text(
              subtitle,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }
}

