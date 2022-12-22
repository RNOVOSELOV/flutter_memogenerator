import 'package:memogenerator/data/models/meme.dart';
import 'package:memogenerator/data/models/text_with_position.dart';
import 'package:memogenerator/data/repositories/memes_repository.dart';
import 'package:memogenerator/domain/interactors/copy_unique_file_interactor.dart';
import 'package:memogenerator/domain/interactors/screenshot_interactor.dart';
import 'package:screenshot/screenshot.dart';

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
      return MemesRepository.getInstance().addItemOrReplaceById(meme);
    }
    await ScreenshotInteractor.getInstance()
        .saveThumbnail(id, screenshotController);
    final newImagePath =
        await CopyUniqueFileInteractor.getInstance().copyUniqueFile(
      directoryWithFiles: memesPathName,
      filePath: imagePath,
    );

    final meme = Meme(
      id: id,
      texts: textWithPositions,
      memePath: newImagePath,
    );
    return MemesRepository.getInstance().addItemOrReplaceById(meme);
  }
}
