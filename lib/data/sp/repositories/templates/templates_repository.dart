import 'dart:convert';

import '../../models/template_model.dart';
import '../reactive_repository.dart';
import '../../shared_preference_data.dart';

class TemplatesRepository extends ReactiveRepository<TemplateModel> {
  final SharedPreferenceData spData;

  static TemplatesRepository? instance;

  TemplatesRepository._internal(this.spData);

  factory TemplatesRepository.getInstance() => instance ??=
      TemplatesRepository._internal(SharedPreferenceData.getInstance());

  @override
  TemplateModel convertFromString(String rawItem) =>
      TemplateModel.fromJson(json.decode(rawItem));

  @override
  String convertToString(TemplateModel item) => json.encode(item.toJson());

  @override
  dynamic getId(TemplateModel item) => item.id;

  @override
  Future<List<String>> getRawData() => spData.getTemplates();

  @override
  Future<bool> saveRawData(List<String> items) => spData.setTemplates(items);
}
