import 'dart:convert';

import 'template_data_provider.dart';

import '../../models/templates_model.dart';
import '../reactive_repository.dart';

class TemplatesRepository extends ReactiveRepository<TemplatesModel> {
  final TemplateDataProvider _dataProvider;

  TemplatesRepository({required TemplateDataProvider templateDataProvider})
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
}
