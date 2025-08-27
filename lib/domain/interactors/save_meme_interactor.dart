import 'package:memogenerator/data/sp/models/meme_model.dart';
import 'package:memogenerator/data/sp/models/position_model.dart';
import 'package:memogenerator/data/sp/models/text_with_position_model.dart';
import 'package:memogenerator/domain/interactors/copy_unique_file_interactor.dart';
import 'package:memogenerator/domain/interactors/screenshot_interactor.dart';
import 'package:screenshot/screenshot.dart';

import '../../data/sp/repositories/memes/memes_repository.dart';
import '../entities/meme.dart';
import '../entities/text_with_position.dart';

class SaveMemeInteractor {
  static const memesPathName = "memes";
  static SaveMemeInteractor? _instance;

  SaveMemeInteractor._internal();

  factory SaveMemeInteractor.getInstance() =>
      _instance ??= SaveMemeInteractor._internal();

  Future<bool> saveMeme({
    required final String id,
    required final List<TextWithPosition> textWithPositions,
    required final ScreenshotController screenshotController,
    final String? imagePath,
  }) async {
    if (imagePath == null) {
      final meme = Meme(id: id, texts: textWithPositions);
      return MemesRepository.getInstance().addItemOrReplaceById(
        MemeModel.fromMeme(meme: meme),
      );
    }
    await ScreenshotInteractor.getInstance().saveThumbnail(
      id,
      screenshotController,
    );
    final newImagePath = await CopyUniqueFileInteractor.getInstance()
        .copyUniqueFile(directoryWithFiles: memesPathName, filePath: imagePath);

    final meme = Meme(id: id, texts: textWithPositions, memePath: newImagePath);
    return MemesRepository.getInstance().addItemOrReplaceById(
      MemeModel.fromMeme(meme: meme),
    );
  }
}
