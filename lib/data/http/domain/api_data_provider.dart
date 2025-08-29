import 'package:either_dart/either.dart';

import '../model/memes_response.dart';
import 'entities/api_error.dart';

abstract interface class ApiDataProvider {
  Future<Either<ApiError, MemesResponse>> getMemes();

  Future<Either<ApiError, bool>> getMemeTemplate({
    required final String url,
    required final String filePath,
  });
}
