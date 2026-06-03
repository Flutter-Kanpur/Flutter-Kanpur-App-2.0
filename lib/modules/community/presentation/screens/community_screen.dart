import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/router/route_names.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_primary_button.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_screen.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_section_title.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/application/community_provider.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/domain/community_models.dart';
import 'package:flutter_knp_mobile_app_v2/utils/assets_path.dart';
import 'package:flutter_knp_mobile_app_v2/utils/colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class CommunityScreen extends ConsumerWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final community = ref.watch(communityDashboardProvider);

    return FkScreen(
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
              icon: const Icon(Icons.notifications_rounded),
            ),
            IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
          ],
        ),
        const SizedBox(height: 18),
        _AskQuestionBanner(
          onTap: () => context.go(RouteNames.communityAskQuestion),
        ),
        FkSectionTitle(
          title: 'Featured discussions',
          actionLabel: 'Explore all',
          onActionTap: () => context.go(RouteNames.communityDiscussions),
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            final cardWidth = (constraints.maxWidth * 0.86).clamp(272.0, 300.0);
            return SizedBox(
              height: 306,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.none,
                itemCount: community.questions.length,
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemBuilder: (context, index) => _FeaturedDiscussionCard(
                  width: cardWidth,
                  question: community.questions[index],
                  onTap: () => context.go(RouteNames.communityDiscussionDetail),
                ),
              ),
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
                child: _ContributeCard(
                  label: 'Open to all',
                  title: 'Upload Your Projects',
                  body:
                      'Share your projects with the community to showcase your work.',
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
                      child: _ContributeCard(
                        label: 'Write for us',
                        body:
                            'Submit a blog request and contribute content that helps the community grow.',
                        onTap: () => context.go(RouteNames.blogs),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      flex: 4,
                      child: _ContributeCard(
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
        _StatsPanel(community: community),
        const SizedBox(height: 12),
        FkPrimaryButton(label: 'Join us on discord', onPressed: () {}),
        const SizedBox(height: 24),
        const FkSectionTitle(title: 'Our team'),
        _AutoTeamSection(members: community.members),
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
            Text(
              'Crafted with ',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
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
    );
  }
}

class _AskQuestionBanner extends StatelessWidget {
  const _AskQuestionBanner({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: AspectRatio(
          aspectRatio: 346 / 187,
          child: SvgPicture.asset(
            AssetsPath.communityTopContainer,
            fit: BoxFit.fill,
            alignment: Alignment.topCenter,
          ),
        ),
      ),
    );
  }
}

class _FeaturedDiscussionCard extends StatelessWidget {
  const _FeaturedDiscussionCard({
    required this.width,
    required this.question,
    required this.onTap,
  });

  final double width;
  final CommunityQuestion question;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFE0E0E0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 18,
                  backgroundColor: Color(0xFFFFB5C8),
                  child: Icon(Icons.person, color: Colors.white, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        question.authorName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
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
              ],
            ),
            const SizedBox(height: 18),
            Text(
              question.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            Text(
              question.body,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.subtitleTextDarkGrey,
                height: 1.42,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: ['#dolor', '#sit', '#amet', '#magnaaliqua', '#enim']
                  .map(
                    (tag) => Text(
                      tag,
                      style: const TextStyle(color: AppColors.primary),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 10),
            const Divider(),
            Row(
              children: [
                const Icon(Icons.favorite, color: Colors.red, size: 20),
                const SizedBox(width: 4),
                const Text('14.5k'),
                const SizedBox(width: 14),
                const Icon(Icons.chat_bubble_outline, size: 18),
                const SizedBox(width: 4),
                const Text('1.5k'),
                const Spacer(),
                const Icon(Icons.bookmark, color: AppColors.primary, size: 20),
                const SizedBox(width: 4),
                Text('${question.answerCount + 122}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ContributeCard extends StatelessWidget {
  const _ContributeCard({
    required this.label,
    required this.body,
    required this.onTap,
    this.title,
  });

  final String label;
  final String? title;
  final String body;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFD9E0FF)),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.12),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(
                  context,
                ).textTheme.labelMedium?.copyWith(color: Colors.white),
              ),
            ),
            if (title != null) ...[
              const SizedBox(height: 16),
              Text(
                title!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  height: 1.35,
                ),
              ),
            ],
            const SizedBox(height: 12),
            Expanded(
              child: Text(
                body,
                overflow: TextOverflow.ellipsis,
                maxLines: title == null ? 4 : 5,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.36,
                  color: title == null
                      ? Colors.black
                      : AppColors.subtitleTextDarkGrey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsPanel extends StatelessWidget {
  const _StatsPanel({required this.community});

  final CommunityDashboardState community;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.communityGuidelinesContainerBackground,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(value: '120+', label: 'Community\nmembers'),
          _StatItem(value: '150+', label: 'Community\ncontributions'),
          _StatItem(value: '25+', label: 'Events\nhosted'),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.subtitleTextDarkGrey,
          ),
        ),
      ],
    );
  }
}

