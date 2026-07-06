import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_knp_mobile_app_v2/common_widgets/fk_text_field.dart';
import 'package:flutter_knp_mobile_app_v2/common_widgets/fk_primary_button.dart';
import 'package:flutter_knp_mobile_app_v2/common_widgets/fk_file_upload_box.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/application/community_provider.dart';

class AnswerForm extends ConsumerStatefulWidget {
  final String questionId;
  final VoidCallback? onSubmitted;

  const AnswerForm({
    super.key,
    required this.questionId,
    this.onSubmitted,
  });

  @override
  ConsumerState<AnswerForm> createState() => _AnswerFormState();
}

class _AnswerFormState extends ConsumerState<AnswerForm> {
  late final TextEditingController _bodyController;
  late final TextEditingController _codeController;

  @override
  void initState() {
    super.initState();
    _bodyController = TextEditingController();
    _codeController = TextEditingController();
  }

  @override
  void dispose() {
    _bodyController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  void _submitAnswer() {
    final body = _bodyController.text.trim();

    if (body.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('⚠️ Please enter your answer'),
          backgroundColor: Colors.orange.shade600,
        ),
      );
      return;
    }

    if (body.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('⚠️ Answer must be at least 10 characters'),
          backgroundColor: Colors.orange.shade600,
        ),
      );
      return;
    }

    final codeSnippet = _codeController.text.trim();

    print('📝 [AnswerForm] Submitting answer for question: ${widget.questionId}');

    ref.read(communityActionControllerProvider.notifier).submitAnswer(
      questionId: widget.questionId,
      body: body,
      codeSnippet: codeSnippet.isEmpty ? null : codeSnippet,
    );
  }

  @override
  Widget build(BuildContext context) {
    final submitState = ref.watch(communityActionControllerProvider);

    ref.listen(communityActionControllerProvider, (previous, next) {
      next.when(
        data: (_) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('✅ Answer posted successfully'),
                backgroundColor: Colors.green.shade600,
              ),
            );
            _bodyController.clear();
            _codeController.clear();
            widget.onSubmitted?.call();
          }
        },
        error: (error, _) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('❌ Error: ${error.toString()}'),
                backgroundColor: Colors.red.shade600,
              ),
            );
          }
        },
        loading: () {},
      );
    });

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8.r),
        color: Colors.grey.shade50,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Answer',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 12.h),
          FkTextField(
            label: 'Answer',
            hint: 'Write your detailed answer here...',
            controller: _bodyController,
            maxLines: 5,
          ),
          SizedBox(height: 12.h),
          FkTextField(
            label: 'Code Snippet (Optional)',
            hint: 'Paste your code here if relevant...',
            controller: _codeController,
            maxLines: 4,
          ),
          SizedBox(height: 12.h),
          Text(
            'Attach file (Optional)',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          const FkFileUploadBox(),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: FkPrimaryButton(
                  label: 'Post Answer',
                  icon: null,
                  isLoading: submitState.isLoading,
                  onPressed: _submitAnswer,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
