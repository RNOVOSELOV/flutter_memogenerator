import 'dart:developer';

import 'package:memogenerator/data/shared_pref/models/template_model.dart';
import 'package:memogenerator/data/shared_pref/models/templates_model.dart';
import 'package:memogenerator/data/shared_pref/repositories/templates/templates_repository.dart';
import 'package:memogenerator/domain/interactors/copy_unique_file_interactor.dart';
import 'package:uuid/uuid.dart';

import '../entities/template.dart';

class TemplateInteractor {
  static const templatesPathName = "templates";

  final TemplatesRepository _templateRepository;
  final CopyUniqueFileInteractor _copyUniqueFileInteractor;

  TemplateInteractor({
    required TemplatesRepository templateRepository,
    required CopyUniqueFileInteractor copyUniqueFileInteractor,
  }) : _templateRepository = templateRepository,
       _copyUniqueFileInteractor = copyUniqueFileInteractor;

  Future<bool> saveTemplate({required final String imagePath}) async {
    final newImagePath = await _copyUniqueFileInteractor.copyUniqueFile(
      directoryWithFiles: templatesPathName,
      filePath: imagePath,
    );
    log('!!! NEW PATH $newImagePath');
    return await _insertTemplateOrReplaceById(
      template: Template(id: Uuid().v4(), imageUrl: newImagePath),
    );
  }

  Future<bool> deleteTemplate({required final String id}) async {
    final savedData = (await _templateRepository.getItem())?.templates ?? [];
    savedData.removeWhere((element) => element.id == id);
    return await _templateRepository.setItem(
      TemplatesModel(templates: savedData),
    );
  }

  Future<bool> _insertTemplateOrReplaceById({
    required final Template template,
  }) async {
    final savedData = (await _templateRepository.getItem())?.templates ?? [];
    final itemIndex = savedData.indexWhere(
      (item) => item.imageUrl == template.imageUrl,
    );
    // TODO CHECK THAT THIS WORK
    // final itemIndex = savedData.indexWhere((item) => item.id == template.id);
    if (itemIndex == -1) {
      savedData.add(TemplateModel.fromTemplate(template: template));
      log('!!! SD: $savedData\nII: $itemIndex');
      return await _templateRepository.setItem(
        TemplatesModel(templates: savedData),
      );
    }
    log('!!! SD: $savedData\nII: $itemIndex');
    return true;
  }
}
