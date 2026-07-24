import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/domain/community_models.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';

class CommunityTeamCarousel extends StatelessWidget {
  const CommunityTeamCarousel({super.key, required this.members});

  final List<CommunityMember> members;

  static const _fallback = [
    CommunityMember(name: 'Angelica Singh', role: 'UI/UX Designer', skills: [], status: 'active'),
    CommunityMember(name: 'Pushti Sonawala', role: 'Full Stack Dev', skills: [], status: 'active'),
    CommunityMember(name: 'Ayush Singh', role: 'App Developer', skills: [], status: 'active'),
    CommunityMember(name: 'Sarah Fatima', role: 'Flutter Developer', skills: [], status: 'active'),
  ];

  @override
  Widget build(BuildContext context) {
    final list = members.isNotEmpty ? members : _fallback;
    final mid = (list.length / 2).ceil();
    final row1 = list.take(mid).toList();
    final row2 = list.length > mid
        ? list.skip(mid).toList()
        : list.reversed.toList();

    return Column(
      children: [
        SizedBox(
          height: 72,
          child: _AutoScrollRow(members: row1, leftToRight: true),
        ),
        SizedBox(height: AppSpacing.s05),
        SizedBox(
          height: 72,
          child: _AutoScrollRow(members: row2, leftToRight: false),
        ),
      ],
    );
  }
}

// StatefulWidget is required here for ScrollController + Timer (animation only, no data state).
class _AutoScrollRow extends StatefulWidget {
  const _AutoScrollRow({required this.members, required this.leftToRight});

  final List<CommunityMember> members;
  final bool leftToRight;

  @override
  State<_AutoScrollRow> createState() => _AutoScrollRowState();
}

class _AutoScrollRowState extends State<_AutoScrollRow> {
  static const _tick = Duration(milliseconds: 32);
  static const _step = 0.7;

  final _controller = ScrollController();
  Timer? _timer;
  bool _rtlInit = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _start());
  }

  void _start() {
    _timer?.cancel();
    _timer = Timer.periodic(_tick, (_) {
      if (!mounted || !_controller.hasClients) return;
      final max = _controller.position.maxScrollExtent;
      if (max <= 0) return;

      if (!widget.leftToRight && !_rtlInit) {
        _rtlInit = true;
        _controller.jumpTo(max);
        return;
      }

      final next = widget.leftToRight
          ? _controller.offset + _step
          : _controller.offset - _step;

      if (next > max) {
        _controller.jumpTo(0);
      } else if (next < 0) {
        _controller.jumpTo(max);
      } else {
        _controller.jumpTo(next);
      }
    });
  }

  @override
  void didUpdateWidget(covariant _AutoScrollRow old) {
    super.didUpdateWidget(old);
    if (old.members != widget.members || old.leftToRight != widget.leftToRight) {
      _rtlInit = false;
      WidgetsBinding.instance.addPostFrameCallback((_) => _start());
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
    final repeated = [...widget.members, ...widget.members, ...widget.members];
    return ListView.separated(
      controller: _controller,
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      clipBehavior: Clip.none,
      itemCount: repeated.length,
      separatorBuilder: (_, _) => SizedBox(width: AppSpacing.s05),
      itemBuilder: (_, i) => SizedBox(
        width: 206,
        child: _MemberPill(member: repeated[i]),
      ),
    );
  }
}

class _MemberPill extends StatelessWidget {
  const _MemberPill({required this.member});

  final CommunityMember member;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.symmetric(horizontal: AppSpacing.s05, vertical: AppSpacing.s04),
      decoration: BoxDecoration(
        color: AppColors.neutral50,
        borderRadius: AppRadius.all09,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.primary500.withValues(alpha: 0.15),
            backgroundImage: member.photoUrl != null
                ? NetworkImage(member.photoUrl!)
                : null,
            child: member.photoUrl == null
                ? Text(
                    member.name.isNotEmpty ? member.name[0].toUpperCase() : '?',
                    style: AppTextStyles.titleMedium.copyWith(color: AppColors.primary500),
                  )
                : null,
          ),
          SizedBox(width: AppSpacing.s05),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                SizedBox(height: AppSpacing.s01),
                Text(
                  member.role,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.neutral500,
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
