import 'dart:io';

import 'package:memogenerator/data/models/meme.dart';
import 'package:memogenerator/data/models/text_with_position.dart';
import 'package:memogenerator/data/repositories/memes_repository.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class SaveMemeInteractor {
  static SaveMemeInteractor? _instance;

  SaveMemeInteractor._internal();

  factory SaveMemeInteractor.getInstance() =>
      _instance ??= SaveMemeInteractor._internal();

  Future<bool> saveMeme({
    required String id,
    required List<TextWithPosition> textWithPositions,
    String? imagePath,
  }) async {
    if (imagePath == null) {
      final meme = Meme(id: id, texts: textWithPositions);
      return MemesRepository.getInstance().addToMemes(meme);
    }
    final docsPath = await getApplicationDocumentsDirectory();
    final memePath = "${docsPath.absolute.path}${Platform.pathSeparator}memes";
    await Directory(memePath).create(recursive: true);

    final imageName = imagePath.split(Platform.pathSeparator).last;
    final newImagePath = "$memePath${Platform.pathSeparator}";

    String newImageFullFileName = "$newImagePath$imageName";
    final newImageFile = File(newImageFullFileName);
    final fileExist = await newImageFile.exists();
    // Открываем файл изображения, выбранный пользователем
    final tempFile = File(imagePath);

    if (!fileExist) {
      // Если файла с таким имененм в директории приложения нет, то создаем его
      await tempFile.copy(newImageFullFileName);
    } else {
      final tempImageFileStats = await tempFile.stat();
      final newImageFileStats = await newImageFile.stat();
      if (tempImageFileStats.size != newImageFileStats.size) {
        newImageFullFileName =
            await _generateImageFileName(newImagePath, imageName);
        await tempFile.copy(newImageFullFileName);
      }
    }
    final meme =
        Meme(id: id, texts: textWithPositions, memePath: newImageFullFileName);
    print("Saved: $newImageFullFileName");
    return MemesRepository.getInstance().addToMemes(meme);
  }

  Future<String> _generateImageFileName(
      String imagePath, String tempImageName) async {
    // Проверяем существует ли уже файл с таким именем в директории приложения
    final newImageFullFileName = "$imagePath$tempImageName";
    final newImageFile = File(newImageFullFileName);
    final fileExist = await newImageFile.exists();
    if (!fileExist) {
      return newImageFullFileName;
    }
    final splitDotList = tempImageName.split('.');
    if (splitDotList.length <= 1) {
      // Возвращаем случайное имя файла, на всякий случай, так как у текущего имени нет разрешения
      return "$imagePath${const Uuid().v4()}";
    }
    // Удаляем разрешение из имени файла и храним его в переменной
    final fileExtension = splitDotList.removeLast();
    final getFileNumberList = splitDotList.join('.').split('_');
    if (getFileNumberList.length <= 1) {
      return "$imagePath${splitDotList.join('.')}_1.$fileExtension";
    }

    int? numberValue = int.tryParse(getFileNumberList.removeLast());
    if (numberValue == null) {
      return "$imagePath${const Uuid().v4()}.$fileExtension";
    }
    return await _generateImageFileName(
        imagePath, "${getFileNumberList.join('_')}_${numberValue + 1}.$fileExtension");
  }
}
