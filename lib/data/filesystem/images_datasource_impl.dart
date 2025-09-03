import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:path_provider/path_provider.dart';

import '../datasources/images_datasource.dart';

class FileSystemDatasource implements ImagesDatasource {
  String documentDirectoryPath = '';

  FileSystemDatasource();

  Future<String> _getDocumentsDirectory() async {
    if (documentDirectoryPath.isNotEmpty) {
      return documentDirectoryPath;
    }
    final documentsDirectory = await getApplicationDocumentsDirectory();
    documentDirectoryPath =
        '${documentsDirectory.absolute.path}${Platform.pathSeparator}';
    return documentDirectoryPath;
  }

  String _getFileNameByPath(String imagePath) =>
      imagePath.split(Platform.pathSeparator).last;

  Future<void> _saveToFile({
    required final Uint8List bytes,
    required final String filePath,
  }) async {
    final file = File(filePath);
    await file.writeAsBytes(bytes, flush: true);
  }

  @override
  Future<Uint8List?> getMemeThumbnailBytesData({required String memeId}) async {
    final docDirectory = await _getDocumentsDirectory();
    final file = File('$docDirectory$memeId.png');
    if (await file.exists()) {
      return await file.readAsBytes();
    }
    return null;
  }

  @override
  Future<String> saveFileDataAndReturnItName({
    required final String directoryWithFiles,
    required final String filePath,
    required final Uint8List fileBytesData,
  }) async {
    final docsPath = await _getDocumentsDirectory();
    final directoryForImages = "$docsPath$directoryWithFiles";
    final filesDirectory = Directory(directoryForImages);
    await filesDirectory.create(recursive: true);
    final currentFiles = filesDirectory.listSync();

    final imageName = _getFileNameByPath(filePath);
    final oldFileWithTheSameName = currentFiles.firstWhereOrNull((element) {
      return _getFileNameByPath(element.path) == imageName && element is File;
    });
    final newImagePath =
        "$directoryForImages${Platform.pathSeparator}$imageName";

    // Файлов с таким названием нет, сохраняем файл в документы/directoryWithFiles
    if (oldFileWithTheSameName == null) {
      await _saveToFile(bytes: fileBytesData, filePath: newImagePath);
      return imageName;
    }
    log('!!! FILENAME: $filePath');
    final tempFile = File(filePath);
    final oldFileLength = await (oldFileWithTheSameName as File).length();
    final newFileLength = await tempFile.length();
    // такой файл уже существует, не сохраняем его заново
    if (oldFileLength == newFileLength) {
      return imageName;
    }

    final indexOfLastDot = imageName.lastIndexOf(".");
    // У файла нет расширения, странно. Сохраняем файл в документы
    if (indexOfLastDot == -1) {
      await _saveToFile(bytes: fileBytesData, filePath: newImagePath);
      return imageName;
    }
    final extension = imageName.substring(indexOfLastDot);
    final imageNameWithoutExtension = imageName.substring(0, indexOfLastDot);
    final indexOfLastUnderscore = imageNameWithoutExtension.lastIndexOf("_");
    // Файл с таким названием, но другим размером есть. Создаем новый файл с суффиксом _1
    if (indexOfLastUnderscore == -1) {
      final newImageName = "${imageNameWithoutExtension}_1$extension";
      final correctedNewImagePath =
          "$directoryForImages${Platform.pathSeparator}$newImageName";
      await _saveToFile(bytes: fileBytesData, filePath: correctedNewImagePath);
      return newImageName;
    }

    final suffixNumberString = imageNameWithoutExtension.substring(
      indexOfLastUnderscore + 1,
    );
    final suffixNumber = int.tryParse(suffixNumberString);
    // Если подчеркивание было в файле, но цифра после нее не распознана. Создаем новый файл с суффиксом _1
    if (suffixNumber == null) {
      final newImageName = "${imageNameWithoutExtension}_1$extension";
      final correctedNewImagePath =
          "$directoryForImages${Platform.pathSeparator}$newImageName";
      await _saveToFile(bytes: fileBytesData, filePath: correctedNewImagePath);
      return newImageName;
    }
    // Если подчеркивание было в файле и число распознано, увеличиваем суффикс и сохраняем в документы.
    final imageNameWithoutSuffix = imageNameWithoutExtension.substring(
      0,
      indexOfLastUnderscore,
    );
    final newFileImageName =
        "${imageNameWithoutSuffix}_${suffixNumber + 1}$extension";
    final correctedNewImagePath =
        "$directoryForImages${Platform.pathSeparator}$newFileImageName";
    await _saveToFile(bytes: fileBytesData, filePath: correctedNewImagePath);
    return newFileImageName;
  }
}
