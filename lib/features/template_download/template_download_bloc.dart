import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:memogenerator/data/interactors/template_interactor.dart';
import 'package:memogenerator/domain/entities/message_status.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';

import '../../data/http/api_datasource.dart';
import '../../data/http/models/api_error.dart';
import '../../data/http/models/meme_data.dart';
import '../../data/shared_pref/datasources/templates/templates_datasource_impl.dart';
import '../../domain/entities/message.dart';

class TemplateDownloadBloc {
  final TemplatesDataSourceImpl _templatesRepository;
  final TemplateInteractor _templateInteractor;
  final ApiDatasource _apiRepository;

  final _messageController = PublishSubject<Message>();

  TemplateDownloadBloc({
    required TemplatesDataSourceImpl templatesRepository,
    required TemplateInteractor templateInteractor,
    required ApiDatasource apiRepository,
  }) : _templatesRepository = templatesRepository,
       _templateInteractor = templateInteractor,
       _apiRepository = apiRepository;

  Future<Either<ApiError, List<MemeApiData>>> getMemes() =>
      _apiRepository.getMemeTemplates();

  Stream<Message> get messageStream => _messageController.stream;

  Future<bool> imageFileExists(String fileName) async {
    final file = File(fileName);
    return await file.exists();
  }

  Future<void> saveTemplate({required final MemeApiData memeData}) async {
    final filePath =
        '${(await getApplicationCacheDirectory()).absolute.path}${Platform.pathSeparator}${memeData.fileName}';
    if (await imageFileExists(filePath)) {
      _messageController.sink.add(
        Message(
          status: MessageStatus.error,
          message:
              'Загрузка не требуется. Шаблон "${memeData.name}" уже сохранен в галерее.',
        ),
      );
      return;
    }

    final result = await _apiRepository.downloadTemplate(
      url: memeData.url,
      filePath: filePath,
    );
    if (result.isRight) {
      final result = await _templateInteractor.saveTemplate(
        imagePath: filePath,
      );
      if (result) {
        _messageController.sink.add(
          Message(
            status: MessageStatus.success,
            message: 'Шаблон "${memeData.name}" успешно загружен и сохранен.',
          ),
        );
        return;
      }
    }
    _messageController.sink.add(
      Message(
        status: MessageStatus.error,
        message: 'Ошибка загрузки шаблона "${memeData.name}".',
      ),
    );
  }

  void dispose() {
    _messageController.close();
  }
}
