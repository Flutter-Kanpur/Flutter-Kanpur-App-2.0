import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/presentation/widgets/community_async_views.dart';
import 'package:flutter_knp_mobile_app_v2/modules/explore/application/explore_providers.dart';
import 'package:flutter_knp_mobile_app_v2/modules/explore/presentation/widgets/core_team_member_skeleton.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_section_title.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Watches [coreTeamMembersProvider] directly (rather than receiving a list
/// prop), matching CommunityProjectsPreviewSection
/// now that this is a real Supabase fetch (community_memberships joined with
/// users) instead of sample data. Stateful only for the horizontal
/// ScrollController driving pagination - same on-scroll pattern as
/// CommunityDiscussionsScreen.
class CoreTeamPreviewSection extends ConsumerStatefulWidget {
  const CoreTeamPreviewSection({super.key, required this.onViewAllTap});

  final VoidCallback onViewAllTap;

  @override
  ConsumerState<CoreTeamPreviewSection> createState() =>
      _CoreTeamPreviewSectionState();
}

class _CoreTeamPreviewSectionState
    extends ConsumerState<CoreTeamPreviewSection> {
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

  /// Fetches the next page once the user is within 200px of the trailing
  /// edge of the horizontal list. The notifier itself guards against
  /// overlapping calls.
  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 200) {
      ref.read(coreTeamMembersProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final membersAsync = ref.watch(coreTeamMembersProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FkSectionTitle(
          title: 'Core team',
          actionLabel: 'View all',
          onActionTap: widget.onViewAllTap,
        ),
        membersAsync.when(
          loading: () => const CoreTeamMemberSkeleton(),
          error: (error, _) => CommunityErrorView(
            message: 'Could not load core team.',
            error: error,
            compact: true,
            onRetry: () => ref.invalidate(coreTeamMembersProvider),
          ),
          data: (state) {
            final members = state.members;
            if (members.isEmpty) {
              // The outer section Column is left-aligned, so without this the
              // empty view shrink-wraps to its own content width instead of
              // centering across the full section width.
              return const SizedBox(
                width: double.infinity,
                child: CommunityEmptyView(
                  icon: Icons.groups_outlined,
                  message: 'No core team members to show yet.',
                ),
              );
            }
            final itemCount = members.length + (state.isLoadingMore ? 1 : 0);
            return SizedBox(
              height: 90,
              child: ListView.separated(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: itemCount,
                separatorBuilder: (_, __) => SizedBox(width: AppSpacing.h16),
                itemBuilder: (context, index) {
                  if (index >= members.length) {
                    return const SizedBox(
                      width: 64,
                      child: Center(
                        child: SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    );
                  }

                  final member = members[index];
                  final hasPhoto =
                      member.photoUrl != null && member.photoUrl!.isNotEmpty;

                  return InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(40),
                    child: SizedBox(
                      width: 64,
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundColor: AppColors.primary100,
                            child: ClipOval(
                              // Falls back to the default avatar asset when
                              // there is no photo_url, and again if the URL
                              // fails to load.
                              child: hasPhoto
                                  ? CachedNetworkImage(
                                      imageUrl: member.photoUrl!,
                                      width: 56,
                                      height: 56,
                                      fit: BoxFit.cover,
                                      errorWidget: (_, __, ___) =>
                                          const _DefaultAvatar(),
                                    )
                                  : const _DefaultAvatar(),
                            ),
                          ),
                          SizedBox(height: AppSpacing.v6),
                          Text(
                            member.name,
                            style: AppTextStyles.bodySmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}

/// Default avatar for a member with no photo_url (or a broken photo URL).
/// AssetsPath.avatarIcon's SVG has a tall/narrow 32x46 viewBox, which leaves
/// visible gaps on the sides when scaled into a square avatar circle and
/// doesn't read as a clean circle - a plain Material person glyph doesn't
/// have that problem at any size.
class _DefaultAvatar extends StatelessWidget {
  const _DefaultAvatar();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 56,
      height: 56,
      child: Center(
        child: Icon(Icons.person, size: 32, color: AppColors.primary500),
      ),
    );
  }
}
