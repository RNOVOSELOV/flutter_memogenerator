import 'dart:typed_data';

import '../entities/template_full.dart';

abstract interface class TemplatesRepository {
  Stream<List<TemplateFull>> observeTemplates();

  Future<bool> saveTemplate({
    required String fileName,
    required final Uint8List fileBytes,
  });

  Future<String?> uploadMemeFile({required String templateId});

  Future<bool> deleteTemplate({required final String templateId});
}
