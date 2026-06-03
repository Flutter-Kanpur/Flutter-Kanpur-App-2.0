import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/router/route_names.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_primary_button.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_screen.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_status_chip.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/application/community_provider.dart';
import 'package:flutter_knp_mobile_app_v2/utils/colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DiscussionDetailScreen extends ConsumerWidget {
  const DiscussionDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questions = ref.watch(communityDashboardProvider).questions;
    final question = questions.first;
    final replies = ref.watch(communityRepliesProvider);

    return FkScreen(
      padding: const EdgeInsets.fromLTRB(22, 12, 22, 96),
      children: [
        _TopBar(
          title: 'Discussion',
          onBack: () => context.go(RouteNames.communityDiscussions),
        ),
        const SizedBox(height: 28),
        FkPrimaryButton(
          label: 'Start a new discussion',
          onPressed: () => context.go(RouteNames.communityAskQuestion),
        ),
        const SizedBox(height: 20),
        Text(
          'How to manage state efficiently in Flutter without overcomplicating the app?',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w500,
            height: 1.25,
          ),
        ),
        const SizedBox(height: 14),
        const Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            FkStatusChip(label: 'State management'),
            FkStatusChip(label: 'Flutter development'),
          ],
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
        SizedBox(
          height: 84,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            separatorBuilder: (context, index) => const SizedBox(width: 10),
            itemBuilder: (context, index) => Container(
              width: 145,
              decoration: BoxDecoration(
                color: index == 0 ? Colors.black : const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.borderSecondary),
              ),
            ),
          ),
        ),
        const SizedBox(height: 22),
        _AuthorRow(name: 'Angelica Singh', subtitle: 'Posted 6h ago'),
        const Divider(height: 30),
        Text(
          'Responses ${replies.length}',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 16),
        TextField(
          minLines: 3,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'Write a reply',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          ),
          onTap: () => _showReplySheet(context, replies.first),
        ),
        const SizedBox(height: 24),
        for (final reply in replies) _ReplyTile(reply: reply),
        TextButton(
          onPressed: () {},
          child: const Align(
            alignment: Alignment.centerLeft,
            child: Text('Show replies'),
          ),
        ),
      ],
    );
  }

  void _showReplySheet(BuildContext context, reply) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 12,
          bottom: MediaQuery.of(context).viewInsets.bottom + 28,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 76,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Post your reply',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                IconButton.filled(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _AuthorRow(name: reply.authorName, subtitle: reply.createdLabel),
            const SizedBox(height: 12),
            Text(reply.body),
            const SizedBox(height: 16),
            TextField(
              minLines: 4,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Write a reply',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
      ),
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
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        IconButton(onPressed: () {}, icon: const Icon(Icons.more_horiz)),
      ],
    );
  }
}

class _AuthorRow extends StatelessWidget {
  const _AuthorRow({required this.name, required this.subtitle});

  final String name;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(backgroundColor: Color(0xFFFFB5C8)),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            Text(
              subtitle,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }
}

class _ReplyTile extends StatelessWidget {
  const _ReplyTile({required this.reply});

  final dynamic reply;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _AuthorRow(name: reply.authorName, subtitle: reply.createdLabel),
          const SizedBox(height: 12),
          Text(reply.body, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.favorite, color: Colors.red),
              const SizedBox(width: 6),
              Text(reply.likeCount >= 1000 ? '14.5k' : '${reply.likeCount}'),
              const SizedBox(width: 24),
              const Icon(Icons.chat_bubble_outline, size: 18),
              const SizedBox(width: 6),
              Text('${reply.replyCount} reply'),
            ],
          ),
          const Divider(height: 28),
        ],
      ),
    );
  }
}
