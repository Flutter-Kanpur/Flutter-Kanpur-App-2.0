import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_knp_mobile_app_v2/common_widgets/dotted_line.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/presentation/widgets/community_async_views.dart';
import 'package:flutter_knp_mobile_app_v2/modules/explore/application/explore_providers.dart';
import 'package:flutter_knp_mobile_app_v2/modules/explore/domain/core_team_member.dart';
import 'package:flutter_knp_mobile_app_v2/modules/explore/domain/core_team_section.dart';
import 'package:flutter_knp_mobile_app_v2/modules/explore/presentation/widgets/core_team_app_bar.dart';
import 'package:flutter_knp_mobile_app_v2/modules/explore/presentation/widgets/core_team_member_detail_sheet.dart';
import 'package:flutter_knp_mobile_app_v2/modules/explore/presentation/widgets/core_team_member_grid_card.dart';
import 'package:flutter_knp_mobile_app_v2/modules/explore/presentation/widgets/core_team_member_skeleton.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_load_more_button.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/gradiant_background.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _gridCrossAxisCount = 3;
const _gridChildAspectRatio = 0.65;
const _organisorsAspectRatio = 0.65;

/// Full core-team list grouped by dynamic sections from Supabase.
class CoreTeamScreen extends ConsumerStatefulWidget {
  const CoreTeamScreen({super.key});

  @override
  ConsumerState<CoreTeamScreen> createState() => _CoreTeamScreenState();
}

class _CoreTeamScreenState extends ConsumerState<CoreTeamScreen> {
  final Set<String> _expandedSectionIds = {};
  bool _didSeedExpanded = false;

  void _seedExpandedIfNeeded(List<CoreTeamSectionBucket> buckets) {
    if (_didSeedExpanded || buckets.isEmpty) return;
    _didSeedExpanded = true;
    // Expand first two sections by default (matches old organisors + app team).
    for (final bucket in buckets.take(2)) {
      _expandedSectionIds.add(bucket.section.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final membersAsync = ref.watch(coreTeamMembersProvider);

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () => ref.read(coreTeamMembersProvider.notifier).refresh(),
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                const SliverToBoxAdapter(child: CoreTeamAppBar()),
                SliverToBoxAdapter(child: SizedBox(height: AppSpacing.v12)),
                membersAsync.when(
                  loading: () => const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: CoreTeamMemberSkeleton(),
                    ),
                  ),
                  error: (error, _) => SliverToBoxAdapter(
                    child: CommunityErrorView(
                      message: 'Could not load core team.',
                      error: error,
                      onRetry: () => ref.invalidate(coreTeamMembersProvider),
                    ),
                  ),
                  data: (state) {
                    if (state.members.isEmpty && state.sections.isEmpty) {
                      return const SliverToBoxAdapter(
                        child: CommunityEmptyView(
                          icon: Icons.groups_outlined,
                          message: 'No core team members to show yet.',
                        ),
                      );
                    }

                    final buckets = CoreTeamGrouping.groupBySections(
                      sections: state.sections,
                      members: state.members,
                    );
                    _seedExpandedIfNeeded(buckets);

                    return SliverPadding(
                      padding: AppSpacing.horizontal(AppSpacing.h20),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          for (final bucket in buckets)
                            _TeamSectionTile(
                              section: bucket.section,
                              members: bucket.members,
                              isExpanded: _expandedSectionIds.contains(
                                bucket.section.id,
                              ),
                              onToggle: () {
                                setState(() {
                                  final id = bucket.section.id;
                                  if (_expandedSectionIds.contains(id)) {
                                    _expandedSectionIds.remove(id);
                                  } else {
                                    _expandedSectionIds.add(id);
                                  }
                                });
                              },
                              onMemberTap: (member) {
                                CoreTeamMemberDetailSheet.show(
                                  context,
                                  member: member,
                                  isOrganisorsSection:
                                      bucket.section.isOrganisorsStyle,
                                );
                              },
                            ),
                          if (state.hasMore)
                            state.isLoadingMore
                                ? Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: AppSpacing.v16,
                                    ),
                                    child: const Center(
                                      child: SizedBox(
                                        width: 22,
                                        height: 22,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    ),
                                  )
                                : FkLoadMoreButton(
                                    label: 'Load more',
                                    icon: Icons.keyboard_arrow_down_rounded,
                                    onTap: () => ref
                                        .read(coreTeamMembersProvider.notifier)
                                        .loadMore(),
                                  )
                          else
                            SizedBox(height: AppSpacing.v2),
                        ]),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TeamSectionTile extends StatelessWidget {
  const _TeamSectionTile({
    required this.section,
    required this.members,
    required this.isExpanded,
    required this.onToggle,
    required this.onMemberTap,
  });

  final CoreTeamSectionInfo section;
  final List<CoreTeamMember> members;
  final bool isExpanded;
  final VoidCallback onToggle;
  final ValueChanged<CoreTeamMember> onMemberTap;

  @override
  Widget build(BuildContext context) {
    final title = section.title;
    final count = members.length;
    final isOrganisors = section.isOrganisorsStyle;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onToggle,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.v12),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.titleMedium.copyWith(
                          // fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (count > 0)
                        Text(
                          '$count member${count == 1 ? '' : 's'}',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.primary500,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                ),
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_down
                      : Icons.keyboard_arrow_right,
                  color: AppColors.blackBase,
                ),
              ],
            ),
          ),
        ),
        DottedLine(),
        if (isExpanded && count > 0) ...[
          Padding(
            padding: EdgeInsets.only(top: AppSpacing.v12),
            child: GridView.builder(
              itemCount: count,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _gridCrossAxisCount,
                crossAxisSpacing: AppSpacing.h8,
                mainAxisSpacing: AppSpacing.h8,
                childAspectRatio: isOrganisors
                    ? _organisorsAspectRatio
                    : _gridChildAspectRatio,
              ),
              itemBuilder: (context, index) => CoreTeamMemberGridCard(
                member: members[index],
                isOrganisorsSection: isOrganisors,
                onTap: () => onMemberTap(members[index]),
              ),
            ),
          ),
          SizedBox(height: AppSpacing.v22),
        ],
      ],
    );
  }
}
