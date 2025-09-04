import 'package:either_dart/either.dart';
import 'package:memogenerator/domain/repositories/templates_repository.dart';

import '../../../data/http/models/api_error.dart';
import '../../../data/http/models/meme_data.dart';

class TemplatesGetFromApi {
  final TemplatesRepository _templateRepository;

  TemplatesGetFromApi({required TemplatesRepository templateRepository})
    : _templateRepository = templateRepository;

  Future<Either<ApiError, List<MemeApiData>>> call() =>
      _templateRepository.getMemeTemplates();
}
