import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_knp_mobile_app_v2/app/router/route_names.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/application/attachment_controller.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/application/community_provider.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/domain/community_constants.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/domain/community_models.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_file_upload_box.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_multi_select_field.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_primary_button.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_removable_chip.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_screen.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_screen_top_bar.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_text_field.dart';
import 'package:flutter_knp_mobile_app_v2/utils/form_validators.dart';

const _attachmentFolder = 'questions';

class AskQuestionScreen extends ConsumerStatefulWidget {
  const AskQuestionScreen({super.key});

  @override
  ConsumerState<AskQuestionScreen> createState() => _AskQuestionScreenState();
}

class _AskQuestionScreenState extends ConsumerState<AskQuestionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _detailsController = TextEditingController();
  final _tagsController = TextEditingController();

  List<String> _category = [];
  List<String> _tags = [];

  String? _categoryError;
  AutovalidateMode _autovalidate = AutovalidateMode.disabled;

  @override
  void dispose() {
    _titleController.dispose();
    _detailsController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  void _addTag([String? raw]) {
    final tag = (raw ?? _tagsController.text)
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'^#'), '');

    if (tag.isEmpty) return;
    if (_tags.length >= CommunityConstants.maxTags) {
      _showMessage('You can add up to ${CommunityConstants.maxTags} tags.');
      return;
    }
    if (tag.length > CommunityConstants.tagMaxLength) {
      _showMessage(
        'Tags must be ${CommunityConstants.tagMaxLength} characters or fewer.',
      );
      return;
    }
    if (_tags.contains(tag)) {
      _tagsController.clear();
      return;
    }

    setState(() {
      _tags = [..._tags, tag];
      _tagsController.clear();
    });
  }

  void _removeTag(String tag) {
    setState(() => _tags = _tags.where((t) => t != tag).toList());
  }

  Future<void> _submit() async {
    final attachment = ref.read(
      attachmentControllerProvider(_attachmentFolder),
    );

    final formOk = _formKey.currentState?.validate() ?? false;
    final categoryOk = _category.isNotEmpty;

    setState(() {
      _autovalidate = AutovalidateMode.onUserInteraction;
      _categoryError = categoryOk ? null : 'Choose a category.';
    });

    if (!formOk || !categoryOk) return;

    if (attachment.isBusy) {
      _showMessage('Wait for the file upload to finish.');
      return;
    }

    final result = await ref
        .read(communityActionControllerProvider.notifier)
        .submitQuestion(
          CommunityQuestionDraft(
            title: _titleController.text.trim(),
            details: _detailsController.text.trim(),
            category: _category.first,
            tags: _tags,
            imageUrl: attachment.uploadedUrl,
          ),
        );

    if (!mounted) return;

    if (result.isSuccess) {
      ref.read(attachmentControllerProvider(_attachmentFolder).notifier).clear();
      context.go(RouteNames.communityQuestionPosted);
    } else if (_isConnectivityError(result.error)) {
      context.go(RouteNames.communityNetworkError);
    } else {
      _showMessage(result.message);
    }
  }

  bool _isConnectivityError(Object? error) {
    final text = error.toString().toLowerCase();
    return text.contains('socket') ||
        text.contains('network') ||
        text.contains('timeout') ||
        text.contains('connection') ||
        text.contains('failed host lookup');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: AppColors.warning600,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final actionState = ref.watch(communityActionControllerProvider);
    final attachment = ref.watch(
      attachmentControllerProvider(_attachmentFolder),
    );

    // Suggestions already added are dropped from the quick-pick row.
    final suggestions = CommunityConstants.suggestedTags
        .where((t) => !_tags.contains(t))
        .take(6)
        .toList();

    return Form(
      key: _formKey,
      autovalidateMode: _autovalidate,
      child: FkScreen(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.h16,
          AppSpacing.v12,
          AppSpacing.h16,
          96,
        ),
        children: [
          FkScreenTopBar(
            title: 'Ask a question',
            fallbackPath: RouteNames.community,
          ),
          SizedBox(height: AppSpacing.v22),

          FkTextField(
            label: 'Question title',
            hint: 'Enter title',
            controller: _titleController,
            maxLength: CommunityConstants.questionTitleMaxLength,
            textInputAction: TextInputAction.next,
            validator: (v) => FormValidators.minLength(
              v,
              min: CommunityConstants.questionTitleMinLength,
              field: 'Title',
            ),
          ),
          SizedBox(height: AppSpacing.v22),

          FkTextField(
            label: 'Details',
            hint: "Add more context, code snippets, or what you've tried so far.",
            controller: _detailsController,
            maxLines: 5,
            maxLength: CommunityConstants.questionDetailsMaxLength,
            validator: (v) =>
                FormValidators.minLength(v, min: 20, field: 'Details'),
          ),
          SizedBox(height: AppSpacing.v22),

          FkMultiSelectField(
            label: 'Choose a category',
            options: CommunityConstants.questionCategories,
            selected: _category,
            maxSelections: 1,
            errorText: _categoryError,
            onChanged: (values) => setState(() {
              _category = values;
              if (values.isNotEmpty) _categoryError = null;
            }),
          ),
          SizedBox(height: AppSpacing.v22),

          FkTextField(
            label: 'Tags',
            hint: 'add tags',
            controller: _tagsController,
            maxLength: CommunityConstants.tagMaxLength,
            showCounter: false,
            textInputAction: TextInputAction.done,
            onChanged: (value) {
              // Typing a space or comma commits the tag, as tag inputs do.
              if (value.endsWith(' ') || value.endsWith(',')) {
                _addTag(value.substring(0, value.length - 1));
              }
            },
            suffix: IconButton(
              onPressed: _addTag,
              tooltip: 'Add tag',
              icon: const Icon(Icons.add_rounded, color: AppColors.primary500),
            ),
          ),
          if (_tags.isNotEmpty) ...[
            SizedBox(height: AppSpacing.v12),
            Wrap(
              spacing: AppSpacing.h8,
              runSpacing: AppSpacing.v8,
              children: _tags
                  .map(
                    (tag) => FkRemovableChip(
                      label: '#$tag',
                      onRemove: () => _removeTag(tag),
                    ),
                  )
                  .toList(),
            ),
          ],
          if (suggestions.isNotEmpty &&
              _tags.length < CommunityConstants.maxTags) ...[
            SizedBox(height: AppSpacing.v12),
            Wrap(
              spacing: AppSpacing.h8,
              runSpacing: AppSpacing.v8,
              children: suggestions
                  .map(
                    (tag) => ActionChip(
                      label: Text('#$tag'),
                      onPressed: () => _addTag(tag),
                      backgroundColor: AppColors.primary50,
                      side: const BorderSide(color: AppColors.primary100),
                      labelStyle: Theme.of(context).textTheme.labelMedium
                          ?.copyWith(color: AppColors.primary700),
                    ),
                  )
                  .toList(),
            ),
          ],
          SizedBox(height: AppSpacing.v22),

          Text(
            'Upload screenshot or file (optional)',
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          SizedBox(height: AppSpacing.v10),
          FkFileUploadBox(
            file: attachment.file,
            isUploading: attachment.isBusy,
            errorText: attachment.error,
            onBrowse: () => ref
                .read(
                  attachmentControllerProvider(_attachmentFolder).notifier,
                )
                .pickAndUpload(),
            onRemove: () => ref
                .read(
                  attachmentControllerProvider(_attachmentFolder).notifier,
                )
                .clear(),
          ),
          SizedBox(height: AppSpacing.v22),

          FkPrimaryButton(
            label: 'Post question',
            icon: null,
            isLoading: actionState.isLoading,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
