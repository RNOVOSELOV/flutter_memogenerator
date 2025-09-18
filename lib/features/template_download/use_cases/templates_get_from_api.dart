import 'package:either_dart/either.dart';
import 'package:memogenerator/domain/repositories/download_repository.dart';

import '../../../data/http/models/api_error.dart';
import '../../../data/http/models/meme_data.dart';

class TemplatesGetFromApi {
  final DownloadRepository _downloadRepository;

  TemplatesGetFromApi({required DownloadRepository downloadRepository})
    : _downloadRepository = downloadRepository;

  Future<Either<ApiError, List<MemeApiData>>> call() =>
      _downloadRepository.getMemeTemplates();
}
