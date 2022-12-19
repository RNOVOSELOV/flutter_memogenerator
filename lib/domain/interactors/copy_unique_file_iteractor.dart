import 'dart:io';
import 'package:collection/collection.dart';
import 'package:path_provider/path_provider.dart';

class CopyUniqueFileInteractor {
  static CopyUniqueFileInteractor? _instance;

  factory CopyUniqueFileInteractor.getInstance() =>
      _instance ??= CopyUniqueFileInteractor._internal();

  CopyUniqueFileInteractor._internal();

  Future<String> copyUniqueFile({
    required final String directoryWithFiles,
    required final String filePath,
  }) async {
    final docsPath = await getApplicationDocumentsDirectory();
    final memePath =
        "${docsPath.absolute.path}${Platform.pathSeparator}$directoryWithFiles";
    final memesDirectory = Directory(memePath);
    await memesDirectory.create(recursive: true);

    final currentFiles = memesDirectory.listSync();

    final imageName = _getFileNameByPath(filePath);
    final oldFileWithTheSameName = currentFiles.firstWhereOrNull(
      (element) {
        return _getFileNameByPath(element.path) == imageName && element is File;
      },
    );

    final newImagePath = "$memePath${Platform.pathSeparator}$imageName";
    final tempFile = File(filePath);
    // Файлов с таким названием нет, сохраняем файл в документы
    if (oldFileWithTheSameName == null) {
      await tempFile.copy(newImagePath);
      return imageName;
    }
    final oldFileLength = await (oldFileWithTheSameName as File).length();
    final newFileLength = await tempFile.length();
    // такой файл уже существует, не сохраняем его заново
    if (oldFileLength == newFileLength) {
      return imageName;
    }

    final indexOfLastDot = imageName.lastIndexOf(".");
    // У файла нет расширения, странно. Сохраняем файл в документы
    if (indexOfLastDot == -1) {
      await tempFile.copy(newImagePath);
      return imageName;
    }
    final extension = imageName.substring(indexOfLastDot);
    final imageNameWithoutExtension = imageName.substring(0, indexOfLastDot);
    final indexOfLastUnderscore = imageNameWithoutExtension.lastIndexOf("_");
    // Файл с таким названием, но другим размером есть. Создаем новый файл с суффиксом _1
    if (indexOfLastUnderscore == -1) {
      final newImageName = "${imageNameWithoutExtension}_1$extension";
      final correctedNewImagePath =
          "$memePath${Platform.pathSeparator}$newImageName";
      await tempFile.copy(correctedNewImagePath);
      return newImageName;
    }

    final suffixNumberString =
        imageNameWithoutExtension.substring(indexOfLastUnderscore + 1);
    final suffixNumber = int.tryParse(suffixNumberString);
    // Если подчеркивание было в файле, но цифра после нее не распознана. Создаем новый файл с суффиксом _1
    if (suffixNumber == null) {
      final newImageName = "${imageNameWithoutExtension}_1$extension";
      final correctedNewImagePath =
          "$memePath${Platform.pathSeparator}$newImageName";
      await tempFile.copy(correctedNewImagePath);
      return newImageName;
    }
    // Если подчеркивание было в файле и число распознано, увеличиваем суффикс и сохраняем в документы.
    final imageNameWithoutSuffix =
        imageNameWithoutExtension.substring(0, indexOfLastUnderscore);
    final newFileImageName =
        "${imageNameWithoutSuffix}_${suffixNumber + 1}$extension";
    final correctedNewImagePath =
        "$memePath${Platform.pathSeparator}$newFileImageName";
    await tempFile.copy(correctedNewImagePath);
    return newFileImageName;
  }

  String _getFileNameByPath(String imagePath) =>
      imagePath.split(Platform.pathSeparator).last;
}
