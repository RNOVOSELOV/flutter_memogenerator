import 'package:memogenerator/data/sp/models/template_model.dart';
import 'package:memogenerator/data/sp/repositories/templates/templates_repository.dart';
import 'package:memogenerator/domain/interactors/copy_unique_file_interactor.dart';
import 'package:uuid/uuid.dart';

import '../entities/template.dart';

class SaveTemplateInteractor {
  static const templatesPathName = "templates";
  static SaveTemplateInteractor? _instance;

  SaveTemplateInteractor._internal();

  factory SaveTemplateInteractor.getInstance() =>
      _instance ??= SaveTemplateInteractor._internal();

  Future<bool> saveTemplate({required final String imagePath}) async {
    final newImagePath = await CopyUniqueFileInteractor.getInstance()
        .copyUniqueFile(
          directoryWithFiles: templatesPathName,
          filePath: imagePath,
        );

    final template = Template(id: Uuid().v4(), imageUrl: newImagePath);
    return TemplatesRepository.getInstance().addItemOrReplaceById(
      TemplateModel.fromTemplate(template: template),
    );
  }
}
