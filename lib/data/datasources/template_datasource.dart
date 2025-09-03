import 'package:memogenerator/data/shared_pref/dto/template_model.dart';

abstract interface class TemplateDatasource {
  Stream<List<TemplateModel>> observeTemplatesList();

  Future<List<TemplateModel>> getTemplates();

  Future<bool> setTemplates({required final List<TemplateModel> templates});
}
