import 'dart:typed_data';
import '../entities/template.dart';
import '../entities/template_full.dart';

abstract interface class TemplatesRepository {
  Stream<List<TemplateFull>> observeTemplates();

  Future<bool> saveTemplate({
    required String fileName,
    required final Uint8List fileBytes,
  });

  Future<bool> saveTemplateFromNetwork({required String fileName});

  Future<String?> uploadMemeFile({required String templateId});

  Future<bool> deleteTemplate({required final String templateId});

  Future<bool> insertTemplateOrReplaceById({required final Template template});

  String get templatePathName;

  Future<int> getCacheSize ();
}
