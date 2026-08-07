import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/application/community_provider.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/domain/community_constants.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/domain/community_models.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/presentation/widgets/community_async_views.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/presentation/widgets/community_author_row.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_text_field.dart';
import 'package:flutter_knp_mobile_app_v2/utils/form_validators.dart';

/// "Post your reply" sheet for the comment thread under a single answer.
Future<void> showAnswerCommentsSheet(
  BuildContext context, {
  required String questionId,
  required CommunityReply answer,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.r04)),
    ),
    builder: (_) =>
        _AnswerCommentsSheet(questionId: questionId, answer: answer),
  );
}

class _AnswerCommentsSheet extends ConsumerStatefulWidget {
  const _AnswerCommentsSheet({required this.questionId, required this.answer});

  final String questionId;
  final CommunityReply answer;

  @override
  ConsumerState<_AnswerCommentsSheet> createState() =>
      _AnswerCommentsSheetState();
}

class _AnswerCommentsSheetState extends ConsumerState<_AnswerCommentsSheet> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _submitting = true);
    final result = await ref
        .read(communityActionControllerProvider.notifier)
        .submitComment(
          answerId: widget.answer.id,
          questionId: widget.questionId,
          body: _controller.text.trim(),
        );

    if (!mounted) return;
    setState(() => _submitting = false);

    if (result.isSuccess) {
      _controller.clear();
      FocusScope.of(context).unfocus();
    } else {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(result.message),
            backgroundColor: AppColors.warning600,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final commentsAsync = ref.watch(answerCommentsProvider(widget.answer.id));

    return Padding(
      // Lifts the composer above the keyboard.
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.h16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Post your reply',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: AppSpacing.all(AppSpacing.h16),
                children: [
                  // The answer being replied to, for context.
                  CommunityAuthorRow(
                    name: widget.answer.authorName,
                    subtitle: widget.answer.createdLabel,
                    photoUrl: widget.answer.authorPhotoUrl,
                    radius: 16,
                  ),
                  SizedBox(height: AppSpacing.v10),
                  Text(
                    widget.answer.body,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.neutral600,
                      height: 1.45,
                    ),
                  ),
                  const Divider(height: 30),

                  commentsAsync.when(
                    loading: () => const CommunityLoadingView(height: 120),
                    error: (e, _) => CommunityErrorView(
                      error: e,
                      message: 'Could not load replies.',
                      onRetry: () => ref
                          .read(
                            answerCommentsProvider(widget.answer.id).notifier,
                          )
                          .refresh(),
                    ),
                    data: (comments) {
                      if (comments.isEmpty) {
                        return const CommunityEmptyView(
                          icon: Icons.mode_comment_outlined,
                          message: 'No replies yet.',
                        );
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (final comment in comments) ...[
                            CommunityAuthorRow(
                              name: comment.authorName,
                              subtitle: comment.createdLabel,
                              photoUrl: comment.authorPhotoUrl,
                              radius: 14,
                            ),
                            SizedBox(height: AppSpacing.v6),
                            Padding(
                              padding: EdgeInsets.only(left: AppSpacing.h20),
                              child: Text(
                                comment.body,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(height: 1.45),
                              ),
                            ),
                            SizedBox(height: AppSpacing.v16),
                          ],
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: AppSpacing.all(AppSpacing.h16),
              child: Form(
                key: _formKey,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: FkTextField(
                        label: '',
                        hint: 'Write a reply',
                        controller: _controller,
                        maxLines: 3,
                        maxLength: CommunityConstants.answerMaxLength,
                        showCounter: false,
                        validator: (v) => FormValidators.minLength(
                          v,
                          min: 2,
                          field: 'Reply',
                        ),
                      ),
                    ),
                    SizedBox(width: AppSpacing.h10),
                    IconButton.filled(
                      onPressed: _submitting ? null : _submit,
                      icon: _submitting
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.send_rounded),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
