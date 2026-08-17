import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/application/community_provider.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/domain/community_constants.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_primary_button.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_text_field.dart';
import 'package:flutter_knp_mobile_app_v2/utils/form_validators.dart';

/// Reply composer shown under a discussion.
///
/// The post button is always visible. It used to appear only after the field
/// took focus, which left no visible way to submit a reply - the control the
/// user needed was hidden behind the interaction it was meant to complete.
/// Only the optional code-snippet field is progressive now.
class AnswerForm extends ConsumerStatefulWidget {
  const AnswerForm({
    super.key,
    required this.questionId,
    this.onSubmitted,
    this.autofocus = false,
  });

  final String questionId;
  final VoidCallback? onSubmitted;
  final bool autofocus;

  @override
  ConsumerState<AnswerForm> createState() => _AnswerFormState();
}

class _AnswerFormState extends ConsumerState<AnswerForm> {
  final _formKey = GlobalKey<FormState>();
  final _bodyController = TextEditingController();
  final _codeController = TextEditingController();
  final _bodyFocus = FocusNode();

  bool _expanded = false;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _expanded = widget.autofocus;
    _bodyFocus.addListener(() {
      if (_bodyFocus.hasFocus && !_expanded) setState(() => _expanded = true);
    });
  }

  @override
  void dispose() {
    _bodyController.dispose();
    _codeController.dispose();
    _bodyFocus.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final code = _codeController.text.trim();

    setState(() => _submitting = true);
    // Awaiting the result rather than listening to the shared controller:
    // ref.listen on communityActionControllerProvider also fired for unrelated
    // actions, which cleared this form when some other submit succeeded.
    final result = await ref
        .read(communityActionControllerProvider.notifier)
        .submitAnswer(
          questionId: widget.questionId,
          body: _bodyController.text.trim(),
          codeSnippet: code.isEmpty ? null : code,
        );

    if (!mounted) return;
    setState(() => _submitting = false);

    final messenger = ScaffoldMessenger.of(context)..hideCurrentSnackBar();

    if (result.isSuccess) {
      _bodyController.clear();
      _codeController.clear();
      setState(() => _expanded = false);
      _bodyFocus.unfocus();
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Reply posted'),
          backgroundColor: AppColors.success600,
        ),
      );
      widget.onSubmitted?.call();
    } else {
      messenger.showSnackBar(
        SnackBar(
          content: Text(result.message),
          backgroundColor: AppColors.warning600,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FkTextField(
            label: '',
            hint: 'Write a reply',
            controller: _bodyController,
            maxLines: _expanded ? 4 : 2,
            maxLength: CommunityConstants.answerMaxLength,
            showCounter: _expanded,
            validator: (v) => FormValidators.minLength(
              v,
              min: 10,
              field: 'Reply',
            ),
          ),
          if (_expanded) ...[
            SizedBox(height: AppSpacing.v12),
            FkTextField(
              label: 'Code snippet (optional)',
              hint: 'Paste code that helps explain your answer',
              controller: _codeController,
              maxLines: 4,
            ),
          ],
          SizedBox(height: AppSpacing.v12),
          Row(
            children: [
              if (_expanded) ...[
                TextButton(
                  onPressed: _submitting
                      ? null
                      : () {
                          _bodyController.clear();
                          _codeController.clear();
                          _bodyFocus.unfocus();
                          setState(() => _expanded = false);
                        },
                  child: const Text('Cancel'),
                ),
                SizedBox(width: AppSpacing.h12),
              ],
              Expanded(
                child: FkPrimaryButton(
                  label: 'Post reply',
                  icon: Icons.send_rounded,
                  isLoading: _submitting,
                  onPressed: _submit,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
