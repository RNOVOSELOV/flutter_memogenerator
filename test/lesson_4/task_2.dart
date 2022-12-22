import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memogenerator/data/models/template.dart';
import 'package:memogenerator/main.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

import '../shared/test_helpers.dart';

///
/// 2. Сделать разные кнопки FloatingActionButton (FAB) на разных вкладках
///    Занятие 12. Обязательное задание. 3 балла.
///
///    1. Если мы находимся на вкладке СОЗДАННЫЕ, должна показываться кнопка FAB
///       с текстом +Мем. При нажатии на нее должно происходить то же самое, что
///       и было. То есть меняем только текст с Создать на Мем.
///    2. Если же мы находимся на вкладке ШАБЛОНЫ, то мы должны видеть кнопку
///       FAB с текстом +Шаблон. При нажатии на эту кноку должен открываться
///       пикер картинок. При выборе какой-то картинки, пикер должен
///       сворачиваться, а картинка должна добавляться в сохраненные шаблоны.
///    3. По возможности подумайте как добавить анимацию смены кнопок FAB при
///       перелистывании или свайпах между табами.
///
void runTestLesson4Task2() {
  int callsCount = 0;
  final imageName = "image.png";
  final imagePath = 'test/lesson_4/task_2_docs/$imageName';
  final values = <String, dynamic>{};

  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
    PathProviderPlatform.instance = FakePathProviderPlatform();
    TestWidgetsFlutterBinding.ensureInitialized();

    final appDocsDir = Directory("$kApplicationDocumentsPath");
    if (appDocsDir.existsSync()) {
      appDocsDir.deleteSync(recursive: true);
    }

    MethodChannel('plugins.flutter.io/image_picker')
      ..setMockMethodCallHandler((MethodCall methodCall) async {
        if (methodCall.method == "pickImage") {
          final shouldReturnImage = callsCount % 2 == 1;
          callsCount++;
          return shouldReturnImage ? File(imagePath).absolute.path : null;
        }
      });
    const MethodChannel('plugins.flutter.io/shared_preferences')
        .setMockMethodCallHandler((MethodCall methodCall) async {
      print("$methodCall");
      if (methodCall.method == 'getAll') {
        return values;
      } else if (methodCall.method.startsWith("set")) {
        values[methodCall.arguments["key"]] = methodCall.arguments["value"];
        return true;
      }
      return null;
    });
  });

  testWidgets('module2', (WidgetTester tester) async {
    await tester.runAsync(() async {
      fancyPrint(
        "Запускаем тест к 2 заданию 12-го урока",
        printType: PrintType.startEnd,
      );

      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();

      final memeText = 'Мем';
      fancyPrint(
          "Ищем на странице MainPage единственный виджет c текстом '$memeText'");
      final addMemeButtonFinder = find.text(memeText);
      expect(
        addMemeButtonFinder,
        findsOneWidget,
        reason:
            "ОШИБКА! На странице MainPage невозможно найти единственный виджет с текстом '$memeText'",
      );

      // fancyPrint(
      //     "Тапаем на кнопку с текстом +Мем. Не выбираем ни одной картинки. Ожидаем, что страница CreateMemePage не откроется");
      // await tester.tap(addMemeButtonFinder);
      // await tester.pumpAndSettle();
      //
      // expect(
      //   find.byType(CreateMemePage),
      //   findsNothing,
      //   reason:
      //       "ОШИБКА! Открылась страница CreateMemePage, хотя не должна была",
      // );
      //
      // fancyPrint(
      //     "Тапаем на кнопку с текстом +Мем. Выбираем картинку. Ожидаем, что страница CreateMemePage откроется");
      // await tester.tap(addMemeButtonFinder);
      //
      // await Future.delayed(Duration(milliseconds: 200));
      // await tester.pumpAndSettle();
      // await tester.idle();
      //
      // expect(
      //   find.byType(CreateMemePage),
      //   findsOneWidget,
      //   reason:
      //       "ОШИБКА! Страница CreateMemePage не открылась, хотя должна была",
      // );
      //
      // await Future.delayed(Duration(milliseconds: 500));
      // await tester.pumpAndSettle();
      // await tester.idle();
      //
      // await tester.pumpWidget(MyApp());
      // await tester.pumpAndSettle();
      //
      // await Future.delayed(Duration(milliseconds: 500));
      // await tester.pumpAndSettle();
      // await tester.idle();
      //
      // expect(
      //   find.byType(CreateMemePage),
      //   findsNothing,
      //   reason:
      //   "ОШИБКА! Страница asd не открылась, хотя должна была",
      // );

      final templatesText = 'ШАБЛОНЫ';
      fancyPrint("Ищем на странице вкладку с текстом '$templatesText'");
      final templatesButtonFinder = find.text(templatesText);
      expect(
        addMemeButtonFinder,
        findsOneWidget,
        reason:
            "ОШИБКА! На странице MainPage невозможно найти виджет с текстом '$templatesText'",
      );

      fancyPrint("Нажимаем на вкладку с текстом '${templatesText}'");
      await tester.tap(templatesButtonFinder);
      await tester.pumpAndSettle();

      final templateText = 'Шаблон';
      fancyPrint(
          "Ищем на странице MainPage единственный виджет c текстом '$templateText'");
      final addTemplateButtonFinder = find.text(templateText);
      expect(
        addTemplateButtonFinder,
        findsOneWidget,
        reason:
            "ОШИБКА! На странице MainPage невозможно найти единственный виджет с текстом '$templateText'",
      );

      fancyPrint(
          "Тапаем на кнопку с текстом +Шаблон. Не выбираем ни одной картинки. Ожидаем, что страница шаблон не будет добавлен");
      await tester.tap(addTemplateButtonFinder);
      await tester.pumpAndSettle();

      expect(
        values,
        <String, dynamic>{},
        reason: "ОШИБКА! Шаблон добавлен, хотя не должен был",
      );

      fancyPrint(
          "Тапаем на кнопку с текстом +Шаблон. Выбираем картинку. Ожидаем, что страница CreateMemePage откроется");
      await tester.tap(addTemplateButtonFinder);

      await Future.delayed(Duration(milliseconds: 100));
      await tester.pumpAndSettle();

      fancyPrint(
          "Получаем список сохранненых шаблонов. Ожидаем, что список существует");

      final savedTemplates = values["flutter.template_key"];

      expect(
        savedTemplates,
        isNotNull,
        reason: "ОШИБКА! Сохраненные шаблоны отсутствуют",
      );

      fancyPrint("Ожидаем, что в списке сохраненных шаблонов 1 элемент");

      final savedTemplateString = savedTemplates as List<Object?>;
      expect(
        savedTemplateString.length,
        1,
        reason: "ОШИБКА! В списке с сохраненными шаблонами не 1 элемент",
      );

      fancyPrint("Проверяем, что сохраненный шаблон имеет нужное имя файла");

      final firstElement = savedTemplateString.first;
      final template = Template.fromJson(json.decode(firstElement as String));

      expect(
        template.imageUrl,
        imageName,
        reason: "ОШИБКА! Сохраненный шаблон имеет неверное имя файла",
      );

      fancyPrint("Удаляем файлы, созданные во время тестирования");

      final appDocsDir = Directory("$kApplicationDocumentsPath");
      if (appDocsDir.existsSync()) {
        appDocsDir.deleteSync(recursive: true);
      }

      fancyPrint(
        "УСПЕХ! Тест пройден!",
        printType: PrintType.startEnd,
      );
    });
  });
}
