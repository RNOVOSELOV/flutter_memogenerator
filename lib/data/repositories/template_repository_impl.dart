import 'dart:developer';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:memogenerator/data/datasources/template_datasource.dart';
import 'package:memogenerator/data/repositories/meme_repository_impl.dart';
import 'package:memogenerator/domain/entities/template_full.dart';
import 'package:memogenerator/domain/repositories/templates_repository.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/template.dart';
import '../datasources/images_datasource.dart';
import '../shared_pref/dto/template_model.dart';

class TemplateRepositoryImp implements TemplatesRepository {
  final TemplateDatasource _templateDatasource;
  final ImagesDatasource _imagesDatasource;

  static const _templatesPathName = "templates";

  TemplateRepositoryImp({
    required TemplateDatasource templateDatasource,
    required ImagesDatasource imageDatasource,
  }) : _templateDatasource = templateDatasource,
       _imagesDatasource = imageDatasource;

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
}
