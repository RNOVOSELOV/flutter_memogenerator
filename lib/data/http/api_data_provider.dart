import 'dart:typed_data';

import 'package:either_dart/either.dart';

import '../http/dto/memes_response.dart';
import '../http/models/api_error.dart';
import 'dto/alt_meme_dto.dart';

abstract interface class ApiDataProvider {
  Future<Either<ApiError, MemesResponse>> getMemes();

  Future<Either<ApiError, List<AltMemeDto>>> getAltMemes();

  Future<Either<ApiError, Uint8List>> getMemeTemplate({
    required final String url,
  });
}
