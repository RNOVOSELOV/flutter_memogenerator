import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:memogenerator/data/datasources/meme_datasource.dart';
import 'package:memogenerator/data/image_type_enum.dart';
import 'package:memogenerator/data/repositories/image_saver.dart';
import 'package:memogenerator/domain/entities/meme_thumbnail.dart';
import 'package:memogenerator/domain/repositories/meme_repository.dart';
import '../../domain/entities/meme.dart';
import '../datasources/images_datasource.dart';
import '../shared_pref/dto/meme_model.dart';

class MemeRepositoryImp implements MemeRepository {
  final MemeDatasource _memeDataSource;
  final ImagesDatasource _imagesDatasource;

  final String memesPathName;

  MemeRepositoryImp({
    required MemeDatasource memeDatasource,
    required ImagesDatasource imageDatasource,
  }) : _memeDataSource = memeDatasource,
       _imagesDatasource = imageDatasource,
       memesPathName = ImageTypeEnum.meme.path;

  @override
  Stream<List<MemeThumbnail>> observeMemesThumbnails() {
    return _memeDataSource
        .observeMemesList()
        .map((models) => models.map((model) => model.meme))
        .asyncMap((memes) async {
          final thumbnails = <MemeThumbnail>[];
          for (Meme meme in memes) {
            final bt = await _imagesDatasource.getMemeThumbnailBytesData(
              memeId: meme.id,
            );
            final th = MemeThumbnail(memeId: meme.id, imageBytes: bt);
            thumbnails.add(th);
          }
          return thumbnails;
        });
  }

  @override
  Future<bool> saveThumbnail({
    required String memeId,
    required Uint8List thumbnailBinaryData,
  }) async {
    return await _imagesDatasource.saveMemeThumbnailBytesData(
      memeId: memeId,
      thumbnailBinaryData: thumbnailBinaryData,
    );
  }

  @override
  Future<bool> deleteMeme({required final String memeId}) async {
    final savedData = await _memeDataSource.getMemeModels();
    savedData.removeWhere((element) => element.id == memeId);
    return await _memeDataSource.setMemeModels(models: savedData);
  }

  @override
  Future<Meme?> getMeme({required String id}) async {
    return (await _memeDataSource.getMemeModels())
        .firstWhereOrNull((model) => model.id == id)
        ?.meme;
  }

  @override
  Future<String> uploadMemeFile({
    required String fileFullName,
    required Uint8List fileBinaryData,
  }) async {
    final newFileName = await _imagesDatasource.saveFileDataAndReturnItName(
      fileNewParentPath: memesPathName,
      fileFullName: fileFullName,
      fileBytesData: fileBinaryData,
    );
    return newFileName;
  }

  @override
  Future<({Uint8List imageBinary, double aspectRatio})?> getImageBinaryData({
    required String fileName,
  }) async {
    return await _imagesDatasource.getImageData(
      pathName: memesPathName,
      fileName: fileName,
    );
  }

  @override
  Future<bool> saveMeme({required final Meme meme}) async {
    return await _insertMemeOrReplaceById(meme: meme);
  }

  Future<bool> _insertMemeOrReplaceById({required Meme meme}) async {
    final savedData = await _memeDataSource.getMemeModels();
    final itemIndex = savedData.indexWhere((item) => item.id == meme.id);
    if (itemIndex == -1) {
      savedData.add(MemeModel.fromMeme(meme: meme));
    } else {
      savedData[itemIndex] = MemeModel.fromMeme(meme: meme);
    }
    return await _memeDataSource.setMemeModels(models: savedData);
  }

  @override
  Future<bool> saveImageToGallery({required Uint8List binaryData}) async {
    final result = await UniversalImageSaver.saveImage(
      binaryData,
      fileName: 'meme_${DateTime.now().millisecondsSinceEpoch}',
      format: 'png',
    );
    return result != null;
  }
}
