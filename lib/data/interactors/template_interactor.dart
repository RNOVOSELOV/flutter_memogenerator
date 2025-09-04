import 'package:memogenerator/data/interactors/copy_unique_file_interactor.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/template.dart';
import '../shared_pref/dto/template_model.dart';
import '../shared_pref/dto/templates_model.dart';
import '../shared_pref/datasources/templates/templates_datasource_impl.dart';

class TemplateInteractor {
  static const templatesPathName = "templates";

  final TemplatesDataSourceImpl _templateRepository;
  final CopyUniqueFileInteractor _copyUniqueFileInteractor;

  TemplateInteractor({
    required TemplatesDataSourceImpl templateRepository,
    required CopyUniqueFileInteractor copyUniqueFileInteractor,
  }) : _templateRepository = templateRepository,
       _copyUniqueFileInteractor = copyUniqueFileInteractor;

  @Deprecated('message')
  Future<bool> saveTemplate({required final String imagePath}) async {
    final newImagePath = await _copyUniqueFileInteractor.copyUniqueFile(
      directoryWithFiles: templatesPathName,
      filePath: imagePath,
    );
    return await _insertTemplateOrReplaceById(
      template: Template(id: Uuid().v4(), imageName: newImagePath),
    );
  }

  Future<bool> deleteTemplate({required final String id}) async {
    final savedData = (await _templateRepository.getItem())?.templates ?? [];
    savedData.removeWhere((element) => element.id == id);
    return await _templateRepository.setItem(
      TemplatesModel(templates: savedData),
    );
  }

  @Deprecated('message')
  Future<bool> _insertTemplateOrReplaceById({
    required final Template template,
  }) async {
    final savedData = (await _templateRepository.getItem())?.templates ?? [];
    final itemIndex = savedData.indexWhere(
      (item) => item.imageUrl == template.imageName,
    );
    // TODO CHECK THAT THIS WORK
    // final itemIndex = savedData.indexWhere((item) => item.id == template.id);
    if (itemIndex == -1) {
      savedData.add(TemplateModel.fromTemplate(template: template));
      return await _templateRepository.setItem(
        TemplatesModel(templates: savedData),
      );
    }
    return true;
  }
}
