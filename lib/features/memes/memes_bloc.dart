import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:memogenerator/domain/interactors/meme_interactor.dart';
import 'package:memogenerator/domain/interactors/template_interactor.dart';
import 'package:memogenerator/features/memes/domain/models/meme_thumbnail.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';

import '../../data/shared_pref/repositories/memes/memes_repository.dart';
import '../../domain/entities/meme.dart';

class MemesBloc {
  final MemesRepository _memesRepository;
  final MemeInteractor _memeInteractor;
  final TemplateInteractor _templateInteractor;

  MemesBloc({
    required MemesRepository memeRepository,
    required MemeInteractor memeInteractor,
    required TemplateInteractor templateInteractor,
  }) : _memesRepository = memeRepository,
       _memeInteractor = memeInteractor,
       _templateInteractor = templateInteractor;

  // TODO Обновить мемы в списке, использовать функцию combineLatest3, где в терий стрим клаcть например null
  // TODO для перегенерации всей комбинации
  Stream<List<MemeThumbnail>>
  observeMemes() => Rx.combineLatest2<List<Meme>, Directory, List<MemeThumbnail>>(
    _memesRepository.observeItem().map(
      (memeModels) => memeModels == null
          ? []
          : memeModels.memes.map((memeModel) => memeModel.meme).toList(),
    ),
    getApplicationDocumentsDirectory().asStream(),
    (memes, docDirectory) {
      return memes.map((meme) {
        final fullImagePath =
            "${docDirectory.absolute.path}${Platform.pathSeparator}${meme.id}.png";
        return MemeThumbnail(memeId: meme.id, fullImageUrl: fullImagePath);
      }).toList();
    },
  );

  Future<String?> selectMeme() async {
    final xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    final imagePath = xFile?.path;
    if (imagePath != null) {
      await _templateInteractor.saveTemplate(imagePath: imagePath);
    }
    return imagePath;
  }

  void deleteMeme(final String memeId) {
    _memeInteractor.deleteMeme(id: memeId);
  }

  void dispose() {}
}
