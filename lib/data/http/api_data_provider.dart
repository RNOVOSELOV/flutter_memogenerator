import 'package:either_dart/either.dart';

import '../http/dto/memes_response.dart';
import '../http/models/api_error.dart';

abstract interface class ApiDataProvider {
  Future<Either<ApiError, MemesResponse>> getMemes();

  Future<Either<ApiError, bool>> getMemeTemplate({
    required final String url,
    required final String filePath,
  });
}
