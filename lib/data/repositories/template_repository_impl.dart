import 'dart:developer';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:either_dart/either.dart';
import 'package:memogenerator/data/datasources/api_datasource.dart';
import 'package:memogenerator/data/datasources/template_datasource.dart';
import 'package:memogenerator/data/http/models/api_error.dart';
import 'package:memogenerator/data/http/models/meme_data.dart';
import 'package:memogenerator/data/repositories/meme_repository_impl.dart';
import 'package:memogenerator/domain/entities/message.dart';
import 'package:memogenerator/domain/entities/template_full.dart';
import 'package:memogenerator/domain/repositories/templates_repository.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/message_status.dart';
import '../../domain/entities/template.dart';
import '../datasources/images_datasource.dart';
import '../shared_pref/dto/template_model.dart';

class TemplateRepositoryImp implements TemplatesRepository {
  final TemplateDatasource _templateDatasource;
  final ImagesDatasource _imagesDatasource;
  final ApiDatasource _apiDatasource;

  static const _templatesPathName = "templates";

  TemplateRepositoryImp({
    required TemplateDatasource templateDatasource,
    required ImagesDatasource imageDatasource,
    required ApiDatasource apiDatasource,
  }) : _templateDatasource = templateDatasource,
       _imagesDatasource = imageDatasource,
       _apiDatasource = apiDatasource;

  @override
  Stream<List<TemplateFull>> observeTemplates() {
    return _templateDatasource
        .observeTemplatesList()
        .map(
          (templateModels) =>
              templateModels.map((templateModel) => templateModel.template),
        )
        .asyncMap((templates) async {
          final templatesFullList = <TemplateFull>[];
          for (Template template in templates) {
            final bt = await _imagesDatasource.getTemplatesBytesData(
              templateImageName: template.imageName,
              templateDirectory: _templatesPathName,
            );
            if (bt == null) continue;
            final tm = TemplateFull(id: template.id, templateImageBytes: bt);
            templatesFullList.add(tm);
          }
          return templatesFullList;
        });

    // return Rx.combineLatest2<List<Template>, Directory, List<TemplateFull>>(
    //   _templatesRepository.observeItem().map(
    //     (templateModels) => templateModels == null
    //         ? []
    //         : templateModels.templates
    //               .map((templateModel) => templateModel.template)
    //               .toList(),
    //   ),
    //   getApplicationDocumentsDirectory().asStream(),
    //   (templates, docDirectory) {
    //     return templates.map((template) {
    //       final fullImagePath =
    //           "${docDirectory.absolute.path}${Platform.pathSeparator}${TemplateInteractor.templatesPathName}${Platform.pathSeparator}${template.imageName}";
    //       return TemplateFull(
    //         id: template.id,
    //         templateImageBytes: fullImagePath,
    //       );
    //     }).toList();
    //   },
    // );
  }

  @override
  Future<bool> saveTemplate({
    required final Uint8List fileBytes,
    required final String fileName,
  }) async {
    final newFileName = await _imagesDatasource.saveFileDataAndReturnItName(
      directoryWithFiles: _templatesPathName,
      filePath: fileName,
      fileBytesData: fileBytes,
    );
    return await _insertTemplateOrReplaceById(
      template: Template(id: Uuid().v4(), imageName: newFileName),
    );
  }

  @override
  Future<bool> saveTemplateFromNetwork({required String fileName}) async {
    return await _insertTemplateOrReplaceById(
      template: Template(id: Uuid().v4(), imageName: fileName),
    );
  }

  Future<bool> _insertTemplateOrReplaceById({
    required final Template template,
  }) async {
    final savedData = await _templateDatasource.getTemplates();
    final itemIndex = savedData.indexWhere(
      (item) => item.imageUrl == template.imageName,
    );
    if (itemIndex == -1) {
      savedData.add(TemplateModel.fromTemplate(template: template));
      return await _templateDatasource.setTemplates(templates: savedData);
    }
    return true;
  }

  @override
  Future<bool> deleteTemplate({required String templateId}) async {
    final savedData = await _templateDatasource.getTemplates();
    savedData.removeWhere((element) => element.id == templateId);
    return await _templateDatasource.setTemplates(templates: savedData);
  }

  @override
  Future<String?> uploadMemeFile({required String templateId}) async {
    final value = (await _templateDatasource.getTemplates()).firstWhereOrNull(
      (element) => element.id == templateId,
    );
    if (value != null) {
      final result = await _imagesDatasource.saveTemplateToMemesImages(
        templateFileName: value.imageUrl,
        templateDirectory: _templatesPathName,
        memeDirectory: MemeRepositoryImp.memesPathName,
      );
      return result;
    }
    return null;
  }

  @override
  Future<Either<ApiError, List<MemeApiData>>> getMemeTemplates() =>
      _apiDatasource.getMemeTemplates();

  @override
  Future<Message> downloadTemplate({required MemeApiData memeData}) async {
    log('!!! DOWNLOAD TEMPLATE: $memeData');
    if (!await _imagesDatasource.isTemplateFileExists(
      templateFilename: memeData.fileName,
      templatesDirectory: _templatesPathName,
    )) {
      log('!!! DOWNLOAD TEMPLATE: FILE NOT EXIST');
      final downloadTemplatesResult = await _apiDatasource.downloadTemplate(
        url: memeData.url,
      );
      if (downloadTemplatesResult.isLeft) {
        return Message(
          status: MessageStatus.error,
          message: 'Ошибка загрузки шаблона "${memeData.name}".',
        );
      }
      final savingResult = await saveTemplate(
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
      await _insertTemplateOrReplaceById(
        template: Template(id: Uuid().v4(), imageName: memeData.fileName),
      );
    }
    return Message(
      status: MessageStatus.success,
      message: 'Шаблон "${memeData.name}" успешно загружен и сохранен.',
    );
  }
}
