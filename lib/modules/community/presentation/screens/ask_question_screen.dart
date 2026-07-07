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

class AskQuestionScreen extends ConsumerStatefulWidget {
  const AskQuestionScreen({super.key});

  @override
  ConsumerState<AskQuestionScreen> createState() => _AskQuestionScreenState();
}

class _AskQuestionScreenState extends ConsumerState<AskQuestionScreen> {
  final _titleController = TextEditingController();
  final _detailsController = TextEditingController();
  final _tagsController = TextEditingController();

  String _selectedCategory = 'general';
  final List<String> _categories = ['general', 'flutter', 'dart', 'widgets', 'state-management'];
  List<String> _selectedTags = [];
  String? _selectedImageUrl;

  @override
  void dispose() {
    _titleController.dispose();
    _detailsController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  void _addTag() {
    final tag = _tagsController.text.trim();
    if (tag.isNotEmpty && !_selectedTags.contains(tag)) {
      setState(() {
        _selectedTags.add(tag);
        _tagsController.clear();
      });
    }
  }

  void _removeTag(String tag) {
    setState(() {
      _selectedTags.remove(tag);
    });
  }

  @override
  Widget build(BuildContext context) {
    final actionState = ref.watch(communityActionControllerProvider);

    ref.listen(communityActionControllerProvider, (previous, next) {
      next.when(
        data: (_) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('✅ Question posted successfully'),
                backgroundColor: Colors.green.shade600,
              ),
            );
            Future.delayed(const Duration(milliseconds: 800)).then((_) {
              if (context.mounted) {
                context.go(RouteNames.communityDiscussions);
              }
            });
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

    return FkScreen(
      children: [
        _TopBar(
          title: 'Ask a question',
          onBack: () => context.pop(),
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
        // Category Dropdown
        Text(
          'Choose a category',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<String>(
            value: _selectedCategory,
            isExpanded: true,
            underline: const SizedBox(),
            items: _categories
                .map((category) => DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    ))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => _selectedCategory = value);
              }
            },
          ),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerLeft,
          child: FkStatusChip(label: '$_selectedCategory  X'),
        ),
        const SizedBox(height: 26),
        // Tags Input
        FkTextField(
          label: 'Tags',
          hint: 'add tags',
          controller: _tagsController,
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerLeft,
          child: GestureDetector(
            onTap: _addTag,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text('+ Add Tag'),
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (_selectedTags.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _selectedTags
                .map((tag) => GestureDetector(
                      onTap: () => _removeTag(tag),
                      child: FkStatusChip(label: '#$tag  X'),
                    ))
                .toList(),
          ),
        const SizedBox(height: 26),
        // File Upload
        Text(
          'Upload screenshot or file (optional)',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 10),
        const FkFileUploadBox(),
        const SizedBox(height: 26),
        // Submit Button
        FkPrimaryButton(
          label: 'Post question',
          icon: null,
          isLoading: actionState.isLoading,
          onPressed: () {
            if (_titleController.text.isEmpty ||
                _detailsController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('⚠️ Please fill in title and details'),
                  backgroundColor: Colors.orange.shade600,
                ),
              );
              return;
            }

            final draft = CommunityQuestionDraft(
              title: _titleController.text.trim(),
              details: _detailsController.text.trim(),
              category: _selectedCategory,
              tags: _selectedTags,
              imageUrl: _selectedImageUrl,
            );

            ref.read(communityActionControllerProvider.notifier).submitQuestion(draft);
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
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
        const SizedBox(width: 48),
      ],
    );
  }
}
