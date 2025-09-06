import 'dart:typed_data';

import 'package:either_dart/either.dart';
import 'package:memogenerator/data/datasources/api_datasource.dart';

import '../http/api_data_provider.dart';
import '../http/models/api_error.dart';
import '../http/models/meme_data.dart';

class ApiDatasourceImpl implements ApiDatasource {
  final ApiDataProvider _apiDataProvider;

  ApiDatasourceImpl({required ApiDataProvider dataProvider})
    : _apiDataProvider = dataProvider;

  final List<MemeApiData> memeCache = [];

  /// Get memes request
  ///
  /// Return [ApiError] if some error happens or List of [MemeApiData]
  @override
  Future<Either<ApiError, List<MemeApiData>>> getMemeTemplates() async {
    if (memeCache.isNotEmpty) return Right(memeCache);

    final data = await _apiDataProvider.getAltMemes();
    if (data.isLeft) {
      return Left(data.left);
    }
    memeCache.addAll(data.right.map((meme) => MemeApiData.fromAltApi(memeDto: meme),));

    // memeCache.addAll(
    //   data.right.memesData.memes.map(
    //     (meme) => MemeApiData.fromApi(memeDto: meme),
    //   ),
    // );
    return Right(memeCache);
  }

  @override
  Future<Either<ApiError, Uint8List>> downloadTemplate({
    required final String url,
  }) async {
    final data = await _apiDataProvider.getMemeTemplate(url: url);
    if (data.isLeft) {
      return Left(data.left);
    }
    return Right(data.right);
  }
}
