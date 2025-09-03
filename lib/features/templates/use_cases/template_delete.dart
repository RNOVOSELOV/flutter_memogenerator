import 'package:memogenerator/domain/repositories/templates_repository.dart';

class TemplateDelete {
  final TemplatesRepository _templatesRepository;

  TemplateDelete({required TemplatesRepository templatesRepository})
    : _templatesRepository = templatesRepository;

  Future<bool> call({required final String templateId}) =>
      _templatesRepository.deleteTemplate(templateId: templateId);
}
