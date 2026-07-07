import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/router/route_names.dart';
import 'package:flutter_knp_mobile_app_v2/common_widgets/fk_file_upload_box.dart';
import 'package:flutter_knp_mobile_app_v2/common_widgets/fk_primary_button.dart';
import 'package:flutter_knp_mobile_app_v2/common_widgets/fk_screen.dart';
import 'package:flutter_knp_mobile_app_v2/common_widgets/fk_status_chip.dart';
import 'package:flutter_knp_mobile_app_v2/common_widgets/fk_text_field.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/application/community_provider.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/domain/community_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class UploadProjectFormScreen extends ConsumerStatefulWidget {
  const UploadProjectFormScreen({super.key});

  @override
  ConsumerState<UploadProjectFormScreen> createState() =>
      _UploadProjectFormScreenState();
}

class _UploadProjectFormScreenState
    extends ConsumerState<UploadProjectFormScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _githubController = TextEditingController(
    text: 'https://github.com/angelica-singh-04',
  );

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _githubController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final actionState = ref.watch(communityActionControllerProvider);

    return FkScreen(
      children: [
        _TopBar(
          title: 'Upload project',
          onBack: () => context.go(RouteNames.communityUploadProject),
        ),
        const SizedBox(height: 26),
        FkTextField(
          label: 'Project name',
          hint: 'Enter title',
          controller: _nameController,
        ),
        const SizedBox(height: 26),
        FkTextField(
          label: 'Short description',
          hint: 'Max 120 characters',
          controller: _descriptionController,
          maxLines: 5,
        ),
        const SizedBox(height: 26),
        const FkTextField(label: 'Tech stack', hint: '-select-'),
        const SizedBox(height: 8),
        const Align(
          alignment: Alignment.centerLeft,
          child: FkStatusChip(label: 'React  X'),
        ),
        const SizedBox(height: 26),
        FkTextField(
          label: 'Project links',
          hint: 'Github URL',
          controller: _githubController,
        ),
        const SizedBox(height: 10),
        const FkTextField(label: '', hint: 'Live demo / APK'),
        const SizedBox(height: 26),
        Text(
          'Upload screenshot or file (optional)',
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 10),
        const FkFileUploadBox(),
        const SizedBox(height: 26),
        FkPrimaryButton(
          label: 'Submit project',
          isLoading: actionState.isLoading,
          onPressed: () async {
            final ok = await ref
                .read(communityActionControllerProvider.notifier)
                .submitProject(
                  CommunityProjectSubmission(
                    name: _nameController.text,
                    description: _descriptionController.text,
                    techStack: const ['React'],
                    links: [_githubController.text],
                  ),
                );
            if (!context.mounted) return;
            context.go(
              ok
                  ? RouteNames.communityProjectSubmitted
                  : RouteNames.communityNetworkError,
            );
          },
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
        const SizedBox(width: 48),
      ],
    );
  }
}
