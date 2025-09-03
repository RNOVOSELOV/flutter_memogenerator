import 'package:flutter/foundation.dart';

abstract interface class ImagesDatasource {
  Future<Uint8List?> getMemeThumbnailBytesData({required final String memeId});

  Future<String> saveFileDataAndReturnItName({
    required final String directoryWithFiles,
    required final String filePath,
    required final Uint8List fileBytesData,
  });
}
