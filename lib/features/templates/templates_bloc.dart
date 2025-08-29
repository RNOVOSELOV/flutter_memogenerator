import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:memogenerator/data/shared_pref/repositories/templates/templates_repository.dart';
import 'package:memogenerator/data/shared_pref/shared_preference_data.dart';
import 'package:memogenerator/domain/entities/template.dart';
import 'package:memogenerator/domain/interactors/template_interactor.dart';
import 'package:memogenerator/features/templates/domain/models/template_full.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';

class TemplatesBloc {
  final TemplatesRepository _templatesRepository;
  final TemplateInteractor _templateInteractor;

  TemplatesBloc({
    required TemplatesRepository templatesRepository,
    required TemplateInteractor templateInteractor,
  }) : _templatesRepository = templatesRepository,
       _templateInteractor = templateInteractor;

  Stream<List<TemplateFull>> observeTemplates() =>
      Rx.combineLatest2<List<Template>, Directory, List<TemplateFull>>(
        _templatesRepository.observeItem().map(
          (templateModels) => templateModels == null
              ? []
              : templateModels.templates
                    .map((templateModel) => templateModel.template)
                    .toList(),
        ),
        getApplicationDocumentsDirectory().asStream(),
        (templates, docDirectory) {
          return templates.map((template) {
            final fullImagePath =
                "${docDirectory.absolute.path}${Platform.pathSeparator}${TemplateInteractor.templatesPathName}${Platform.pathSeparator}${template.imageUrl}";
            return TemplateFull(id: template.id, fullImagePath: fullImagePath);
          }).toList();
        },
      );

  Future<void> addTemplate() async {
    final xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    final imagePath = xFile?.path;
    if (imagePath != null) {
      await _templateInteractor.saveTemplate(imagePath: imagePath);
    }
  }

  void deleteTemplate(final String templateId) {
    _templateInteractor.deleteTemplate(id: templateId);
  }

  void dispose() {}
}
