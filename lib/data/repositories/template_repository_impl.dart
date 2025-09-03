import 'dart:typed_data';

import 'package:memogenerator/data/datasources/template_datasource.dart';
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

  // @override
  // Future<bool> deleteMeme({required final String memeId}) async {
  //   final savedData = await _memeDataSource.getMemeModels();
  //   savedData.removeWhere((element) => element.id == memeId);
  //   return await _memeDataSource.setMemeModels(models: savedData);
  // }
}
