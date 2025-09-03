import 'dart:typed_data';

import 'package:memogenerator/domain/repositories/templates_repository.dart';

class TemplateSave {
  final TemplatesRepository _templateRepository;

  TemplateSave({required TemplatesRepository templateRepository})
    : _templateRepository = templateRepository;

  Future<bool> call({
    required final Uint8List fileBytesData,
    required final String fileName,
  }) => _templateRepository.saveTemplate(
    fileName: fileName,
    fileBytes: fileBytesData,
  );
}
