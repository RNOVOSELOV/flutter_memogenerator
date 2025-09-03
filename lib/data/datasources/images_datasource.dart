import 'package:flutter/foundation.dart';

abstract interface class ImagesDatasource {
  Future<Uint8List?> getMemeThumbnailBytesData({required final String memeId});

  Future<bool> saveMemeThumbnailBytesData({
    required String memeId,
    required Uint8List thumbnailBinaryData,
  });

  Future<Uint8List?> getTemplatesBytesData({
    required final String templateImageName,
    required final String templateDirectory,
  });

  Future<String> saveFileDataAndReturnItName({
    required final String directoryWithFiles,
    required final String filePath,
    required final Uint8List fileBytesData,
  });

  Future<String?> saveTemplateToMemesImages({
    required final String templateFileName,
    required final String templateDirectory,
    required final String memeDirectory,
  });

  Future<({Uint8List imageBinary, double aspectRatio})?> getImageData({
    required String directoryWithFile,
    required String fileName,
  });
}
