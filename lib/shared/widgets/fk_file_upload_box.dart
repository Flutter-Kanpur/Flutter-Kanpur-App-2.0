import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/common_widgets/fk_dotter_rectangle.dart';

/// A picked attachment, normalised across platforms.
///
/// [path] is null on web (file_picker returns bytes only there), so callers
/// that upload must handle both.
class FkPickedFile {
  const FkPickedFile({
    required this.name,
    required this.sizeBytes,
    this.path,
    this.bytes,
  });

  final String name;
  final int sizeBytes;
  final String? path;
  final List<int>? bytes;

  String get readableSize {
    if (sizeBytes < 1024) return '$sizeBytes B';
    if (sizeBytes < 1024 * 1024) {
      return '${(sizeBytes / 1024).toStringAsFixed(0)} KB';
    }
    return '${(sizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}

/// Dashed drop-zone for an optional screenshot / file.
///
/// Purely presentational: it renders the empty and selected states and calls
/// [onBrowse] / [onRemove]. Picking is left to the caller so this widget stays
/// free of platform plugins and testable.
class FkFileUploadBox extends StatelessWidget {
  const FkFileUploadBox({
    super.key,
    this.onBrowse,
    this.onRemove,
    this.file,
    this.isUploading = false,
    this.errorText,
    this.hint = 'Choose a file or drag & drop it here.',
  });

  final VoidCallback? onBrowse;
  final VoidCallback? onRemove;
  final FkPickedFile? file;
  final bool isUploading;
  final String? errorText;
  final String hint;

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null && errorText!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DottedRoundedRect(
          radius: AppRadius.radius04,
          strokeWidth: 2,
          color: hasError ? AppColors.warning600 : AppColors.neutral300,
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.h16,
            vertical: AppSpacing.v20,
          ),
          child: SizedBox(
            width: double.infinity,
            child: file == null ? _EmptyState(this) : _SelectedState(this),
          ),
        ),
        if (hasError) ...[
          SizedBox(height: AppSpacing.v6),
          Text(
            errorText!,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.warning600),
          ),
        ],
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState(this.box);

  final FkFileUploadBox box;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(
          Icons.cloud_upload_outlined,
          color: AppColors.neutral400,
          size: 28,
        ),
        SizedBox(height: AppSpacing.v10),
        Text(
          box.hint,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.neutral500),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: AppSpacing.v12),
        OutlinedButton.icon(
          onPressed: box.isUploading ? null : box.onBrowse,
          icon: box.isUploading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.file_upload_outlined, size: 18),
          label: Text(box.isUploading ? 'Uploading…' : 'Browse files'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.neutral950,
            side: const BorderSide(color: AppColors.neutral200),
            shape: RoundedRectangleBorder(borderRadius: AppRadius.all02),
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.h20,
              vertical: AppSpacing.v12,
            ),
          ),
        ),
      ],
    );
  }
}

class _SelectedState extends StatelessWidget {
  const _SelectedState(this.box);

  final FkFileUploadBox box;

  @override
  Widget build(BuildContext context) {
    final file = box.file!;
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(AppSpacing.h10),
          decoration: BoxDecoration(
            color: AppColors.primary50,
            borderRadius: AppRadius.all02,
          ),
          child: const Icon(
            Icons.insert_drive_file_outlined,
            color: AppColors.primary500,
            size: 20,
          ),
        ),
        SizedBox(width: AppSpacing.h12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                file.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: AppSpacing.v2),
              Text(
                box.isUploading ? 'Uploading…' : file.readableSize,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.neutral500),
              ),
            ],
          ),
        ),
        if (box.isUploading)
          const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        else
          IconButton(
            onPressed: box.onRemove,
            tooltip: 'Remove file',
            icon: const Icon(
              Icons.delete_outline_rounded,
              color: AppColors.warning600,
            ),
          ),
      ],
    );
  }
}
