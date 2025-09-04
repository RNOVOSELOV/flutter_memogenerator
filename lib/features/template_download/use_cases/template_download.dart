import 'package:memogenerator/domain/entities/message.dart';
import 'package:memogenerator/domain/repositories/templates_repository.dart';

import '../../../data/http/models/meme_data.dart';

class TemplateDownload {
  final TemplatesRepository _templateRepository;

  TemplateDownload({required TemplatesRepository templateRepository})
    : _templateRepository = templateRepository;

  Future<Message> call({required final MemeApiData memeData}) =>
      _templateRepository.downloadTemplate(memeData: memeData);
}