class _AutoTeamSection extends StatelessWidget {
  const _AutoTeamSection({required this.members});

  final List<CommunityMember> members;

  @override
  Widget build(BuildContext context) {
    final visibleMembers = members.isNotEmpty
        ? members
        : [
            const CommunityMember(
              name: 'Angelica Singh',
              role: 'UI/UX Designer',
              skills: [],
              status: 'Active',
            ),
            const CommunityMember(
              name: 'Pushti Sonawala',
              role: 'Full Stack Dev',
              skills: [],
              status: 'Active',
            ),
            const CommunityMember(
              name: 'Ayush Singh',
              role: 'App Developer',
              skills: [],
              status: 'Active',
            ),
            const CommunityMember(
              name: 'Sarah Fatima',
              role: 'Flutter Developer',
              skills: [],
              status: 'Active',
            ),
          ];
    final splitIndex = (visibleMembers.length / 2).ceil();
    final firstRow = visibleMembers.take(splitIndex).toList();
    final secondRow = visibleMembers.skip(splitIndex).toList();

    return Column(
      children: [
        SizedBox(
          height: 72,
          child: _AutoTeamRow(members: firstRow, scrollLeftToRight: true),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 72,
          child: _AutoTeamRow(
            members: secondRow.isEmpty ? firstRow.reversed.toList() : secondRow,
            scrollLeftToRight: false,
          ),
        ),
      ],
    );
  }
}

class _AutoTeamRow extends StatefulWidget {
  const _AutoTeamRow({required this.members, required this.scrollLeftToRight});

  final List<CommunityMember> members;
  final bool scrollLeftToRight;

  @override
  State<_AutoTeamRow> createState() => _AutoTeamRowState();
}

class _AutoTeamRowState extends State<_AutoTeamRow> {
  static const _tickInterval = Duration(milliseconds: 32);
  static const _scrollStep = 0.7;
  final _controller = ScrollController();
  Timer? _timer;
  bool _rightToLeftInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startAutoScroll());
  }

  void _startAutoScroll() {
    _timer?.cancel();
    _timer = Timer.periodic(_tickInterval, (_) {
      if (!mounted || !_controller.hasClients) return;
      final max = _controller.position.maxScrollExtent;
      if (max <= 0) return;

      if (!widget.scrollLeftToRight && !_rightToLeftInitialized) {
        _rightToLeftInitialized = true;
        _controller.jumpTo(max);
        return;
      }

      final nextOffset = widget.scrollLeftToRight
          ? _controller.offset + _scrollStep
          : _controller.offset - _scrollStep;
      if (nextOffset > max) {
        _controller.jumpTo(0);
      } else if (nextOffset < 0) {
        _controller.jumpTo(max);
      } else {
        _controller.jumpTo(nextOffset);
      }
    });
  }

  @override
  void didUpdateWidget(covariant _AutoTeamRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.members != widget.members ||
        oldWidget.scrollLeftToRight != widget.scrollLeftToRight) {
      _rightToLeftInitialized = false;
      WidgetsBinding.instance.addPostFrameCallback((_) => _startAutoScroll());
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repeatedMembers = [
      ...widget.members,
      ...widget.members,
      ...widget.members,
    ];

    return ListView.separated(
      controller: _controller,
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      clipBehavior: Clip.none,
      itemCount: repeatedMembers.length,
      separatorBuilder: (context, index) => const SizedBox(width: 10),
      itemBuilder: (context, index) => SizedBox(
        width: 206,
        child: _TeamMemberPill(member: repeatedMembers[index]),
      ),
    );
  }
}

class _TeamMemberPill extends StatelessWidget {
  const _TeamMemberPill({required this.member});

  final CommunityMember member;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F6F6),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 24,
            backgroundColor: Color(0xFFFFB5C8),
            child: Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  member.role,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.subtitleTextDarkGrey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
