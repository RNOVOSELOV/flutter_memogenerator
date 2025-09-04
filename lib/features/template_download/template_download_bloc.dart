import 'package:either_dart/either.dart';
import 'package:memogenerator/features/template_download/use_cases/template_download.dart';
import 'package:rxdart/rxdart.dart';

import '../../data/http/models/api_error.dart';
import '../../data/http/models/meme_data.dart';
import '../../domain/entities/message.dart';
import 'use_cases/templates_get_from_api.dart';

class TemplateDownloadBloc {
  final TemplatesGetFromApi _getTemplatesFromApi;
  final TemplateDownload _downloadTemplate;

  final _messageController = PublishSubject<Message>();

  TemplateDownloadBloc({
    required final TemplatesGetFromApi getTemplatesFromApi,
    required final TemplateDownload downloadTemplate,
  }) : _getTemplatesFromApi = getTemplatesFromApi,
       _downloadTemplate = downloadTemplate;

  Future<Either<ApiError, List<MemeApiData>>> getMemeTemplates() =>
      _getTemplatesFromApi();

  Stream<Message> get messageStream => _messageController.stream;

  Future<void> saveTemplate({required final MemeApiData memeData}) async {
    final result = await _downloadTemplate(memeData: memeData);
    _messageController.sink.add(result);
  }

  void dispose() {
    _messageController.close();
  }
}
