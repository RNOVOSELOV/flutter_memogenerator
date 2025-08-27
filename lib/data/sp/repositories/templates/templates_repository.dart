import 'dart:convert';

import 'package:memogenerator/data/sp/repositories/templates/template_data_provider.dart';

import '../../models/templates_model.dart';
import '../reactive_repository.dart';

class TemplatesRepository extends ReactiveRepository<TemplatesModel> {
  final TemplateDataProvider _dataProvider;

  TemplatesRepository({required TemplateDataProvider memeDataProvider})
    : _dataProvider = memeDataProvider;

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
