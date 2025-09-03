import 'package:flutter/foundation.dart';

abstract interface class ImagesDatasource {
  Future<Uint8List?> getMemeThumbnailBytesData({required final String memeId});
  Future<bool> saveMemeThumbnailBytesData({required String memeId, required Uint8List thumbnailBinaryData});

  Future<String> saveFileDataAndReturnItName({
    required final String directoryWithFiles,
    required final String filePath,
    required final Uint8List fileBytesData,
  });

  Future<({Uint8List imageBinary, double aspectRatio})?> getImageData({
    required String directoryWithFile,
    required String fileName,
  });
}
