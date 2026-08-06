import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class UploadService {
  final SupabaseClient _supabase;

  UploadService(this._supabase);

  /// Upload file to Supabase Storage
  Future<String> uploadFile({
    required File file,
    required String bucket,
    required String path,
    Function(int)? onProgress,
  }) async {
    try {
      // Check file size
      final fileSize = await file.length();
      if (fileSize > 10 * 1024 * 1024) {
        throw Exception('File too large (max 10MB)');
      }

      // Generate unique filename
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
      final uploadPath = '$path/$fileName';

      // Upload to Supabase Storage
      await _supabase.storage
          .from(bucket)
          .upload(
            uploadPath,
            file,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      // Return public URL
      final publicUrl = _supabase.storage.from(bucket).getPublicUrl(uploadPath);
      return publicUrl;
    } catch (e) {
      throw Exception('Upload failed: $e');
    }
  }

  /// Upload multiple files
  Future<List<String>> uploadMultiple({
    required List<File> files,
    required String bucket,
    required String path,
  }) async {
    final urls = <String>[];
    for (var file in files) {
      try {
        final url = await uploadFile(file: file, bucket: bucket, path: path);
        urls.add(url);
      } catch (e) {
        print('Failed to upload file: $e');
      }
    }
    return urls;
  }

  /// Delete file from storage
  Future<void> deleteFile({
    required String bucket,
    required String path,
  }) async {
    try {
      await _supabase.storage.from(bucket).remove([path]);
    } catch (e) {
      throw Exception('Delete failed: $e');
    }
  }

  /// Get public URL for a file
  String getPublicUrl({required String bucket, required String path}) {
    return _supabase.storage.from(bucket).getPublicUrl(path);
  }
}
