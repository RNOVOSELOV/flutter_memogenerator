import 'package:memogenerator/domain/repositories/templates_repository.dart';

class TemplateToMemeUpload {
  final TemplatesRepository _templateRepository;

  TemplateToMemeUpload({required TemplatesRepository templateRepository})
    : _templateRepository = templateRepository;

  Future<String?> call({required final String templateId}) =>
      _templateRepository.uploadMemeFile(templateId: templateId);
}
