import 'dart:async';
import 'dart:developer';
import 'dart:io' show Platform;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:memogenerator/data/image_type_enum.dart';

import '../datasources/images_datasource.dart';
import 'sp_images_datasource.dart';

class SpImagesDatasourceImpl implements ImagesDatasource {
  final SharedPreferenceImageData _spData;

  const SpImagesDatasourceImpl({
    required final SharedPreferenceImageData sharedPreferenceImageData,
  }) : _spData = sharedPreferenceImageData;

  Future<double> _getAspectRatio(Uint8List imageBinary) async {
    final completer = Completer<ui.Image>();
    ui.decodeImageFromList(imageBinary, completer.complete);
    final image = await completer.future;
    final ratio = image.width / image.height;
    image.dispose();
    return ratio;
  }

  String _getStorageKey({
    required final String keyPrefix,
    required final String fileName,
  }) => '${keyPrefix}_$fileName';

  @override
  Future<({double aspectRatio, Uint8List imageBinary})?> getImageData({
    required String pathName,
    required String fileName,
  }) async {
    final data = await _spData.getImage(
      key: _getStorageKey(keyPrefix: pathName, fileName: fileName),
    );
    if (data != null) {
      final aspectRatio = await _getAspectRatio(data);
      return (imageBinary: data, aspectRatio: aspectRatio);
    }
    return null;
  }

  @override
  Future<Uint8List?> getMemeThumbnailBytesData({required String memeId}) async {
    return await _spData.getImage(
      key: _getStorageKey(
        keyPrefix: ImageTypeEnum.thumbnail.path,
        fileName: '$memeId.png',
      ),
    );
  }

  @override
  Future<bool> saveMemeThumbnailBytesData({
    required String memeId,
    required Uint8List thumbnailBinaryData,
  }) async {
    return await _spData.saveImage(
      key: _getStorageKey(
        keyPrefix: ImageTypeEnum.thumbnail.path,
        fileName: '$memeId.png',
      ),
      imageData: thumbnailBinaryData,
    );
  }

  @override
  Future<Uint8List?> getTemplatesBytesData({
    required String templateImageName,
    required String pathName,
  }) async {
    return await _spData.getImage(
      key: _getStorageKey(keyPrefix: pathName, fileName: templateImageName),
    );
  }

  @override
  Future<String?> saveTemplateToMemesImages({
    required String templateFileName,
    required String templatePath,
    required String memePath,
  }) async {
    await _spData.copyTemplateToMeme(
      templateKey: _getStorageKey(
        keyPrefix: templatePath,
        fileName: templateFileName,
      ),
      memeKey: _getStorageKey(keyPrefix: memePath, fileName: templateFileName),
    );
    return templateFileName;
  }

  @override
  Future<String> saveFileDataAndReturnItName({
    required String fileNewParentPath,
    required String fileFullName,
    required Uint8List fileBytesData,
  }) async {
    // TODO: check file on equality
    log('FILENAME: $fileFullName');
    String fileName = fileFullName.split('/').last;
    await _spData.saveImage(
      key: _getStorageKey(keyPrefix: fileNewParentPath, fileName: fileName),
      imageData: fileBytesData,
    );
    return fileName;
  }

  @override
  Future<bool> isImageExists({
    required String fileName,
    required String filePath,
  }) async {
    return await _spData.isImageExist(
      key: _getStorageKey(keyPrefix: filePath, fileName: fileName),
    );
  }

  @override
  Future<int> getCacheSize() async {
    return 0;
  }

  @override
  Future<void> clearCache() async {
  }
}
