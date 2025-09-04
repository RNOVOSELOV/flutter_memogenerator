import 'dart:typed_data';

import 'package:either_dart/either.dart';

import '../../data/http/models/api_error.dart';
import '../../data/http/models/meme_data.dart';
import '../entities/message.dart';
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

  Future<Either<ApiError, List<MemeApiData>>> getMemeTemplates();

  Future<Message> downloadTemplate({required final MemeApiData memeData});
}
