import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_file_upload_box.dart';

/// Picks and uploads community attachments (question screenshots, project
/// covers) to Supabase Storage.
///
/// Handles web and native: `file_picker` gives bytes on web and a path on
/// native, and both routes end in the same public URL.
class UploadService {
  UploadService([SupabaseClient? client])
    : _supabase = client ?? Supabase.instance.client;

  final SupabaseClient _supabase;

  /// Bucket the community module writes into.
  static const communityBucket = 'community';

  static const maxBytes = 10 * 1024 * 1024; // 10 MB
  static const allowedExtensions = ['png', 'jpg', 'jpeg', 'webp', 'gif', 'pdf'];

  /// Opens the system picker. Returns null when the user cancels.
  ///
  /// Throws [UploadException] if the chosen file is too large, so the caller
  /// can surface the reason rather than silently dropping it.
  Future<FkPickedFile?> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: allowedExtensions,
      // Web can only hand back bytes; asking for them on native too would
      // load the whole file into memory for nothing.
      withData: kIsWeb,
    );
    if (result == null || result.files.isEmpty) return null;

    final picked = result.files.first;
    if (picked.size > maxBytes) {
      throw const UploadException('File is larger than 10 MB.');
    }

    return FkPickedFile(
      name: picked.name,
      sizeBytes: picked.size,
      path: kIsWeb ? null : picked.path,
      bytes: picked.bytes,
    );
  }

  /// Uploads [file] under `folder/` and returns its public URL.
  Future<String> upload({
    required FkPickedFile file,
    required String folder,
    String bucket = communityBucket,
  }) async {
    if (file.sizeBytes > maxBytes) {
      throw const UploadException('File is larger than 10 MB.');
    }

    final storagePath = '$folder/${_uniqueName(file.name)}';
    final options = FileOptions(
      cacheControl: '3600',
      upsert: false,
      contentType: _contentTypeFor(file.name),
    );

    try {
      final storage = _supabase.storage.from(bucket);

      if (file.bytes != null) {
        await storage.uploadBinary(
          storagePath,
          Uint8List.fromList(file.bytes!),
          fileOptions: options,
        );
      } else if (file.path != null) {
        await storage.upload(storagePath, File(file.path!), fileOptions: options);
      } else {
        throw const UploadException('Selected file could not be read.');
      }

      return storage.getPublicUrl(storagePath);
    } on StorageException catch (e) {
      throw UploadException(e.message);
    }
  }

  Future<void> deleteFile({
    required String path,
    String bucket = communityBucket,
  }) async {
    try {
      await _supabase.storage.from(bucket).remove([path]);
    } on StorageException catch (e) {
      throw UploadException(e.message);
    }
  }

  String getPublicUrl({required String path, String bucket = communityBucket}) {
    return _supabase.storage.from(bucket).getPublicUrl(path);
  }

  /// Timestamp prefix keeps two uploads of `screenshot.png` from colliding.
  String _uniqueName(String original) {
    final ext = p.extension(original);
    final base = p
        .basenameWithoutExtension(original)
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-|-$'), '');
    final safeBase = base.isEmpty ? 'file' : base;
    return '${DateTime.now().millisecondsSinceEpoch}_$safeBase$ext';
  }

  String? _contentTypeFor(String name) {
    return switch (p.extension(name).toLowerCase()) {
      '.png' => 'image/png',
      '.jpg' || '.jpeg' => 'image/jpeg',
      '.webp' => 'image/webp',
      '.gif' => 'image/gif',
      '.pdf' => 'application/pdf',
      _ => null,
    };
  }
}

/// Upload / pick failure with a message that is safe to show to the user.
class UploadException implements Exception {
  const UploadException(this.message);

  final String message;

  @override
  String toString() => message;
}
