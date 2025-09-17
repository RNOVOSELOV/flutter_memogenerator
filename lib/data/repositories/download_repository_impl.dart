import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:either_dart/either.dart';
import 'package:memogenerator/data/datasources/api_datasource.dart';
import 'package:memogenerator/data/datasources/template_datasource.dart';
import 'package:memogenerator/data/http/models/api_error.dart';
import 'package:memogenerator/data/http/models/meme_data.dart';
import 'package:memogenerator/domain/entities/message.dart';
import 'package:memogenerator/domain/entities/template_full.dart';
import 'package:memogenerator/domain/repositories/download_repository.dart';
import 'package:memogenerator/domain/repositories/templates_repository.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/message_status.dart';
import '../../domain/entities/template.dart';
import '../datasources/images_datasource.dart';
import '../image_type_enum.dart';
import '../shared_pref/dto/template_model.dart';

class DownloadRepositoryImp implements DownloadRepository {
  final TemplateDatasource _templateDatasource;
  final ImagesDatasource _imagesDatasource;

  final TemplatesRepository _templatesRepository;
  final ApiDatasource _apiDatasource;
  final String _templatesPathName;

  DownloadRepositoryImp({
    required TemplateDatasource templateDatasource,
    required ImagesDatasource imageDatasource,
    required TemplatesRepository templatesRepository,
    required ApiDatasource apiDatasource,
  }) : _templateDatasource = templateDatasource,
       _imagesDatasource = imageDatasource,
       _apiDatasource = apiDatasource,
       _templatesRepository = templatesRepository,
       _templatesPathName = ImageTypeEnum.template.path;

  @override
  Future<Either<ApiError, List<MemeApiData>>> getMemeTemplates() =>
      _apiDatasource.getMemeTemplates();

  @override
  Future<Message> downloadTemplate({required MemeApiData memeData}) async {
    if (!await _imagesDatasource.isImageExists(
      fileName: memeData.fileName,
      filePath: _templatesPathName,
    )) {
      final downloadTemplatesResult = await _apiDatasource.downloadTemplate(
        url: memeData.url,
      );
      if (downloadTemplatesResult.isLeft) {
        return Message(
          status: MessageStatus.error,
          message: 'Ошибка загрузки шаблона "${memeData.name}".',
        );
      }
      final savingResult = await _templatesRepository.saveTemplate(
        fileBytes: downloadTemplatesResult.right,
        fileName: memeData.fileName,
      );
      if (!savingResult) {
        return Message(
          status: MessageStatus.error,
          message: 'Ошибка загрузки шаблона "${memeData.name}".',
        );
      }
    } else {
      if (await _templateDatasource.isTemplateContains(
        fileName: memeData.fileName,
      )) {
        return Message(
          status: MessageStatus.error,
          message:
              'Загрузка не требуется. Шаблон "${memeData.name}" уже сохранен в галерее.',
        );
      }
      await _templatesRepository.insertTemplateOrReplaceById(
        template: Template(id: Uuid().v4(), imageName: memeData.fileName),
      );
    }
    return Message(
      status: MessageStatus.success,
      message: 'Шаблон "${memeData.name}" успешно загружен и сохранен.',
    );
  }
}
