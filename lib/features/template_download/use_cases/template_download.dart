import 'package:memogenerator/domain/entities/message.dart';
import 'package:memogenerator/domain/repositories/download_repository.dart';
import 'package:memogenerator/domain/repositories/templates_repository.dart';

import '../../../data/http/models/meme_data.dart';

class TemplateDownload {
  final DownloadRepository _downloadRepository;

  TemplateDownload({required DownloadRepository downloadRepository})
    : _downloadRepository = downloadRepository;

  Future<Message> call({required final MemeApiData memeData}) =>
      _downloadRepository.downloadTemplate(memeData: memeData);
}
