import 'dart:io';

import 'package:memogenerator/domain/entities/template.dart';
import 'package:memogenerator/data/interactors/template_interactor.dart';
import 'package:memogenerator/features/templates/domain/models/template_full.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';

import '../../data/shared_pref/datasources/templates/templates_datasource_impl.dart';

class TemplatesBloc {
  final TemplatesDataSourceImpl _templatesRepository;
  final TemplateInteractor _templateInteractor;

  TemplatesBloc({
    required TemplatesDataSourceImpl templatesRepository,
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
                "${docDirectory.absolute.path}${Platform.pathSeparator}${TemplateInteractor.templatesPathName}${Platform.pathSeparator}${template.imageName}";
            return TemplateFull(id: template.id, fullImagePath: fullImagePath);
          }).toList();
        },
      );

  void deleteTemplate(final String templateId) {
    _templateInteractor.deleteTemplate(id: templateId);
  }

  void dispose() {}
}
