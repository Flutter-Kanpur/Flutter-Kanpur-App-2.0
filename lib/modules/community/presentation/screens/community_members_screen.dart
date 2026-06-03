import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/application/community_provider.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/presentation/widgets/community_member_card.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_back_button.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_header.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommunityMembersScreen extends ConsumerWidget {
  const CommunityMembersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final members = ref.watch(communityDashboardProvider).members;

    return FkScreen(
      children: [
        const FkHeader(
          title: 'Members',
          subtitle:
              'Default member directory until auth/profile data is ready.',
          leading: FkBackButton(),
        ),
        const SizedBox(height: 18),
        for (final member in members) CommunityMemberCard(member: member),
      ],
    );
  }
}
