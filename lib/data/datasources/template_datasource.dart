import 'package:memogenerator/data/shared_pref/dto/template_model.dart';

abstract interface class TemplateDatasource {
  // Stream<List<MemeModel>> observeMemesList();
  //
  // Future<List<MemeModel>> getMemeModels();
  //
  // Future<bool> setMemeModels({required final List<MemeModel> models});

  Future<List<TemplateModel>> getTemplates();

  Future<bool> setTemplates({required final List<TemplateModel> templates});
}
