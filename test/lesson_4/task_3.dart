import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memogenerator/data/models/meme.dart';
import 'package:memogenerator/data/models/position.dart';
import 'package:memogenerator/data/models/text_with_position.dart';
import 'package:memogenerator/main.dart';
import 'package:memogenerator/presentation/create_meme/create_meme_page.dart';
import 'package:memogenerator/presentation/main/main_bloc.dart';
import 'package:memogenerator/presentation/main/main_page.dart';
import 'package:memogenerator/presentation/main/models/meme_thumbnail.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../shared/test_helpers.dart';

///
/// 3. Изменить метод observeMemesWithDocsPath
///    Занятие 12. Обязательное задание. 2 балла.
///
///    1. Необходимо переименовать этот метод на observeMemes()
///    2. Возвращать этот метод должен Stream<List<MemeThumbnail>>
///    3. MemeThumbnail — создать новый класс в папке presentation/main/models
///        1. В классе должно быть два поля: String memeId и String fullImageUrl
///        2. Класс должен иметь конструктор с этими полями — именованными и обязательными
///        3. Экземпляры этого классы должны сравниваться по значению своих переменных. Для этого можно использовать библиотеку Equatable
///    4. Реализовать логику метода observeMemes, в котором по аналогии с методом observeTemplates будет получаться на вход список с мемами и папка с документами приложения.
///        1. В качестве параметра fullImageUrl у создаваемых моделей MemeThumbnail нужно проставить корректную папку до thumbnail
///    5. В `CreatedMemesGrid` в StreamBuilder использовать новый тип получаемых данных.
///    6. В виджете MemeGridItem входящим параметром нужно сделать MemThumbnail memeThumbnail и обновить логику, чтобы все корректно работало
///    7. Файл lib/presentation/main/memes_with_docs_path.dart можно удалить
///
void runTestLesson4Task3() {
  final textWithPosition = TextWithPosition(
    id: Uuid().v4(),
    text: "Мем-мем",
    position: Position(top: 0, left: 0),
    fontSize: 30,
    color: Colors.black,
    fontWeight: FontWeight.w700,
  );

  final meme = Meme(id: Uuid().v4(), texts: [textWithPosition]);
  final memeThumbnail = MemeThumbnail(
      memeId: meme.id,
      fullImageUrl:
          "${Directory(kApplicationDocumentsPath).absolute.path}${Platform.pathSeparator}${meme.id}.png");
  final memeKey = "meme_key";

  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
    PathProviderPlatform.instance = FakePathProviderPlatform();
  });
  testWidgets('module3', (WidgetTester tester) async {
    fancyPrint(
      "Запускаем тест к 3 заданию 12-го урока",
      printType: PrintType.startEnd,
    );

    fancyPrint("Добавляем в SharedPreferences один мем для тестирования");
    SharedPreferences.setMockInitialValues(<String, Object>{
      memeKey: [jsonEncode(meme.toJson())]
    });

    await tester.pumpWidget(MyApp());
    await tester.pumpAndSettle();

    fancyPrint(
        "Проверяем, что метод observeMemes() внутри MainBloc имеет тип Stream<List<MemeThumbnail>>");
    MainBloc().observeMemes().startWith([memeThumbnail]);

    fancyPrint("Ищем на странице MainPage единственный виджет MemeGridItem");
    final memeGridItemFinder = find.byType(MemeGridItem);
    expect(
      memeGridItemFinder,
      findsOneWidget,
      reason:
          "ОШИБКА! На странице MainPage невозможно найти единственный виджет с типом 'MemeGridItem'",
    );

    fancyPrint("Проверяем, что параметр в MemeGridItem равен ожидаемому");
    final memeGridItem = tester.widget<MemeGridItem>(memeGridItemFinder);
    expect(
      memeGridItem.memeThumbnail,
      memeThumbnail,
      reason:
          "ОШИБКА! Параметр memeThumbnail в MemeGridItem не равен ожидаемому",
    );

    fancyPrint(
        "Переходим на страницу создания мема после нажатия на найденный MemeGridItem");
    await tester.tap(memeGridItemFinder);
    await tester.pumpAndSettle();

    fancyPrint("Ожидаем, что страница CreateMemePage открылась успешно");
    final createMemePageFinder = find.byType(CreateMemePage);

    expect(
      createMemePageFinder,
      findsOneWidget,
      reason:
          "ОШИБКА! Невозможно найти единственный виджет с типом 'CreateMemePage'",
    );

    fancyPrint(
        "Ожидаем, что на странице находится текст мема '${textWithPosition.text}'");
    final memeTextFinder = find.descendant(
      of: find.byType(MemeCanvasWidget),
      matching: find.text(textWithPosition.text),
    );
    expect(
      memeTextFinder,
      findsOneWidget,
      reason:
          "ОШИБКА! Невозможно найти единственный виджет с текстом '${textWithPosition.text}'",
    );

    fancyPrint(
      "УСПЕХ! Тест пройден!",
      printType: PrintType.startEnd,
    );
  });
}
