import 'package:memogenerator/data/sp/models/template_model.dart';
import 'package:memogenerator/data/sp/models/templates_model.dart';
import 'package:memogenerator/data/sp/repositories/templates/templates_repository.dart';
import 'package:memogenerator/domain/interactors/copy_unique_file_interactor.dart';
import 'package:uuid/uuid.dart';

import '../entities/template.dart';

class SaveTemplateInteractor {
  static const templatesPathName = "templates";

  final TemplatesRepository _templateRepository;

  SaveTemplateInteractor({required TemplatesRepository templateRepository})
    : _templateRepository = templateRepository;

  Future<bool> saveTemplate({required final String imagePath}) async {
    final newImagePath = await CopyUniqueFileInteractor.getInstance()
        .copyUniqueFile(
          directoryWithFiles: templatesPathName,
          filePath: imagePath,
        );
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
    final itemIndex = savedData.indexWhere((item) => item.id == template.id);
    if (itemIndex == -1) {
      savedData.add(TemplateModel.fromTemplate(template: template));
    } else {
      savedData[itemIndex] = TemplateModel.fromTemplate(template: template);
    }
    return await _templateRepository.setItem(
      TemplatesModel(templates: savedData),
    );
  }
}
