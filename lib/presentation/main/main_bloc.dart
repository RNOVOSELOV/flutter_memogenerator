import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:memogenerator/data/sp/models/template_model.dart';
import 'package:memogenerator/data/sp/repositories/templates/templates_repository.dart';
import 'package:memogenerator/data/sp/shared_preference_data.dart';
import 'package:memogenerator/domain/entities/template.dart';
import 'package:memogenerator/domain/interactors/meme_interactor.dart';
import 'package:memogenerator/domain/interactors/template_interactor.dart';
import 'package:memogenerator/presentation/main/models/meme_thumbnail.dart';
import 'package:memogenerator/presentation/main/models/template_full.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';

import '../../data/sp/repositories/memes/meme_repository.dart';
import '../../domain/entities/meme.dart';

class MainBloc {
  final MemeRepository _memeRepository;
  final TemplatesRepository _templatesRepository;

  MainBloc({
    required MemeRepository memeRepository,
    required TemplatesRepository templatesRepository,
  }) : _memeRepository = memeRepository,
       _templatesRepository = templatesRepository;

  // Stream<MemesWithDocsPath> observeMemesWithDocsPath() =>
  //     Rx.combineLatest2<List<Meme>, Directory, MemesWithDocsPath>(
  //         MemesRepository.getInstance().observeMemes(),
  //         getApplicationDocumentsDirectory().asStream(),
  //         (memes, docDirectory) =>
  //             MemesWithDocsPath(memes, docDirectory.absolute.path));

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

  Stream<List<TemplateFull>> observeTemplates() =>
      Rx.combineLatest2<List<Template>, Directory, List<TemplateFull>>(
        _templatesRepository.observeItem().map(
          (templateModels) => templateModels == null
              ? []
              : templateModels.templates
                    .map((templateModel) => templateModel.template)
                    .toList(),
        ),
        getApplicationDocumentsDirectory().asStream(),
        (templates, docDirectory) {
          return templates.map((template) {
            final fullImagePath =
                "${docDirectory.absolute.path}${Platform.pathSeparator}${SaveTemplateInteractor.templatesPathName}${Platform.pathSeparator}${template.imageUrl}";
            return TemplateFull(id: template.id, fullImagePath: fullImagePath);
          }).toList();
        },
      );

  Future<String?> selectMeme() async {
    // TODO
    final interactor = SaveTemplateInteractor(
      templateRepository: TemplatesRepository(
        memeDataProvider: SharedPreferenceData(),
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
        memeDataProvider: SharedPreferenceData(),
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
      memeRepository: MemeRepository(memeDataProvider: SharedPreferenceData()),
    );
    interactor.deleteMeme(id: memeId);
  }

  void deleteTemplate(final String templateId) {
    // TODO
    final interactor = SaveTemplateInteractor(
      templateRepository: TemplatesRepository(
        memeDataProvider: SharedPreferenceData(),
      ),
    );
    interactor.deleteTemplate(id: templateId);
  }

  void dispose() {}
}
