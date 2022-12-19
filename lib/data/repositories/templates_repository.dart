import 'dart:convert';
import 'package:memogenerator/data/models/template.dart';
import 'package:memogenerator/data/shared_preference_data.dart';
import 'package:rxdart/rxdart.dart';
import 'package:collection/collection.dart';

class TemplatesRepository {
  final updater = PublishSubject<Null>();
  final SharedPreferenceData spData;

  static TemplatesRepository? instance;

  TemplatesRepository._internal(this.spData);

  factory TemplatesRepository.getInstance() => instance ??=
      TemplatesRepository._internal(SharedPreferenceData.getInstance());
  
  // Add template
  Future<bool> addToTemplates(final Template template) async {
    final templates = await getTemplates();
    final index = templates.indexWhere((element) => element.id == template.id);
    if (index == -1) {
      templates.add(template);
    } else {
      templates[index] = template;
    }
    return _setTemplates(templates);
  }

  // Remove template
  Future<bool> removeFromTemplates(final String id) async {
    final templates = await getTemplates();
    templates.removeWhere((template) => template.id == id);
    return _setTemplates(templates);
  }

  Stream<List<Template>> observeTemplates() async* {
    yield await getTemplates();
    await for (final _ in updater) {
      yield await getTemplates();
    }
  }

  Future<List<Template>> getTemplates() async {
    final rawTemplates = await spData.getTemplates();
    return rawTemplates
        .map((element) => Template.fromJson(json.decode(element)))
        .toList();
  }

  Future<Template?> getTemplate(final String id) async {
    final templates = await getTemplates();
    return templates.firstWhereOrNull((element) => element.id == id);
  }

  Future<bool> _setTemplates(final List<Template> templates) async {
    final rawTemplates =
    templates.map((element) => json.encode(element.toJson())).toList();
    return _setRawTemplates(rawTemplates);
  }

  Future<bool> _setRawTemplates(final List<String> rawTemplates) {
    updater.add(null);
    return spData.setTemplates(rawTemplates);
  }
}
