import 'package:memogenerator/data/interactors/copy_unique_file_interactor.dart';
import 'package:memogenerator/data/interactors/screenshot_interactor.dart';
import 'package:screenshot/screenshot.dart';

import '../../domain/entities/meme.dart';
import '../../domain/entities/text_with_position.dart';
import '../shared_pref/dto/meme_model.dart';
import '../shared_pref/dto/memes_model.dart';
import '../shared_pref/datasources/memes/meme_datasource_impl.dart';

class MemeInteractor {
  static const memesPathName = "memes";

  final MemesDataSourceImpl _memeRepository;
  final CopyUniqueFileInteractor _copyUniqueFileInteractor;
  final ScreenshotInteractor _screenshotInteractor;

  MemeInteractor({
    required MemesDataSourceImpl memeRepository,
    required CopyUniqueFileInteractor copyUniqueFileInteractor,
    required ScreenshotInteractor screenshotInteractor,
  }) : _memeRepository = memeRepository,
       _screenshotInteractor = screenshotInteractor,
       _copyUniqueFileInteractor = copyUniqueFileInteractor;

  Future<bool> saveMeme({
    required final String id,
    required final List<TextWithPosition> textWithPositions,
    required final ScreenshotController screenshotController,
    final String? imagePath,
  }) async {
    if (imagePath == null) {
      return await _insertMemeOrReplaceById(
        meme: Meme(id: id, texts: textWithPositions),
      );
    }
    await _screenshotInteractor.saveThumbnail(id, screenshotController);
    final newImagePath = await _copyUniqueFileInteractor.copyUniqueFile(
      directoryWithFiles: memesPathName,
      filePath: imagePath,
    );
    return await _insertMemeOrReplaceById(
      meme: Meme(id: id, texts: textWithPositions, memePath: newImagePath),
    );
  }



  Future<bool> _insertMemeOrReplaceById({required final Meme meme}) async {
    final savedData = (await _memeRepository.getItem())?.memes ?? [];
    final itemIndex = savedData.indexWhere((item) => item.id == meme.id);
    if (itemIndex == -1) {
      savedData.add(MemeModel.fromMeme(meme: meme));
    } else {
      savedData[itemIndex] = MemeModel.fromMeme(meme: meme);
    }
    return await _memeRepository.setItem(MemesModel(memes: savedData));
  }
}
