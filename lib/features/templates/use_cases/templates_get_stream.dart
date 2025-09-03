import 'package:memogenerator/domain/entities/template_full.dart';
import 'package:memogenerator/domain/repositories/templates_repository.dart';

class TemplatesGetStream {
  final TemplatesRepository _templatesRepository;

  TemplatesGetStream({required TemplatesRepository templatesRepository})
    : _templatesRepository = templatesRepository;

  Stream<List<TemplateFull>> call() => _templatesRepository.observeTemplates();
}
