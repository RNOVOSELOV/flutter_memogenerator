import 'package:either_dart/either.dart';

import '../../data/http/models/api_error.dart';
import '../../data/http/models/meme_data.dart';
import '../entities/message.dart';

abstract interface class DownloadRepository {
  Future<Either<ApiError, List<MemeApiData>>> getMemeTemplates();

  Future<Message> downloadTemplate({required final MemeApiData memeData});
}
