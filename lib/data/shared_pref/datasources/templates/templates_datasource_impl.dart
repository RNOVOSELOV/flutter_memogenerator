import 'dart:convert';

import 'package:memogenerator/data/datasources/template_datasource.dart';
import 'package:memogenerator/data/shared_pref/dto/template_model.dart';

import 'template_data_provider.dart';

import '../../dto/templates_model.dart';
import '../reactive_sp_datasource.dart';

class TemplatesDataSourceImpl
    extends ReactiveSharedPreferencesDatasource<TemplatesModel>
    implements TemplateDatasource {
  final TemplateDataProvider _dataProvider;

  TemplatesDataSourceImpl({required TemplateDataProvider templateDataProvider})
    : _dataProvider = templateDataProvider;

  @override
  TemplatesModel convertFromString(String rawItem) =>
      TemplatesModel.fromJson(json.decode(rawItem));

  @override
  String convertToString(TemplatesModel item) => json.encode(item.toJson());

  @override
  Future<String?> getRawData() => _dataProvider.getTemplatesData();

  @override
  Future<bool> saveRawData(String? item) =>
      _dataProvider.setTemplatesData(item);

  @override
  Future<List<TemplateModel>> getTemplates() async {
    return (await getItem())?.templates ?? [];
  }

  @override
  Future<bool> setTemplates({
    required final List<TemplateModel> templates,
  }) async {
    return await setItem(TemplatesModel(templates: templates));
  }

  @override
  Stream<List<TemplateModel>> observeTemplatesList() =>
      observeItem().map((model) => model == null ? [] : model.templates);
}
