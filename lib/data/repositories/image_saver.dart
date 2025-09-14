import 'package:flutter/foundation.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_saver/file_saver.dart';
import 'package:universal_io/io.dart';

class UniversalImageSaver {
  static Future<String?> saveImage(
    Uint8List imageData, {
    String? fileName,
    String? format,
  }) async {

    try {
      if (kIsWeb) {
        return await _saveImageWeb(
          imageData,
          fileName: fileName,
          format: format,
        );
      } else if (Platform.isAndroid || Platform.isIOS) {
        return await _saveImageMobile(imageData, fileName: fileName);
      } else if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
        return await _saveImageDesktop(
          imageData,
          fileName: fileName,
          format: format,
        );
      } else {
        return await _saveImageFallback(
          imageData,
          fileName: fileName,
          format: format,
        );
      }
    } catch (e) {
      print('Ошибка сохранения изображения: $e');
      return null;
    }
  }

  static Future<String?> _saveImageMobile(
    Uint8List imageData, {
    String? fileName,
  }) async {
    try {
      final result = await ImageGallerySaverPlus.saveImage(
        imageData,
        name: fileName ?? 'image_${DateTime.now().millisecondsSinceEpoch}',
        quality: 100,
        isReturnImagePathOfIOS: true,
      );

      return result['filePath']?.toString();
    } catch (e) {
      // Fallback на базовое сохранение
      return await _saveImageFallback(imageData, fileName: fileName);
    }
  }

  static Future<String?> _saveImageWeb(
    Uint8List imageData, {
    String? fileName,
    String? format,
  }) async {
    try {
      final MimeType mimeType = _getMimeType(imageData, format);
      final String actualFileName =
          fileName ??
          'image_${DateTime.now().millisecondsSinceEpoch}.${mimeType.name.toLowerCase()}';

      await FileSaver.instance.saveFile(
        name: actualFileName,
        bytes: imageData,
        mimeType: mimeType,
        fileExtension: mimeType.name.toLowerCase(),
      );

      return 'Saved to downloads';
    } catch (e) {
      print('Web save error: $e');
      return null;
    }
  }

  static Future<String?> _saveImageDesktop(
    Uint8List imageData, {
    String? fileName,
    String? format,
  }) async {
    try {
      final MimeType mimeType = _getMimeType(imageData, format);
      final String actualFileName =
          fileName ??
          'image_${DateTime.now().millisecondsSinceEpoch}.${mimeType.name.toLowerCase()}';
      final String? path = await FileSaver.instance.saveAs(
        bytes: imageData,
        fileExtension: mimeType.name.toLowerCase(),
        mimeType: mimeType,
        name: actualFileName,
      );

      return path;
    } catch (e) {
      return await _saveImageFallback(
        imageData,
        fileName: fileName,
        format: format,
      );
    }
  }

  static Future<String?> _saveImageFallback(
    Uint8List imageData, {
    String? fileName,
    String? format,
  }) async {
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final String actualFileName =
          fileName ?? 'image_${DateTime.now().millisecondsSinceEpoch}';
      final String extension = format ?? _getImageFormat(imageData);

      final File file = File('${directory.path}/$actualFileName.$extension');
      await file.writeAsBytes(imageData);

      return file.path;
    } catch (e) {
      print('Fallback save error: $e');
      return null;
    }
  }

  static String _getImageFormat(Uint8List data) {
    if (data.length >= 2) {
      if (data[0] == 0xFF && data[1] == 0xD8) return 'jpg';
      if (data.length >= 8 &&
          data[0] == 0x89 &&
          data[1] == 0x50 &&
          data[2] == 0x4E &&
          data[3] == 0x47) {
        return 'png';
      }
      if (data[0] == 0x47 && data[1] == 0x49 && data[2] == 0x46) return 'gif';
      if (data[0] == 0x52 &&
          data[1] == 0x49 &&
          data[2] == 0x46 &&
          data[3] == 0x46) {
        return 'webp';
      }
    }
    return 'png';
  }

  static MimeType _getMimeType(Uint8List data, String? format) {
    final String ext = format ?? _getImageFormat(data);
    switch (ext.toLowerCase()) {
      case 'jpg':
      case 'jpeg':
        return MimeType.jpeg;
      case 'png':
        return MimeType.png;
      case 'gif':
        return MimeType.gif;
      case 'webp':
        return MimeType.webp;
      case 'bmp':
        return MimeType.bmp;
      default:
        return MimeType.png;
    }
  }
}
