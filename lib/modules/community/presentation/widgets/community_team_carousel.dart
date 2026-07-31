import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/domain/community_models.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';

class CommunityTeamCarousel extends StatelessWidget {
  const CommunityTeamCarousel({super.key, required this.members});

  final List<CommunityMember> members;

  static const _fallback = [
    CommunityMember(
      name: 'Angelica Singh',
      role: 'UI/UX Designer',
      skills: [],
      status: 'active',
    ),
    CommunityMember(
      name: 'Pushti Sonawala',
      role: 'Full Stack Dev',
      skills: [],
      status: 'active',
    ),
    CommunityMember(
      name: 'Ayush Singh',
      role: 'App Developer',
      skills: [],
      status: 'active',
    ),
    CommunityMember(
      name: 'Sarah Fatima',
      role: 'Flutter Developer',
      skills: [],
      status: 'active',
    ),
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
        SizedBox(height: AppSpacing.v10),
        SizedBox(
          height: 72,
          child: _AutoScrollRow(members: row2, leftToRight: false),
        ),
      ],
    );
  }
}

// StatefulWidget is required here for ScrollController + Ticker (animation only, no data state).
class _AutoScrollRow extends StatefulWidget {
  const _AutoScrollRow({required this.members, required this.leftToRight});

  final List<CommunityMember> members;
  final bool leftToRight;

  @override
  State<_AutoScrollRow> createState() => _AutoScrollRowState();
}

class _AutoScrollRowState extends State<_AutoScrollRow>
    with SingleTickerProviderStateMixin {
  /// Scroll speed in logical pixels per second.
  static const _pixelsPerSecond = 22.0;
  static const _pillWidth = 206.0;

  /// The list renders three copies of [members], so scrolling exactly one
  /// copy's width lands on a pixel-identical frame — the wrap is invisible.
  static const _copies = 3;

  final _controller = ScrollController();
  late final Ticker _ticker;
  Duration _lastElapsed = Duration.zero;
  double _offset = 0;

  double get _gap => AppSpacing.h10;
  double get _itemExtent => _pillWidth + _gap;
  double get _cycle => widget.members.length * _itemExtent;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick)..start();
  }

  void _onTick(Duration elapsed) {
    final dt = (elapsed - _lastElapsed).inMicroseconds / 1000000;
    _lastElapsed = elapsed;

    if (!_controller.hasClients) return;
    final max = _controller.position.maxScrollExtent;
    if (max <= 0 || _cycle <= 0) return;

    _offset += _pixelsPerSecond * dt * (widget.leftToRight ? 1 : -1);
    if (_offset >= _cycle) _offset -= _cycle;
    if (_offset < 0) _offset += _cycle;

    _controller.jumpTo(_offset.clamp(0, max));
  }

  @override
  void didUpdateWidget(covariant _AutoScrollRow old) {
    super.didUpdateWidget(old);
    if (old.members != widget.members ||
        old.leftToRight != widget.leftToRight) {
      _offset = 0;
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final members = widget.members;
    if (members.isEmpty) return const SizedBox.shrink();

    return ListView.builder(
      controller: _controller,
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      clipBehavior: Clip.none,
      itemExtent: _itemExtent,
      itemCount: members.length * _copies,
      itemBuilder: (_, i) => Padding(
        padding: EdgeInsets.only(right: _gap),
        child: _MemberPill(member: members[i % members.length]),
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
      padding: AppSpacing.symmetric(
        horizontal: AppSpacing.h10,
        vertical: AppSpacing.v8,
      ),
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
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColors.primary500,
                    ),
                  )
                : null,
          ),
          SizedBox(width: AppSpacing.h10),
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
                SizedBox(height: AppSpacing.v2),
                Text(
                  member.role,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: AppColors.neutral500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
