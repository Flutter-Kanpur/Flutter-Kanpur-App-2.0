import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/router/route_names.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/application/community_provider.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/presentation/widgets/community_project_card.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_back_button.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_header.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_primary_button.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_screen.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CommunityProjectsScreen extends ConsumerWidget {
  const CommunityProjectsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsAsync = ref.watch(communityProjectsProvider);

    return FkScreen(
      children: [
        const FkHeader(
          title: 'Projects',
          subtitle: 'Community projects, tech stack, and status.',
          leading: FkBackButton(),
        ),
        const SizedBox(height: 18),
        FkPrimaryButton(
          label: 'Upload your project',
          onPressed: () => context.go(RouteNames.communityUploadProject),
        ),
        const SizedBox(height: 20),
        projectsAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 48),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (e, _) => _ErrorView(
            onRetry: () =>
                ref.read(communityProjectsProvider.notifier).refresh(),
          ),
          data: (projects) {
            if (projects.isEmpty) {
              return const _EmptyView(
                message: 'No projects yet.\nBe the first to upload one!',
              );
            }
            return Column(
              children: [
                for (final project in projects)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: CommunityProjectCard(project: project),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          const Icon(Icons.wifi_off_rounded, size: 48, color: Colors.grey),
          const SizedBox(height: 12),
          Text(
            'Could not load projects',
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: AppColors.subtitleTextDarkGrey),
          ),
          const SizedBox(height: 16),
          TextButton(onPressed: onRetry, child: const Text('Try again')),
        ],
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Center(
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: AppColors.subtitleTextDarkGrey),
        ),
      ),
    );
  }
}
