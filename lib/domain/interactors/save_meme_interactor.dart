import 'dart:io';
import 'package:collection/collection.dart';
import 'package:memogenerator/data/models/meme.dart';
import 'package:memogenerator/data/models/text_with_position.dart';
import 'package:memogenerator/data/repositories/memes_repository.dart';
import 'package:path_provider/path_provider.dart';

class SaveMemeInteractor {
  static const memesPathName = "memes";
  static SaveMemeInteractor? _instance;

  SaveMemeInteractor._internal();

  factory SaveMemeInteractor.getInstance() =>
      _instance ??= SaveMemeInteractor._internal();

  Future<bool> saveMeme({
    required final String id,
    required final List<TextWithPosition> textWithPositions,
    final String? imagePath,
  }) async {
    if (imagePath == null) {
      final meme = Meme(id: id, texts: textWithPositions);
      return MemesRepository.getInstance().addToMemes(meme);
    }

    await createNewFile(imagePath);

    final meme = Meme(id: id, texts: textWithPositions, memePath: imagePath);
    return MemesRepository.getInstance().addToMemes(meme);
  }

  Future<void> createNewFile(final String imagePath) async {
    final docsPath = await getApplicationDocumentsDirectory();
    final memePath =
        "${docsPath.absolute.path}${Platform.pathSeparator}$memesPathName";
    final memesDirectory = Directory(memePath);
    await memesDirectory.create(recursive: true);

    final currentFiles = memesDirectory.listSync();

    final imageName = _getFileNameByPath(imagePath);
    final oldFileWithTheSameName = currentFiles.firstWhereOrNull(
      (element) {
        return _getFileNameByPath(element.path) == imageName && element is File;
      },
    );

    final newImagePath = "$memePath${Platform.pathSeparator}$imageName";
    final tempFile = File(imagePath);
    if (oldFileWithTheSameName == null) {
      await tempFile.copy(newImagePath);
      return;
    }
    final oldFileLength = await (oldFileWithTheSameName as File).length();
    final newFileLength = await tempFile.length();
    if (oldFileLength == newFileLength) {
      return;
    }
    return _createFileForTheSameNameButDifferentLength(
      imageName: imageName,
      tempFile: tempFile,
      newImagePath: newImagePath,
      memePath: memePath,
    );
  }

  Future<void> _createFileForTheSameNameButDifferentLength({
    required final String imageName,
    required final File tempFile,
    required final String newImagePath,
    required final String memePath,
  }) async {
    final indexOfLastDot = imageName.lastIndexOf(".");
    if (indexOfLastDot == -1) {
      await tempFile.copy(newImagePath);
      return;
    }

    final extension = imageName.substring(indexOfLastDot);
    final imageNameWithoutExtension = imageName.substring(0, indexOfLastDot);
    final indexOfLastUnderscore = imageNameWithoutExtension.lastIndexOf("_");
    if (indexOfLastUnderscore == -1) {
      final correctedNewImagePath =
          "$memePath${Platform.pathSeparator}${imageNameWithoutExtension}_1$extension";
      await tempFile.copy(correctedNewImagePath);
      return;
    }

    final suffixNumberString =
        imageNameWithoutExtension.substring(indexOfLastUnderscore + 1);
    final suffixNumber = int.tryParse(suffixNumberString);
    if (suffixNumber == null) {
      final correctedNewImagePath =
          "$memePath${Platform.pathSeparator}${imageNameWithoutExtension}_1$extension";
      await tempFile.copy(correctedNewImagePath);
    } else {
      final imageNameWithoutSuffix =
          imageNameWithoutExtension.substring(0, indexOfLastUnderscore);
      final correctedNewImagePath =
          "$memePath${Platform.pathSeparator}${imageNameWithoutSuffix}_${suffixNumber + 1}$extension";
      await tempFile.copy(correctedNewImagePath);
    }
  }

  String _getFileNameByPath(String imagePath) =>
      imagePath.split(Platform.pathSeparator).last;

/*
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
      print("_generateImageFileName tryParce ERROR");
      return "$imagePath${const Uuid().v4()}.$fileExtension";
    }
    return await _generateImageFileName(imagePath,
        "${getFileNumberList.join('_')}_${numberValue + 1}.$fileExtension");
  }
*/
}
