import 'package:flutter/foundation.dart';

abstract interface class ImagesDatasource {
  /// Получение изображения готового мема в виде бинарных данных типа [Uint8List]
  /// для отображения на странице созданных мемов
  Future<Uint8List?> getMemeThumbnailBytesData({required final String memeId});

  /// Сохранение скомпилированного мема в виде изображения
  /// [memeId] - идентификатор мема
  /// [thumbnailBinaryData] - изображение в виде бинарных данных типа [Uint8List]
  Future<bool> saveMemeThumbnailBytesData({
    required String memeId,
    required Uint8List thumbnailBinaryData,
  });

  /// Метод возвращает изображение шаблона в виде бинарных данных типа [Uint8List]
  /// [pathName] - харамтеристика метоположения файла
  /// [templateImageName] - имя файла
  Future<Uint8List?> getTemplatesBytesData({
    required final String templateImageName,
    required final String pathName,
  });

  /// Метод проверяет наличие изображения
  /// [filePath] - харамтеристика метоположения файла
  /// [fileName] - имя файла
  Future<bool> isImageExists({
    required final String fileName,
    required final String filePath,
  });

  Future<String> saveFileDataAndReturnItName({
    required final String fileNewParentPath,
    required final String fileFullName,
    required final Uint8List fileBytesData,
  });

  /// Метод сохраняет шаблон в мемы
  /// [templatePath] - характеристика местоположения шаблонов
  /// [memePath] - характеристика местоположения мемов
  /// [templateFileName] - имя файла шаблона
  Future<String?> saveTemplateToMemesImages({
    required final String templateFileName,
    required final String templatePath,
    required final String memePath,
  });

  /// Метод получения информации об изображении
  /// [pathName] - харамтеристика метоположения файла
  /// [fileName] - имя файла
  ///
  /// Метод возвращает [Record] c бинарными данными изображения и его соотношением сторон
  Future<({Uint8List imageBinary, double aspectRatio})?> getImageData({
    required String pathName,
    required String fileName,
  });
}
