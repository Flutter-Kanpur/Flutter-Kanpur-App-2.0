import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/router/route_names.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_primary_button.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_screen.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/application/community_provider.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/domain/community_models.dart';
import 'package:flutter_knp_mobile_app_v2/utils/colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CommunityDiscussionsScreen extends ConsumerWidget {
  const CommunityDiscussionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questions = ref.watch(communityDashboardProvider).questions;

    return FkScreen(
      padding: const EdgeInsets.fromLTRB(22, 12, 22, 96),
      children: [
        _TopBar(
          title: 'Discussion',
          onBack: () => context.go(RouteNames.community),
        ),
        const SizedBox(height: 28),
        FkPrimaryButton(
          label: 'Start a new discussion',
          onPressed: () => context.go(RouteNames.communityAskQuestion),
        ),
        const SizedBox(height: 18),
        SizedBox(
          height: 38,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: const [
              _FilterChip(label: 'Filters', icon: Icons.filter_list_rounded),
              _FilterChip(label: 'Trending'),
              _FilterChip(label: 'Active'),
              _FilterChip(label: 'Unanswered'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          '24,181,717 questions',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.subtitleTextDarkGrey,
          ),
        ),
        const SizedBox(height: 16),
        for (final question in questions)
          _DiscussionListCard(
            question: question,
            onTap: () => context.go(RouteNames.communityDiscussionDetail),
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

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, this.icon});

  final String label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFD8DDF0)),
      ),
      child: Row(
        children: [
          if (icon != null) ...[Icon(icon, size: 16), const SizedBox(width: 6)],
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          if (icon != null) const Icon(Icons.keyboard_arrow_down, size: 18),
        ],
      ),
    );
  }
}

class _DiscussionListCard extends StatelessWidget {
  const _DiscussionListCard({required this.question, required this.onTap});

  final CommunityQuestion question;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE2E2E2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question.title,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.primary,
                height: 1.4,
              ),
            ),
            if (question.id == 'tags-model') ...[
              const SizedBox(height: 12),
              SizedBox(
                height: 84,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 10),
                  itemBuilder: (context, index) => Container(
                    width: 145,
                    decoration: BoxDecoration(
                      color: index == 0 ? Colors.black : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.borderSecondary),
                    ),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 18),
            Row(
              children: [
                const CircleAvatar(
                  radius: 18,
                  backgroundColor: Color(0xFFFFB5C8),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        question.authorName,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        question.createdLabel,
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${question.answerCount + 3} answers',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.subtitleTextDarkGrey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
