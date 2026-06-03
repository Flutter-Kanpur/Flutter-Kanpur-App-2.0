import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/router/route_names.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_file_upload_box.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_primary_button.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_screen.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_status_chip.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_text_field.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/application/community_provider.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/domain/community_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AskQuestionScreen extends ConsumerStatefulWidget {
  const AskQuestionScreen({super.key});

  @override
  ConsumerState<AskQuestionScreen> createState() => _AskQuestionScreenState();
}

class _AskQuestionScreenState extends ConsumerState<AskQuestionScreen> {
  final _titleController = TextEditingController(text: 'Angelica Singh');
  final _detailsController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final actionState = ref.watch(communityActionControllerProvider);

    return FkScreen(
      children: [
        _TopBar(
          title: 'Ask a question',
          onBack: () => context.go(RouteNames.communityDiscussions),
        ),
        const SizedBox(height: 26),
        FkTextField(
          label: 'Question title',
          hint: 'Enter title',
          controller: _titleController,
        ),
        const SizedBox(height: 26),
        FkTextField(
          label: 'Details',
          hint: "Add more context, code snippets, or what you've tried so far.",
          controller: _detailsController,
          maxLines: 5,
        ),
        const SizedBox(height: 26),
        const FkTextField(label: 'Choose a category', hint: '-select-'),
        const SizedBox(height: 8),
        const Align(
          alignment: Alignment.centerLeft,
          child: FkStatusChip(label: 'Community Help  X'),
        ),
        const SizedBox(height: 26),
        const FkTextField(label: 'Tags', hint: 'add tags'),
        const SizedBox(height: 8),
        const Align(
          alignment: Alignment.centerLeft,
          child: FkStatusChip(label: '#dolor  X'),
        ),
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
          label: 'Post question',
          icon: null,
          isLoading: actionState.isLoading,
          onPressed: () async {
            final ok = await ref
                .read(communityActionControllerProvider.notifier)
                .submitQuestion(
                  CommunityQuestionDraft(
                    title: _titleController.text,
                    details: _detailsController.text,
                    category: 'Community Help',
                    tags: const ['dolor'],
                  ),
                );
            if (!context.mounted) return;
            context.go(
              ok
                  ? RouteNames.communityDiscussionDetail
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
