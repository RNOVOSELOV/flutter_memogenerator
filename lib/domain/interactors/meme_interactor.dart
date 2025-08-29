import 'package:memogenerator/data/shared_pref/models/meme_model.dart';
import 'package:memogenerator/data/shared_pref/models/memes_model.dart';
import 'package:memogenerator/domain/interactors/copy_unique_file_interactor.dart';
import 'package:memogenerator/domain/interactors/screenshot_interactor.dart';
import 'package:screenshot/screenshot.dart';

import '../../data/shared_pref/repositories/memes/memes_repository.dart';
import '../entities/meme.dart';
import '../entities/text_with_position.dart';

class MemeInteractor {
  static const memesPathName = "memes";

  final MemesRepository _memeRepository;
  final CopyUniqueFileInteractor _copyUniqueFileInteractor;

  MemeInteractor({
    required MemesRepository memeRepository,
    required CopyUniqueFileInteractor copyUniqueFileInteractor,
  }) : _memeRepository = memeRepository,
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
    await ScreenshotInteractor.getInstance().saveThumbnail(
      id,
      screenshotController,
    );
    final newImagePath = await _copyUniqueFileInteractor
        .copyUniqueFile(directoryWithFiles: memesPathName, filePath: imagePath);
    return await _insertMemeOrReplaceById(
      meme: Meme(id: id, texts: textWithPositions, memePath: newImagePath),
    );
  }

  Future<bool> deleteMeme({required final String id}) async {
    final savedData = (await _memeRepository.getItem())?.memes ?? [];
    savedData.removeWhere((element) => element.id == id);
    return await _memeRepository.setItem(MemesModel(memes: savedData));
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
