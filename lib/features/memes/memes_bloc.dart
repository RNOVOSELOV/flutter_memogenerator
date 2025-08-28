import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:memogenerator/data/shared_pref/repositories/templates/templates_repository.dart';
import 'package:memogenerator/data/shared_pref/shared_preference_data.dart';
import 'package:memogenerator/domain/interactors/meme_interactor.dart';
import 'package:memogenerator/domain/interactors/template_interactor.dart';
import 'package:memogenerator/features/memes/domain/models/meme_thumbnail.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';

import '../../data/shared_pref/repositories/memes/memes_repository.dart';
import '../../domain/entities/meme.dart';

class MemesBloc {
  final MemesRepository _memeRepository;



  MemesBloc({
    required MemesRepository memeRepository,
  }) : _memeRepository = memeRepository;

  Stream<List<MemeThumbnail>>
  observeMemes() => Rx.combineLatest2<List<Meme>, Directory, List<MemeThumbnail>>(
    _memeRepository.observeItem().map(
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
    // TODO
    final interactor = SaveTemplateInteractor(
      templateRepository: TemplatesRepository(
        templateDataProvider: SharedPreferenceData(),
      ),
    );
    final xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    final imagePath = xFile?.path;
    if (imagePath != null) {
      await interactor.saveTemplate(imagePath: imagePath);
    }
    return imagePath;
  }

  Future<void> addTemplate() async {
    // TODO
    final interactor = SaveTemplateInteractor(
      templateRepository: TemplatesRepository(
        templateDataProvider: SharedPreferenceData(),
      ),
    );
    final xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    final imagePath = xFile?.path;
    if (imagePath != null) {
      await interactor.saveTemplate(imagePath: imagePath);
    }
  }

  void deleteMeme(final String memeId) {
    // TODO
    final interactor = SaveMemeInteractor(
      memeRepository: MemesRepository(memeDataProvider: SharedPreferenceData()),
    );
    interactor.deleteMeme(id: memeId);
  }

  void deleteTemplate(final String templateId) {
    // TODO
    final interactor = SaveTemplateInteractor(
      templateRepository: TemplatesRepository(
        templateDataProvider: SharedPreferenceData(),
      ),
    );
    interactor.deleteTemplate(id: templateId);
  }

  void dispose() {
  }
}
