import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:memogenerator/data/shared_pref/repositories/templates/templates_repository.dart';
import 'package:memogenerator/domain/interactors/template_interactor.dart';
import 'package:memogenerator/domain/entities/status.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';

import '../../data/http/domain/api_repository.dart';
import '../../data/http/domain/entities/api_error.dart';
import '../../data/http/domain/entities/meme_data.dart';
import '../../domain/entities/message.dart';

class TemplateDownloadBloc {
  final TemplatesRepository _templatesRepository;
  final TemplateInteractor _templateInteractor;
  final ApiRepository _apiRepository;

  final _messageController = PublishSubject<Message>();

  TemplateDownloadBloc({
    required TemplatesRepository templatesRepository,
    required TemplateInteractor templateInteractor,
    required ApiRepository apiRepository,
  }) : _templatesRepository = templatesRepository,
       _templateInteractor = templateInteractor,
       _apiRepository = apiRepository;

  Future<Either<ApiError, List<MemeData>>> getMemes() =>
      _apiRepository.getMemeTemplates();

  Stream<Message> get messageStream => _messageController.stream;

  Future<bool> imageFileExists(String fileName) async {
    final file = File(fileName);
    return await file.exists();
  }

  Future<void> saveTemplate({required final MemeData memeData}) async {
    final filePath =
        '${(await getApplicationCacheDirectory()).absolute.path}${Platform.pathSeparator}${memeData.fileName}';
    if (await imageFileExists(filePath)) {
      _messageController.sink.add(
        Message(
          status: Status.error,
          message: 'Шаблон "${memeData.name}" был загружен ранее.',
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
            status: Status.success,
            message: 'Шаблон "${memeData.name}" успешно загружен и сохранен.',
          ),
        );
        return;
      }
    }
    _messageController.sink.add(
      Message(
        status: Status.error,
        message: 'Ошибка загрузки шаблона "${memeData.name}".',
      ),
    );
  }

  void dispose() {
    _messageController.close();
  }
}
