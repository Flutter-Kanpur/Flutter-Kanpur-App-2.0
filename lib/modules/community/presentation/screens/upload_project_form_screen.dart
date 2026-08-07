import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_knp_mobile_app_v2/app/router/route_names.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/application/attachment_controller.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/application/community_provider.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/data/community_error_message.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/data/services/upload_service.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/domain/community_constants.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/domain/community_models.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_file_upload_box.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_multi_select_field.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_primary_button.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_screen.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_screen_top_bar.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_text_field.dart';
import 'package:flutter_knp_mobile_app_v2/utils/form_validators.dart';

/// Storage folder for project screenshots.
const _attachmentFolder = UploadService.projectsFolder;

class UploadProjectFormScreen extends ConsumerStatefulWidget {
  const UploadProjectFormScreen({super.key});

  @override
  ConsumerState<UploadProjectFormScreen> createState() =>
      _UploadProjectFormScreenState();
}

class _UploadProjectFormScreenState
    extends ConsumerState<UploadProjectFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _githubController = TextEditingController();
  final _liveDemoController = TextEditingController();

  List<String> _techStack = [];

  /// Only shown after a failed submit, so the field isn't red on first paint.
  String? _techStackError;
  AutovalidateMode _autovalidate = AutovalidateMode.disabled;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _githubController.dispose();
    _liveDemoController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final attachment = ref.read(
      attachmentControllerProvider(_attachmentFolder),
    );

    final formOk = _formKey.currentState?.validate() ?? false;
    final techOk = _techStack.isNotEmpty;

    setState(() {
      _autovalidate = AutovalidateMode.onUserInteraction;
      _techStackError = techOk ? null : 'Pick at least one technology.';
    });

    if (!formOk || !techOk) return;

    // Don't submit a half-uploaded screenshot — the URL wouldn't exist yet.
    if (attachment.isBusy) {
      _showMessage('Wait for the file upload to finish.');
      return;
    }

    final result = await ref
        .read(communityActionControllerProvider.notifier)
        .submitProject(
          CommunityProjectSubmission(
            name: _nameController.text.trim(),
            description: _descriptionController.text.trim(),
            techStack: _techStack,
            githubUrl: _githubController.text.trim(),
            liveDemoUrl: _liveDemoController.text.trim().isEmpty
                ? null
                : _liveDemoController.text.trim(),
            screenshotUrl: attachment.uploadedUrl,
          ),
        );

    if (!mounted) return;

    if (result.isSuccess) {
      ref.read(attachmentControllerProvider(_attachmentFolder).notifier).clear();
      context.go(RouteNames.communityProjectSubmitted);
    } else if (isOffline(result.error)) {
      // Only genuine connectivity failures get the retry screen. A schema or
      // permission error is not something "Try again" can fix, so it stays
      // here with a message that says what actually went wrong.
      context.go(RouteNames.communityNetworkError);
    } else {
      _showMessage(
        describeCommunityError(
          result.error,
          fallback: 'Could not submit your project.',
        ),
      );
    }
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
            title: 'Upload project',
            fallbackPath: RouteNames.communityUploadProject,
          ),
          SizedBox(height: AppSpacing.v22),

          FkTextField(
            label: 'Project name',
            hint: 'Enter title',
            controller: _nameController,
            maxLength: CommunityConstants.projectNameMaxLength,
            showCounter: false,
            textInputAction: TextInputAction.next,
            validator: (v) => FormValidators.minLength(
              v,
              min: 3,
              field: 'Project name',
            ),
          ),
          SizedBox(height: AppSpacing.v22),

          FkTextField(
            label: 'Short description',
            hint: 'Max 120 characters',
            controller: _descriptionController,
            maxLines: 5,
            maxLength: CommunityConstants.projectDescriptionMaxLength,
            validator: (v) => FormValidators.minLength(
              v,
              min: 10,
              field: 'Description',
            ),
          ),
          SizedBox(height: AppSpacing.v22),

          FkMultiSelectField(
            label: 'Tech stack',
            options: CommunityConstants.techStackOptions,
            selected: _techStack,
            maxSelections: CommunityConstants.maxTechStack,
            errorText: _techStackError,
            onChanged: (values) => setState(() {
              _techStack = values;
              if (values.isNotEmpty) _techStackError = null;
            }),
          ),
          SizedBox(height: AppSpacing.v22),

          FkTextField(
            label: 'Project links',
            hint: 'https://github.com/your-username/project',
            controller: _githubController,
            keyboardType: TextInputType.url,
            textInputAction: TextInputAction.next,
            validator: (v) => FormValidators.urlOnHost(
              v,
              host: 'github.com',
              field: 'GitHub link',
            ),
          ),
          // Figma spacing between the two link fields is 12, not 22.
          SizedBox(height: AppSpacing.v12),
          FkTextField(
            label: '',
            hint: 'Live demo / APK',
            controller: _liveDemoController,
            keyboardType: TextInputType.url,
            textInputAction: TextInputAction.done,
            validator: (v) =>
                FormValidators.url(v, optional: true, field: 'Live demo link'),
          ),
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
            label: 'Submit project',
            isLoading: actionState.isLoading,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
