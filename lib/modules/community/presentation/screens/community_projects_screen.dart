import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/router/route_names.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/application/community_provider.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/presentation/widgets/community_project_card.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_back_button.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_header.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CommunityProjectsScreen extends ConsumerWidget {
  const CommunityProjectsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projects = ref.watch(communityDashboardProvider).projects;

    return FkScreen(
      children: [
        const FkHeader(
          title: 'Projects',
          subtitle: 'Contribution projects, members, tech stack, and status.',
          leading: FkBackButton(),
        ),
        const SizedBox(height: 18),
        ElevatedButton(
          onPressed: () => context.go(RouteNames.communityUploadProject),
          child: const Text('Upload project'),
        ),
        const SizedBox(height: 14),
        for (final project in projects) CommunityProjectCard(project: project),
      ],
    );
  }
}
