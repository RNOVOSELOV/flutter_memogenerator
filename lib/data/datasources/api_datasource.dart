import 'dart:typed_data';

import 'package:either_dart/either.dart';

import '../http/models/api_error.dart';
import '../http/models/meme_data.dart';

abstract interface class ApiDatasource {
  Future<Either<ApiError, List<MemeApiData>>> getMemeTemplates();

  Future<Either<ApiError, Uint8List>> downloadTemplate({
    required final String url,
  });
}
