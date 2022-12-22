import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:memogenerator/data/models/meme.dart';
import 'package:memogenerator/data/models/template.dart';
import 'package:memogenerator/data/repositories/memes_repository.dart';
import 'package:memogenerator/data/repositories/templates_repository.dart';
import 'package:memogenerator/domain/interactors/save_template_interactor.dart';
import 'package:memogenerator/presentation/main/models/meme_thumbnail.dart';
import 'package:memogenerator/presentation/main/models/template_full.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';

class MainBloc {
  // Stream<MemesWithDocsPath> observeMemesWithDocsPath() =>
  //     Rx.combineLatest2<List<Meme>, Directory, MemesWithDocsPath>(
  //         MemesRepository.getInstance().observeMemes(),
  //         getApplicationDocumentsDirectory().asStream(),
  //         (memes, docDirectory) =>
  //             MemesWithDocsPath(memes, docDirectory.absolute.path));

  Stream<List<MemeThumbnail>> observeMemes() =>
      Rx.combineLatest2<List<Meme>, Directory, List<MemeThumbnail>>(
          MemesRepository.getInstance().observeMemes(),
          getApplicationDocumentsDirectory().asStream(), (memes, docDirectory) {
        return memes.map((meme) {
          final fullImagePath =
              "${docDirectory.absolute.path}${Platform.pathSeparator}${meme.id}.png";
          return MemeThumbnail(memeId: meme.id, fullImageUrl: fullImagePath);
        }).toList();
      });

  Stream<List<TemplateFull>> observeTemplates() =>
      Rx.combineLatest2<List<Template>, Directory, List<TemplateFull>>(
          TemplatesRepository.getInstance().observeTemplates(),
          getApplicationDocumentsDirectory().asStream(),
          (templates, docDirectory) {
        return templates.map((template) {
          final fullImagePath =
              "${docDirectory.absolute.path}${Platform.pathSeparator}${SaveTemplateInteractor.templatesPathName}${Platform.pathSeparator}${template.imageUrl}";
          return TemplateFull(
            id: template.id,
            fullImagePath: fullImagePath,
          );
        }).toList();
      });

  Future<String?> selectMeme() async {
    final xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    final imagePath = xFile?.path;
    if (imagePath != null) {
      await SaveTemplateInteractor.getInstance()
          .saveTemplate(imagePath: imagePath);
    }
    return imagePath;
  }

  Future<void> addTemplate() async {
    final xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    final imagePath = xFile?.path;
    if (imagePath != null) {
      await SaveTemplateInteractor.getInstance()
          .saveTemplate(imagePath: imagePath);
    }
  }

  void deleteMeme(final String memeId) {
    MemesRepository.getInstance().removeFromMemes(memeId);
  }

  void deleteTemplate(final String templateId) {
    TemplatesRepository.getInstance().removeFromTemplates(templateId);
  }

  void dispose() {}
}
