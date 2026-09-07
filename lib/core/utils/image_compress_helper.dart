import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';

class ImageCompressHelper {
  ImageCompressHelper._();

  /// Resizes/compresses to JPEG (~512px, quality 70). Returns new file path.
  static Future<String?> compressToAvatar(String sourcePath) async {
    final source = File(sourcePath);
    if (!await source.exists()) return null;

    final dir = await getTemporaryDirectory();
    final targetPath = p.join(
      dir.path,
      'avatar_${DateTime.now().millisecondsSinceEpoch}.jpg',
    );

    final result = await FlutterImageCompress.compressAndGetFile(
      sourcePath,
      targetPath,
      quality: 70,
      minWidth: 512,
      minHeight: 512,
      format: CompressFormat.jpeg,
    );

    return result?.path;
  }

  /// Compress screenshot for email attachment (~1600px, q70 → JPEG bytes).
  static Future<Uint8List?> compressForUpload(Uint8List sourceBytes) async {
    final result = await FlutterImageCompress.compressWithList(
      sourceBytes,
      quality: 70,
      minWidth: 1600,
      minHeight: 1600,
      format: CompressFormat.jpeg,
    );
    if (result.isEmpty) return null;
    return Uint8List.fromList(result);
  }
}
