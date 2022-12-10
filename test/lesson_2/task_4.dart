import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memogenerator/data/models/meme.dart';
import 'package:memogenerator/data/models/text_with_position.dart';
import 'package:memogenerator/data/repositories/memes_repository.dart';
import 'package:memogenerator/domain/interactors/save_meme_interactor.dart';
import 'package:memogenerator/presentation/create_meme/create_meme_page.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'shared.dart';

///
/// 4. Выносим логику с сохранением мема в interactor
///    Обязательное, 2 балла
///    1. В папке domain создаем папку interactors
///    2. В этой папке создаем файл save_meme_interactor.dart
///    3. В файле создаем класс SaveMemeInteractor
///    4. Добавляем factory конструктор getInstance() по аналогии с другими
///       классами (например, SharedPreferenceData)
///    5. Добавляем метод Future<bool> saveMeme, куда на вход передать 3
///       именованных параметра:
///        1. String id
///        2. List<TextWithPosition> textWithPositions
///        3. String? imagePath
///    6. Первые два параметра должны быть обязательными
///    7. Переносим логику из _saveMemeInternal в новый созданный метод
///    8. Вызываем в блоке вместо _saveMemeInternal метод saveMeme в новом
///       созданном классе
///
void runTestLesson2Task4() {
  final ps = Platform.pathSeparator;
  final testPathName = "test";

  final taskDocumentsPathName = "task_4_documents";
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
    PathProviderPlatform.instance = FakePathProviderPlatform(
      testPathName: testPathName,
      taskDocumentsPathName: taskDocumentsPathName,
    );
  });
  testWidgets('module4', (WidgetTester tester) async {
    await tester.runAsync(() async {
      print(
          "\n------------- Запускаем тест к 4 заданию 10-го урока -------------\n");

      SharedPreferences.setMockInitialValues({"meme_key": []});
      final docsDirectory = Directory("$testPathName$ps$taskDocumentsPathName");
      final docsDirectoryExists = await docsDirectory.exists();
      if (docsDirectoryExists) {
        await docsDirectory.delete(recursive: true);
      }
      final docsMemesDirectory = Directory("${docsDirectory.path}${ps}memes");
      print("SHOULD BE ${docsMemesDirectory.absolute.path}");
      final docsMemesPath = docsMemesDirectory.absolute.path;
      final imagesPath =
          Directory("$testPathName${ps}lesson_2${ps}task_4_files")
              .absolute
              .path;

      final firstId = Uuid().v4();
      final firstTextWithPositions = <TextWithPosition>[];
      final firstImageName = "image1.jpg";
      final firstImagePath = "$imagesPath$ps$firstImageName";
      final firstMemeGlobal = Meme(
        id: firstId,
        texts: firstTextWithPositions,
        memePath: "$docsMemesPath$ps$firstImageName",
      );

      final saveMemeInteractor = SaveMemeInteractor.getInstance();
      final memeRepository = MemesRepository.getInstance();

      print("Сохраняем мем через SaveMemeInteractor");
      saveMemeInteractor.saveMeme(
        id: firstId,
        textWithPositions: firstTextWithPositions,
        imagePath: firstImagePath,
      );
      await Future.delayed(Duration(milliseconds: 100));

      print(
          "Проверяем, что мем сохранен корректно и что картинке проставлен корректный путь, взятый из getApplicationDocumentsDirectory");
      expect(
        await memeRepository.getMemes(),
        [firstMemeGlobal],
        reason:
            "ОШИБКА! Сохраненные мемы из репозитория MemeRepository не совпадают с ожидаемыми",
      );

      final secondId = Uuid().v4();
      final secondTextWithPositions = <TextWithPosition>[];
      final secondImageName = "image2.jpg";
      final secondImagePath = "$imagesPath$ps$secondImageName";
      final secondMemeGlobal = Meme(
        id: secondId,
        texts: secondTextWithPositions,
        memePath: "$docsMemesPath$ps$secondImageName",
      );
      print("Сохраняем еще один мем через SaveMemeInteractor");
      saveMemeInteractor.saveMeme(
        id: secondId,
        textWithPositions: secondTextWithPositions,
        imagePath: secondImagePath,
      );

      await Future.delayed(Duration(milliseconds: 100));

      print(
          "Проверяем, что оба мема сохранены корректно и что картинкам проставлены корректные пути, взятые из getApplicationDocumentsDirectory");
      expect(
        await memeRepository.getMemes(),
        [firstMemeGlobal, secondMemeGlobal],
        reason:
            "ОШИБКА! Сохраненные мемы из репозитория MemeRepository не совпадают с ожидаемыми",
      );

      final thirdId = Uuid().v4();
      final thirdTextWithPositions = <TextWithPosition>[];
      final thirdImageName = "image3.jpg";
      final thirdImagePath = "$imagesPath$ps$thirdImageName";
      final thirdMemeGlobal = Meme(
        id: thirdId,
        texts: thirdTextWithPositions,
        memePath: "$docsMemesPath$ps$thirdImageName",
      );

      print(
          "Открываем страницу CreateMemePage, куда передаем картинку image3.jpg");

      await tester.pumpWidget(
        MaterialApp(
          home: CreateMemePage(id: thirdId, selectedMemePath: thirdImagePath),
        ),
      );

      final saveButtonFinder = find.byWidgetPredicate(
          (widget) => widget is Icon && widget.icon == Icons.save);

      print("Находим единственную кнопку с иконкой Icons.save");
      expect(
        saveButtonFinder,
        findsOneWidget,
        reason:
            "ОШИБКА! На странице CreateMemePage невозможно найти единственный виджет с иконкой Icons.save",
      );
      print("Тапаем на найденную кнопку");
      await tester.tap(saveButtonFinder);
      await tester.pumpAndSettle();

      await Future.delayed(Duration(milliseconds: 100));

      print("Проверяем, что третий мем сохранен корректно");
      expect(
        await memeRepository.getMemes(),
        [firstMemeGlobal, secondMemeGlobal, thirdMemeGlobal],
        reason:
            "ОШИБКА! Сохраненные мемы из репозитория MemeRepository не совпадают с ожидаемыми",
      );

      print("Удаляем папку с файлами, созданными в рамках тестирования");
      await docsDirectory.delete(recursive: true);

      print("------------- УСПЕХ! Тест пройден! -------------\n");
    });
  });
}
