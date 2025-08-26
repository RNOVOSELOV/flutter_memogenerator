import 'dart:convert';
import 'package:memogenerator/data/models/template.dart';
import 'package:memogenerator/data/repositories/reactive_repository.dart';
import 'package:memogenerator/data/shared_preference_data.dart';

class TemplatesRepository extends ReactiveRepository<Template> {
  final SharedPreferenceData spData;

  static TemplatesRepository? instance;

  TemplatesRepository._internal(this.spData);

  factory TemplatesRepository.getInstance() => instance ??=
      TemplatesRepository._internal(SharedPreferenceData.getInstance());

  @override
  Template convertFromString(String rawItem) =>
      Template.fromJson(json.decode(rawItem));

  @override
  String convertToString(Template item) => json.encode(item.toJson());

  @override
  dynamic getId(Template item) => item.id;

  @override
  Future<List<String>> getRawData() => spData.getTemplates();

  @override
  Future<bool> saveRawData(List<String> items) => spData.setTemplates(items);
}
