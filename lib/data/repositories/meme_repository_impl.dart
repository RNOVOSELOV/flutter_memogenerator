
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:memogenerator/data/datasources/meme_datasource.dart';
import 'package:memogenerator/domain/entities/meme_thumbnail.dart';
import 'package:memogenerator/domain/repositories/meme_repository.dart';
import '../../domain/entities/meme.dart';
import '../datasources/images_datasource.dart';

class MemeRepositoryImp implements MemeRepository {
  final MemeDatasource _memeDataSource;
  final ImagesDatasource _imagesDatasource;

  static const _memesPathName = "memes";

  MemeRepositoryImp({
    required MemeDatasource memeDatasource,
    required ImagesDatasource imageDatasource,
  }) : _memeDataSource = memeDatasource,
       _imagesDatasource = imageDatasource;

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

    // TODO Обновить мемы в списке, использовать функцию combineLatest3, где в терий стрим клаcть например null
    // TODO для перегенерации всей комбинации
    // return Rx.combineLatest2<List<Meme>, Directory, List<MemeThumbnail>>(
    //   _memeDataSourceImpl.observeItem().map(
    //     (memeModels) => memeModels == null
    //         ? []
    //         : memeModels.memes.map((memeModel) => memeModel.meme).toList(),
    //   ),
    //   getApplicationDocumentsDirectory().asStream(),
    //   (memes, docDirectory) {
    //     return memes.map((meme) {
    //       final fullImagePath =
    //           "${docDirectory.absolute.path}${Platform.pathSeparator}${meme.id}.png";
    //       return MemeThumbnail(memeId: meme.id, imageBytes: fullImagePath);
    //     }).toList();
    //   },
    // );
  }

  @override
  void updateMemesThumbnails() {
    // TODO: implement updateMemesThumbnails
    // TODO Обновить мемы в списке, использовать функцию combineLatest3, где в терий стрим клаcть например null
    // TODO для перегенерации всей комбинации
  }


  @override
  Future<String> uploadMemeFile({required String fileFullName, required Uint8List fileBinaryData}) async {
    final newFileName = await _imagesDatasource.saveFileDataAndReturnItName(
      directoryWithFiles: _memesPathName,
      filePath: fileFullName,
      fileBytesData: fileBinaryData,
    );
    return newFileName;
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
}
