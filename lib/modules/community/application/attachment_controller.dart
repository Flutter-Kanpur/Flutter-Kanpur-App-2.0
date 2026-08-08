import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_knp_mobile_app_v2/modules/community/data/services/upload_service.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_file_upload_box.dart';

final uploadServiceProvider = Provider<UploadService>((ref) => UploadService());

/// Pick → upload → remove for a single optional attachment.
class AttachmentState {
  const AttachmentState({
    this.file,
    this.uploadedUrl,
    this.isBusy = false,
    this.error,
  });

  final FkPickedFile? file;

  /// Public URL once the upload finishes — this is what gets submitted.
  final String? uploadedUrl;
  final bool isBusy;
  final String? error;

  bool get hasFile => file != null;
}

/// Shared by the Ask-a-question and Upload-project forms.
///
/// [folder] namespaces the object in the storage bucket, e.g. `questions`.
///
/// autoDispose so the state resets once the form closes. Without it a file
/// picked but never submitted stayed in the provider and silently re-attached
/// itself to the next question or project the user started.
final attachmentControllerProvider = NotifierProvider.autoDispose.family<
  AttachmentController,
  AttachmentState,
  String
>(AttachmentController.new);

class AttachmentController extends Notifier<AttachmentState> {
  AttachmentController(this.folder);

  final String folder;

  @override
  AttachmentState build() => const AttachmentState();

  /// Opens the picker and uploads in one step, so the URL is ready by the time
  /// the user submits and the form never has to block on a slow upload.
  Future<void> pickAndUpload() async {
    state = const AttachmentState(isBusy: true);
    try {
      final picked = await ref.read(uploadServiceProvider).pickFile();
      if (picked == null) {
        state = const AttachmentState();
        return;
      }

      state = AttachmentState(file: picked, isBusy: true);

      final url = await ref
          .read(uploadServiceProvider)
          .upload(file: picked, folder: folder);

      state = AttachmentState(file: picked, uploadedUrl: url);
    } on UploadException catch (e) {
      state = AttachmentState(error: e.message);
    } catch (e) {
      state = AttachmentState(error: 'Could not attach file. $e');
    }
  }

  void clear() => state = const AttachmentState();
}
